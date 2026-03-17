             PGM
             /** FAAC21 ******************************************/
             /* COMMON PART NUMBER M/F UPDATE                    */
             /* M-OKUDA              81.11.07                    */
             /* TCHK1 11/17/06 CHG CHECK *DTAARA                 */
             /* JW1   04/11/17 CHG DATARA CONTENTS               */
             /* JW2   04/11/17 DLT DATARA ALACHK                 */
             /*                ADD NEW MSG PROGRAM CHKC45        */
             /****************************************************/
             DCL        VAR(&WS)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&US)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PM)     TYPE(*CHAR) LEN(2)
             DCL        VAR(&FLA5)   TYPE(*CHAR) LEN(9)
             DCL        VAR(&ABADS1) TYPE(*CHAR) LEN(48)
             DCL        VAR(&WLIB)   TYPE(*CHAR) LEN(8)

             DCL        VAR(&MSGTXT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&PKINP)  TYPE(*CHAR) LEN(5)
     /*JW1*/
             DCL        VAR(&DATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&TIME) TYPE(*CHAR) LEN(6)
             DCL        VAR(&XUSR) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RTN2) TYPE(*CHAR) LEN(1)

/* CHECK OTHER USER IS USING  (JW2) ================================*/
             CALL       PGM(CHKC45) PARM('ALACHK' 'FAAC21' 'Y' 'CHK' &RTN2)
             IF         COND(&RTN2 *NE ' ') THEN(GOTO END)
/* =================================================================*/

             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&DATE)
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&TIME)

             RTVJOBA    JOB(&WS) USER(&US)
             RTVDTAARA  DTAARA(ABADS1) RTNVAR(&ABADS1)
             CHGVAR     VAR(&PM) VALUE(%SST(&ABADS1 5 2))

             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&US &WLIB)

     /*JW2** STP1: CHKOBJ     OBJ(HFILE1/ALACHK) OBJTYPE(*DTAARA)      */
     /*      MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STP2))         */
     /*                                                                */
     /*      STP11:                                                    */
     /*      RTVDTAARA  DTAARA(HFILE1/ALACHK (1 5)) RTNVAR(&XUSR)      */
     /*      CHGVAR     VAR(&MSGTXT) VALUE('( G ) COMMON PART MASTER + */
     /*                   UPDATE IS BEING USED BY ........ ENTER +     */
     /*                  "G" TO ESCAPE FROM THIS SCREEN.')             */
     /*      CHGVAR     VAR(%SST(&MSGTXT 50 5)) VALUE(&XUSR)           */
     /*      CHGVAR     VAR(&PKINP) VALUE('Gg   ')                     */
     /*                                                                */
     /*      CALL       PGM(APLR90) PARM(&MSGTXT &PKINP &WS &KOTAE)    */
     /*                                                                */
     /*      GOTO       END                                            */
     /*                                                                */
     /*      SNDPGMMSG  MSG('( G ) COMMON PART NUMBER MASTER +         */
     /*                   UPDATE IS ACTIVE, WAIT FOR A WHILE') +       */
     /*                   TOMSGQ(&WS)                        +         */
     /*                   MSGTYPE(*INQ) KEYVAR(&MBAN)                  */
     /*      RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +       */
     /*                   MSG(&KOTAE)                                  */
     /*      IF         COND((&KOTAE *NE 'G') *AND (&KOTAE *NE 'g')) + */
     /*                   THEN(GOTO CMDLBL(STP11))                     */
     /*      GOTO       END                                            */

 STP2:
       /*    CRTDTAARA  DTAARA(HFILE1/ALACHK) TYPE(*CHAR) LEN(40) +     */
       /*                 TEXT('TOPICS RECIEVE M/F DATA CREATE CHECK') +*/
       /*                 AUT(*ALL)                                     */
       /*    MONMSG     MSGID(CPF1023) EXEC(GOTO CMDLBL(STP1))          */
       /*                                                               */
       /*    //JW//                                                     */
       /*    CHGDTAARA  DTAARA(HFILE1/ALACHK (01 10)) VALUE(&US)        */
       /*    CHGDTAARA  DTAARA(HFILE1/ALACHK (11 10)) VALUE(&WS)        */
       /*    CHGDTAARA  DTAARA(HFILE1/ALACHK (21  6)) VALUE(&DATE)      */
       /*    CHGDTAARA  DTAARA(HFILE1/ALACHK (28  6)) VALUE(&TIME)      */

 /* WORK FILE CREATE */
             CHGVAR     VAR(&FLA5) VALUE('ALAWPA5' *CAT (%SST(&WS 1 2)))

             DLTF       FILE(&WLIB/&FLA5)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FLA5) RCDLEN(130) +
                          OPTION(*NOLIST *NOSRC) SIZE(5000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

 /* COMMON PART NUMBER M/F UPDATE */
             OVRDBF     FILE(ALAWPA5) TOFILE(&WLIB/&FLA5)
             CALL       PGM(FAAR21) PARM(&US &PM)
             DLTOVR     FILE(*ALL)

             CHKOBJ     OBJ(&WLIB/ALAWPA5) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(&WLIB/ALAWPA5) RCDLEN(130) +
                          TEXT('TOPICS RECIEVE KANBAN M/F') +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX) +
                          AUT(*ALL))

             CPYF       FROMFILE(&WLIB/&FLA5) TOFILE(&WLIB/ALAWPA5) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)

             DLTF       FILE(&WLIB/&FLA5)

      /*JW2  DLTDTAARA  DTAARA(HFILE1/ALACHK)  ******/
      /*     MONMSG     MSGID(CPF2105)         ******/
      /* JW2 */
             CALL       PGM(CHKC45) PARM('ALACHK' 'FAAC21' 'N' '' '')

 END:
             ENDPGM
