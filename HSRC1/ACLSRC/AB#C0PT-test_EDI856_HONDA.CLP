             PGM
 /** AB#C0P ****************************************************/
 /*  EDI(856) GENTRAN                                          */
 /*           HONDA                                            */
 /**************************************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&FLAG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PERR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)
             DCLF       FILE(AB#PW0G)
             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             CHGJOB     SWS(00000000)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

      /**    ALCOBJ     OBJ((AB#EP59 *FILE *EXCLRD)) WAIT(3)            **/
      /**    MONMSG     MSGID(CPF0000) EXEC(DO)                         **/
      /**    CALL       PGM(QUILNGTX) PARM('GENTRAN IS WORKING NOW. +   **/
      /**                 PLEASE TRY IT AGAIN IN ONE MINUTE. THANK +    **/
      /**                 YOU. ' X'00000046' '       ' +                **/
      /**                 '                    ' X'00000000')           **/
      /**                                                               **/
      /**    GOTO END                                                   **/
      /**    ENDDO                                                      **/

 /* BARCODE READING */
  STP0:

             CRTDUPOBJ  OBJ(MITANKF) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/MITANKF

             CRTDUPOBJ  OBJ(AB#WP34) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/AB#WP34

             OVRDBF     FILE(MITANKF) TOFILE(QTEMP/MITANKF)
             OVRDBF     FILE(AB#WP34) TOFILE(QTEMP/AB#WP34)

             CHGVAR     VAR(&FLAG) VALUE(' ')

             CALL       PGM(AB#R0P) PARM(&FLAG  &PERR)

/**(TEST)**********/
             GOTO STP1
/******************/

             IF         COND(&FLAG *EQ '9') THEN(GOTO CMDLBL(END))

 END:
             DLCOBJ     OBJ((AB#EP59 *FILE *EXCLRD))
             MONMSG     MSGID(CPF0000)

             IF         COND(&FLAG *EQ ' ') THEN(DO)
             SNDRCVF    RCDFMT(W01)
             ENDDO

             IF         (%SWITCH(1XXXXXXX)) DO
             OVRDBF     FILE(AB#WP34) TOFILE(QTEMP/AB#WP34)
             CALL       PGM(AB#RE9)
             DLTOVR     FILE(*ALL)
             ENDDO

        /* JW1 2016.03.22 ADDED: SAVE AB#EP59/67/68/69    */
             CALL       PGM(EDSR6H)

 /* UNIT PRICE ERROR */
             IF         (%SWITCH(X1XXXXXX)) DO
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(LANPRT50) +
                          FORMTYPE(K6H1) HOLD(*YES) IGCDTA(&PIGCD)
             CALL       PGM(AB#R0D)
 /* %0001 */
 /* JW3 */   CLRPFM     FILE(HWFILE1/PRT132B)
             CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT132B) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             MONMSG     MSGID(CPF3309) EXEC(GOTO CMDLBL(STP1))

             OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132B)
             CALL       PGM(AB#RW0)
             SNDDST     TYPE(*FILE) TOINTNET((SalesGroup@iafi.com) +
                          (*NONE *CC)) DSTD('Unit price not +
                          registered') MSG('Unit price of some +
                          parts is not registered when sending ASN. +
                          Please check the attached report. +
                          (AB#C0P).') DOCFILE(HWFILE1/PRT132B) +
                          DOCTYPE(*FFT) SNDFMT(*NOTE) DOCD('EDI 856 +
                          (HONDA) Unit price not registered')
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(PRT132)
             ENDDO
STP1:
             ENDPGM
