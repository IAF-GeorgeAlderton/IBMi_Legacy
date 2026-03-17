             PGM
             /** KFAC20 ********************************************/
             /* PRINT LOCATION TAG                                 */
             /*                                                    */
             /* TCHK   2005.10.10 ADD  SINGLE USER CHECK           */
             /* JW1    2017.04.13 CHG  ERROR MSG                   */
             /* JW2    2018.08.21 CHG  ERROR MSG                   */
             /******************************************************/
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MBAN)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&RTN1)  TYPE(*CHAR) LEN(1)

/* CHECK OTHER USER IS USING  (JW2) ================================*/
             CALL       PGM(CHKC45) PARM('KFAC20' 'KFAC20' 'Y' 'CHK' &RTN1)
             IF         COND(&RTN1 *NE ' ') THEN(GOTO SEND)
/* =================================================================*/

   /*  YTP0:                                                            */
   /*        CHKOBJ     OBJ(HFILE1/KFAC20) OBJTYPE(*DTAARA)             */
   /*        MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(YTP1))          */
   /*                                                                   */
   /*  YTP2: SNDPGMMSG  MSG('( G ) PRINT LOCATION TAG IS BEING USED, +  */
   /*                     PLEASE TRY LATER... <Enter G to Exit> +       */
   /*                     (KFAC20)') TOMSGQ(&WSID) MSGTYPE(*INQ) +      */
   /*                     KEYVAR(&MBAN)                                 */
   /*        RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +        */
   /*                     MSG(&KOTAE)                                   */
   /*        IF         COND((&KOTAE *NE 'G') *AND (&KOTAE *NE 'g')) +  */
   /*                     THEN(GOTO CMDLBL(YTP2))                       */
   /*        GOTO       SEND                                            */
   /*                                                                   */
   /*  YTP1: CRTDTAARA  DTAARA(HFILE1/KFAC20) TYPE(*CHAR) LEN(10) +     */
   /*                     TEXT('PRINT LOCATION TAG') AUT(*ALL)          */

             RTVJOBA    JOB(&WSID)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CLRPFM     FILE(KFAWP20)

             CALL       PGM(KFAR20)

      /* JW2 DLTDTAARA  DTAARA(HFILE1/KFAC20)           */
      /*     MONMSG     MSGID(CPF2105)                  */
             CALL       PGM(CHKC45) PARM('KFAC20' 'KFAC20' 'N' '' '')

 SEND:
             CHGJOB     RUNPTY(20)
             ENDPGM
