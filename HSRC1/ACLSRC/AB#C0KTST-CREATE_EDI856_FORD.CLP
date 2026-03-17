             PGM
             /** AB#C0K ****************************************************/
             /*  EDI(856) GENTRAN  FORD                                    */
             /*  JW1   04/08/16 ADD SAVE AB#EP63/64/65/66                  */
             /* %0001 08/04/16 CHANGE LIST TO E-MAIL   T.SAKAKI            */
             /* %0002 10/22/16 ADD MUTIPLE PROCESS CONTROL T.SAKAKI        */
             /* %0003 11/30/16 MIGRATE TO NEW EDI          T.SAKAKI        */
             /*  JW2   03/29/17 CHANGE EDSR65'S RUN TIMING                 */
             /*  JW3   07/22/20 ADD MONMSG AFTER CPYSPLF                   */
             /*  JW4   11/17/20 ADD JCMR10                                 */
             /*  "     11/23/20 CHG ERROR MSG                              */
             /*  JW6   09/28/23 ADD JW ADDRESS                             */
             /*  JW7   07/11/24 CHK REC# OF MITANKF                        */
             /*  JW8   05/08/25 ADD AB#R13F UNIVERSAL ASN DATA             */
             /*  JW8   06/05/25 ADD TEMP TEST PROCESS                      */
             /**************************************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIPGMN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POWSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POUSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POKONA) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POSTTS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PMSG)  TYPE(*CHAR) LEN(256)
             DCL        VAR(&REC1)  TYPE(*DEC)  LEN(10 0)
             DCL        VAR(&RTN1)  TYPE(*CHAR) LEN(1)

             DCLF       FILE(AB#PW0G)

/* JW2 CHECK OTHER USER IS USING  ==================================*/
             CALL CHKC45 ('AB#C0K' 'AB#C0K' 'Y'  'CHK' &RTN1)
             IF         COND(&RTN1 *NE ' ') THEN(GOTO END3)
/* =================================================================*/

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             CHGJOB     SWS(00000000)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

 /* %0002  CHECK AND REGISTER TO APLPP80 */
 /**         CHGVAR     VAR(&PIPGMN) VALUE('AB#C0K    ')                 **/
 /**         CALL       PGM(APLR80) PARM(&PIPGMN &POWSID &POUSID +       **/
 /**                      &POKONA &POSTTS)                               **/
 /**JW4**/
 /**JW    IF         COND(&POSTTS *EQ '2') THEN(DO)                      **/
 /**         CHGVAR     VAR(&PMSG) VALUE(&POUSID *BCAT &POKONA *BCAT +   **/
 /**                      'IS USING AT' *BCAT &POWSID *TCAT '* NOW. +    **/
 /**                      PLEASE TRY AGAIN LATER.(AB#C0K-APLPP80)')      **/
 /**         CALL       PGM(QUILNGTX) PARM(&PMSG X'00000046' '       +   **/
 /**                      ' '                    ' X'00000000')          **/
 /**         GOTO END2                                                   **/
 /**         ENDDO                                                       **/

