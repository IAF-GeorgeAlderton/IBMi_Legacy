             PGM
             /** AJSC20 ****************************************/
             /*         FA M/F MAINTENANCE                     */
             /*         E.KAWASHIMA 90.03.22                   */
             /*         TCH         02.04.12                   */
             /*         OUTQ = FAOUTQ                          */
             /*  JW   2018.08.16 CHG ERROR MSG FOR USING OTHER */
             /**************************************** AJSC20 **/
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&RTN  ) TYPE(*CHAR) LEN(1)

/* JW1 CHECK OTHER USER IS USING  ==================================*/
             CALL CHKC45 ('AJSC20' 'AJSC20' 'Y'  'CHK' &RTN)
             IF         COND(&RTN *NE ' ') THEN(GOTO @ENDP)
/* =================================================================*/

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGJOB     OUTQ(&PRTG)

  /* JW1   //DATA AREA CHECK//                                           */
  /*         CHKOBJ     OBJ(HFILE1/FAMASMAK) OBJTYPE(*DTAARA) AUT(*ALL)  */
  /*         MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STP2))           */
  /*                                                                     */
  /*   STP1: SNDPGMMSG  MSG('( G ) IT IS USING AT ANOTHER TV. PLEASE +   */
  /*                      WAIT FOR A WHILE.') TOMSGQ(&WSID) +            */
  /*                      MSGTYPE(*INQ) KEYVAR(&MBAN)                    */
  /*         RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +         */
  /*                    MSG(&ANS)                                        */
  /*                                                                     */
  /*         IF         COND((&ANS *NE 'G') *AND (&ANS *NE 'g')) +       */
  /*                      THEN(GOTO CMDLBL(STP1))                        */
  /*         GOTO       CMDLBL(END)                                      */
  /*         CRTDTAARA  DTAARA(HFILE1/FAMASMAK) TYPE(*CHAR) LEN(1) +     */
  /*                    VALUE('*') AUT(*ALL)                             */

 STP2:
             OVRPRTF    FILE(QPRINT) OUTQ(FAOUTQ)

             /* FA M/F MAINTENANCE */
             CALL       PGM(AJSR20) PARM(&USER)
             DLTOVR QPRINT

       /*    DLTDTAARA  DTAARA(HFILE1/FAMASMAK) */
             CALL CHKC45 ('AJSC20' 'AJSC20' 'N'  '' '')

 @ENDP:      ENDPGM
