             PGM
             /** AAFC47 ******************************************/
             /* KANBAN M/F LIST & PRODUCTION ORDER BOOK MAKING   */
             /* K.NAKAMURA                         87.01.17      */
             /*                                                  */
             /* TCHK1 01/29/08 ADD PRINT SEQ                     */
             /* JW1   06/04/18 ADD PRINTER SELECTION             */
             /* JW2   09/07/18 CHG ERROR MSG                     */
             /* JW3   01/27/21 STOP (DLTF &WLIB/AAFWP48)         */
             /* JW4   02/01/21 CHG AAFR48 TO AAFR48N             */
             /****************************************** AAFC47 **/
             DCL        VAR(&WS)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&NO)    TYPE(*DEC) LEN(1) VALUE(0)
             DCL        VAR(&US)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&PNO)   TYPE(*CHAR) LEN(1)
/* TCHK1 */  DCL        VAR(&PLSTK) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&MBAN)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
/*JW1*/      DCL        VAR(&PRNTR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTN1)  TYPE(*CHAR) LEN(1)

/* JW2 CHECK OTHER USER IS USING  ==================================*/
             CALL CHKC45 ('AAVACT' 'AAFC47' 'Y'  'CHK' &RTN1)
             IF         COND(&RTN1 *NE ' ') THEN(GOTO ENDP)
/* =================================================================*/

             RTVJOBA    JOB(&WS) USER(&US)

             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)
             CALL       PGM(AGAR01) PARM(&WS &PDEVT &PIGCD)
             CALL       PGM(ALBC00) PARM(&US &WLIB)

             CHGVAR     VAR(&PRTG) VALUE('QPRINTC')

     /*JW2   CHKOBJ     OBJ(AAVACT) OBJTYPE(*DTAARA)                  */
     /*      MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STP3))        */
     /*                                                               */
     /*      STP2: SNDPGMMSG  MSG('( G ) UPDATE HANDLING FOR PART +   */
     /*                   INFORMATION M/F OR INTRA-PROCESS LOCATION + */
     /*                   CODE M/F IS ACTIVE, WAIT FOR A WHILE') +    */
     /*                   TOMSGQ(&WS) MSGTYPE(*INQ) KEYVAR(&MBAN)     */
     /*      RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +      */
     /*                   MSG(&KOTE)                                  */
     /*      IF         COND((&KOTE *NE 'G') *AND (&KOTE *NE 'g')) +  */
     /*                   THEN(GOTO CMDLBL(STP2))                     */
     /*      GOTO       END                                           */
     /*                                                               */
     /*      STP3: CRTDTAARA  DTAARA(AAVACT) TYPE(*CHAR) LEN(10) +    */
     /*                   TEXT('KANBAN M/F LIST & SHIP ODR BOOK +     */
     /*                   MAKING HANDLING') AUT(*ALL)                 */

             CHGJOB     SWS(00000000)

             DLTF       FILE(&WLIB/AAFWP47)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(&WLIB/AAFWP48)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTPF      FILE(&WLIB/AAFWP47) RCDLEN(12) +
                          OPTION(*NOLIST) SIZE(5000 2000) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)
/* JW1****** CALL****** PGM(AAFR47) PARM(&NO &PNO &PLSTK)  */
/* JW1 */    CALL       PGM(AAFR47) PARM(&NO &PNO &PLSTK &PRNTR)
             DLTOVR     FILE(QPRINT)

             IF         (%SWITCH(0XXXXXXX)) DO
                DLTF       FILE(&WLIB/AAFWP47)
       /*JW2****DLTDTAARA  DTAARA(AAVACT) ****************/
                CALL CHKC45 ('AAVACT' 'AAFC47' 'N'  '' '')
                GOTO       ENDP
             ENDDO

             CRTPF      FILE(&WLIB/AAFWP48) RCDLEN(12) +
                          OPTION(*NOLIST) SIZE(5000 2000) +
                          LVLCHK(*NO) AUT(*ALL)

/* TCHK1 */  IF (&PLSTK *EQ '1')  DO
/* TCHK1 */  CPYF       FROMFILE(&WLIB/AAFWP47) +
/* TCHK1 */               TOFILE(&WLIB/AAFWP48) +
/* TCHK1 */               MBROPT(*REPLACE) FMTOPT(*NOCHK)
/*JW*/       MONMSG     MSGID(CPF0000)
/* TCHK1 */  ENDDO
/* TCHK1 */  ELSE DO
             FMTDTA     INFILE((&WLIB/AAFWP47)) +
                          OUTFILE(&WLIB/AAFWP48) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AAFS47) +
                          OPTION(*NOPRT)
/*JW*/       MONMSG     MSGID(CPF0000)
/* TCHK1 */  ENDDO
             DLTF       FILE(&WLIB/AAFWP47)

             CHGVAR     VAR(&NO) VALUE(5)
             MONMSG     MSGID(CPF2103)

/*JW1*/
             IF (&PRNTR *EQ ' ') CHGVAR VAR(&PRTG) VALUE('QPRINTC ')
             IF (&PRNTR *EQ '1') CHGVAR VAR(&PRTG) VALUE('LANPRT02')
             IF (&PRNTR *EQ '2') CHGVAR VAR(&PRTG) VALUE('LANPRT07')
             IF (&PRNTR *EQ '3') CHGVAR VAR(&PRTG) VALUE('LANPRT03')
             IF (&PRNTR *EQ '4') CHGVAR VAR(&PRTG) VALUE('LANPRT04')
             IF (&PRNTR *EQ '5') CHGVAR VAR(&PRTG) VALUE('QPRINTB ')
             IF (&PRNTR *EQ '6') CHGVAR VAR(&PRTG) VALUE('QPRINT  ')
             IF (&PRNTR *EQ '9') CHGVAR VAR(&PRTG) VALUE('EPRINT1 ')

       /*JW4 OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +            */
       /*                 RPLUNPRT(*YES) ALIGN(*YES) OUTQ(&PRTG) +       */
       /*                 FORMTYPE(@627) MAXRCDS(*NOMAX) IGCDTA(&PIGCD)  */

       /*JW4*/
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(88 +
                          132) LPI(8) CPI(5) RPLUNPRT(*YES) +
                          ALIGN(*YES) OUTQ(&PRTG)  FORMTYPE(@627) +
                          IGCDTA(&PIGCD)

             OVRPRTF    FILE(QPRINTS) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) ALIGN(*YES) OUTQ(&PRTG) +
                          FORMTYPE(@972) MAXRCDS(*NOMAX) IGCDTA(&PIGCD)

       /***  CALL       PGM(AAFR48) PARM(&US &NO &PNO)  ***/
       /* JW4 */
             CALL       PGM(AAFR48O) PARM(&US &NO &PNO)

             DLTOVR     FILE(QPRINT)
             DLTOVR     FILE(QPRINTS)

       /*JW3*DLTF*******FILE(&WLIB/AAFWP48)************/

/*JW2  END CHECK ========================================+==========*/
             CALL CHKC45 ('AAVACT' 'AAFC47' 'N'  '' '')
/* =================================================================*/

 ENDP:       ENDPGM