/**          ALCOBJ     OBJ((AB#EP66 *FILE *EXCLRD)) WAIT(3)             **/
/**          MONMSG     MSGID(CPF0000) EXEC(DO)                          **/
/**          CALL       PGM(QUILNGTX) PARM('ANOTHER USER IS USING +      **/
/**                       THIS PROGRAM. PLEASE TRY LATER. (AB#C0K)' +    **/
/**                       X'00000046' '       ' +                        **/
/**                       '                    ' X'00000000')            **/
/**          GOTO END1                                                   **/
/**          ENDDO                                                       **/


             CRTDUPOBJ  OBJ(MITANKF) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/MITANKF)
             CRTDUPOBJ  OBJ(AB#WP34) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/AB#WP34)

             OVRDBF     FILE(MITANKF) TOFILE(QTEMP/MITANKF)
             OVRDBF     FILE(AB#WP34) TOFILE(QTEMP/AB#WP34)

 /* MAIN PROGRAM  -> AB#EP63,64,65,66 */
             CALL       PGM(AB#R0K)

        /* JW1 2016.04.08 ADDED: SAVE AB#EP63/64/65/66    */
             CALL       PGM(EDSR64)

/** JW8 - TEMP STOP****************************************/
             IF         COND((&USER = 'I3084') *OR (&USER = +
                          'I0777')) THEN(DO)
             GOTO       END1
             ENDDO
/**********************************************************/

 /* UNIT PRICE ERROR */
             IF         (%SWITCH(X1XXXXXX)) DO

 /*JW7 CHECK MITANKF */
             RTVMBRD    FILE(QTEMP/MITANKF) NBRCURRCD(&REC1)
             IF         COND(&REC1 *EQ 0) THEN(GOTO SKIP1)

 /* PRINT MITANKF TO QPRINT */
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(LANPRT50) +
                          FORMTYPE(K6H1) HOLD(*YES) IGCDTA(&PIGCD)
             CALL       PGM(AB#R0D)

             CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT132B) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
 /*JW3*/
             MONMSG     MSGID(CPF3429) EXEC(GOTO SKIP1)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132B)
             CALL       PGM(AB#RW0)

             SNDDST     TYPE(*FILE) TOINTNET((SalesGroup@iafi.com) +
                          (*NONE *CC)) DSTD('Unit price not +
                          registered') MSG('Unit price of some +
                          parts is not registered when sending ASN. +
                          Please check the attached +
                          report.(AB#C0K).') +
                          DOCFILE(HWFILE1/PRT132B) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD('EDI 856 (Ford) Unit +
                          price not registered')

      /**JW6 **/
      /**    SNDDST     TYPE(*FILE) TOINTNET((Kaz.Watanabe@iafi.com) + **/
      /**                 (*NONE *CC)) DSTD('Unit price not +          **/
      /**                 registered') MSG('Unit price of some +       **/
      /**                 parts is not registered when sending ASN. +  **/
      /**                 Please check the attached +                  **/
      /**                 report.(AB#C0K).') +                         **/
      /**                 DOCFILE(HWFILE1/PRT132B) DOCTYPE(*FFT) +     **/
      /**                 SNDFMT(*NOTE) DOCD('EDI 856 (Ford) Unit +    **/
      /**                 price not registered')                       **/

             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(PRT132)

             ENDDO
SKIP1:

 /* POST SALES DATA ->AB#PP10,AB#PP01 */
             IF         (%SWITCH(1XXXXXXX)) DO
             OVRDBF     FILE(AB#WP34) TOFILE(QTEMP/AB#WP34)
             CALL       PGM(AB#RE9)
             DLTOVR     FILE(*ALL)
             ENDDO

        /* JW2  2016.11.30 ADDED: SAVE TO EB#EPXX   */
             CALL       PGM(EDSR65)

        /* JW1 2016.04.08 ADDED: SAVE AB#EP63/64/65/66    */
             CALL       PGM(EDSR64)

        /* JW4 2020.11.17 ADDED: UPDATE JCOM FILE         */
             CALL       PGM(JCMR10)

/*** #SWITCH B2B-GENTRAN# *********************************/
/** RUN GENTRAN                                       *****/
/**          GOTO       CMDLBL(END1)                  *****/
/** RUN B2B                                           *****/
             GOTO       CMDLBL(B2B)
/**********************************************************/

B2B:
        /*--------------------------------*/
        /* %0003  MIGRATE TO NEW EDI DATA */
        /*--------------------------------*/
             RTVMBRD    FILE(EB#EP66) NBRCURRCD(&REC1)
             IF         (&REC1 *GT 0) THEN(DO)

     /* NEW EDI PROGRAM  */
             CALL       PGM(EJCC01)

             ENDDO

        /* JW8  2025.05.08 ADDED: UNIVERSAL ASN DATA      */
             CALL       PGM(AB#C13F)

             CLRPFM     FILE(AB#EP63)
             CLRPFM     FILE(AB#EP64)
             CLRPFM     FILE(AB#EP65)
             CLRPFM     FILE(AB#EP66)

 END1:
 /**         DLCOBJ     OBJ((AB#EP66 *FILE *EXCLRD))   **/
 /**         MONMSG     MSGID(CPF0000)                 **/
 /**         RCLRSC                                    **/

          /*--------------------------------------------*/
          /* %0002  UNLOCK MULTIPLE CONTROL             */
          /*--------------------------------------------*/
          /*** CALL       PGM(APLR81) PARM(&PIPGMN)   ***/

 END2:
          /* DISPLAY AFTER ASN DATA IS SENT */
             IF         (%SWITCH(XX1XXXXX)) DO
             SNDRCVF    RCDFMT(W01)
             ENDDO

/*JW2 END CHECK ====================================================*/
             CALL CHKC45 ('AB#C0K' 'AB#C0K' 'N'  '' '')
/* =================================================================*/

 END3:
             ENDPGM
