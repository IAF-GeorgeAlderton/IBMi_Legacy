             PGM
             /*** ABHC23 ********************************************/
             /* PUBLICATION  INTRA-PROCESS KANBAN BY EACH CONDITION */
             /* A.IDOTA               1995.06.27                    */
             /* J.WATANABE (JW1)  2018.07.17 CHG MSG                */
             /* J.WATANABE (JW2)  2025.05.19 ADD CHKC45 (EXCLUSIVE) */
             /*******************************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NBMN) TYPE(*CHAR) LEN(4)

 /*JW1*/     DCL        VAR(&JPGM )  TYPE(*CHAR) LEN(10)
             DCL        VAR(&JINF )  TYPE(*CHAR) LEN(50)
             DCL        VAR(&JMBR )  TYPE(*CHAR) LEN(10)
             DCL        VAR(&JWS  )  TYPE(*CHAR) LEN(10)
             DCL        VAR(&JPGM )  TYPE(*CHAR) LEN(10)
             DCL        VAR(&JMSG )  TYPE(*CHAR) LEN(100)
             DCL        VAR(&RTN1)   TYPE(*CHAR) LEN(1)

/* CHECK OTHER USER IS USING  (JW1) ================================*/
             CALL       PGM(CHKC45) PARM('ABHACT2' 'ABHC23' 'Y' 'CHK' &RTN1)
             IF         COND(&RTN1 *NE ' ') THEN(GOTO @ENDP2)
/* =================================================================*/

             CHGVAR     VAR(&JPGM)   VALUE('ABHC23')
             CALL       PGM(UTLR23)  PARM(&JPGM &JINF)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)
             CHGJOB     OUTQ(&PRTG)
             CHGJOB     SWS(00000000)

 /* INTRA-PROCESS KANBAN REISSUE PROGRAM OPERATION CHECK */
      /*     CHKOBJ     OBJ(&WLIB/ABHACT2) OBJTYPE(*DTAARA)             */
      /*     MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STPA))          */
      /*                                                                */
 STP1:
      /* JW1 SNDPGMMSG  MSG('( G ) INTRA-PROCESS KANBAN REISSUE +       */
      /*                  PROGRAM IS WORKING AT ANOTHER POST,WAIT +     */
      /*                  FOR A WHILE') TOMSGQ(&WSID) MSGTYPE(*INQ) +   */
      /*                  KEYVAR(&MBAN)                                 */
      /*     RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +        */
      /*                  MSG(&KOTE)                                    */
      /*     IF         COND((&KOTE *NE 'G') *AND (&KOTE *NE 'g')) +    */
      /*                  THEN(GOTO CMDLBL(STP1))                       */
      /*     GOTO       END                                             */

/* DISPLAY ERROR & END JOB (JW1) */
      /*     RTVDTAARA  DTAARA(&WLIB/ABHACT2 (1  10)) RTNVAR(&JMBR)     */
      /*     RTVDTAARA  DTAARA(&WLIB/ABHACT2 (31 10)) RTNVAR(&JWS )     */
      /*     RTVDTAARA  DTAARA(&WLIB/ABHACT2 (41 10)) RTNVAR(&JPGM)     */
      /*     CHGVAR     VAR(&JMSG) VALUE(&JMBR *BCAT 'IS USING THIS +   */
      /*                  PROGRAM AT' *BCAT &JWS *TCAT '. +             */
      /*                  (&WLIB/ABHACT2)')                             */
      /*     CALL       PGM(QUILNGTX) PARM(&JMSG X'00000046' ' ' ' ' +  */
      /*                  X'00000000')                                  */
      /*     GOTO       END                                             */
      /*                                                                  */
/*  STPA:    CRTDTAARA  DTAARA(&WLIB/ABHACT2) TYPE(*CHAR) LEN(50) +     */
      /*                  VALUE(&JINF) TEXT('INTRA-PROC KANBAN +        */
      /*                  REISSUE SYSTEM IS IN AN ACTIVE') AUT(*ALL)    */

 /* INTRA-PROCESS KANBAN REISSUE WORK-FILE CREATE */
             CHKOBJ     OBJ(&WLIB/ABHWPIA) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801)  EXEC(DO)
             CRTPF      FILE(&WLIB/ABHWPIA) RCDLEN(1024) +
                          OPTION(*NOSRC *NOLIST) LVLCHK(*NO) +
                          AUT(*ALL) /* KANBAN REISSUE WORK <ENA +
                          FACTORY> */
             ENDDO


       /** KANBAN DATA MAKING                      **/
       /**   CALL       PGM(ABHR23) PARM(&NBMN)    **/
       /**   DLTDTAARA  DTAARA(&WLIB/ABHACT2)      **/

 END:
             CALL       PGM(CHKC45) PARM('ABHACT2' 'ABHC23' 'N' '' '')

 @ENDP2:
             ENDPGM
