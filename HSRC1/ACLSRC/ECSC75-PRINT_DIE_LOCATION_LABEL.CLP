             PGM
            /** ECSC75 **********************************************/
            /* PRINT DIE LOCATION LABEL                             */
            /*          2017.08.24  ITS.  T.MITSUI                  */
            /* ---------------------------------------------------- */
            /* JW1      2025.12.22 ADD EXCLUSIVE JOB ERROR (CHKC45) */
            /********************************************************/
             DCL        VAR(&WSID)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRNT)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&DEVT)     TYPE(*CHAR) LEN(6)
             DCL        VAR(&IGCD)     TYPE(*CHAR) LEN(4)
             DCL        VAR(&WS3)      TYPE(*CHAR) LEN(3)

             DCL        VAR(&OUTR)     TYPE(*DEC)  LEN(5 0)
             DCL        VAR(&FRLB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&FRFL)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&HOST)     TYPE(*CHAR) LEN(8)
             DCL        VAR(&TOFL)     TYPE(*CHAR) LEN(52)
             DCL        VAR(&TOFT)     TYPE(*CHAR) LEN(2)
             DCL        VAR(&WLIB)     TYPE(*CHAR) LEN(8)
             DCL        VAR(&MBAN)     TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&ECSWP75)  TYPE(*CHAR) LEN(10)
/*JW1*/      DCL        VAR(&RTN1)     TYPE(*CHAR) LEN(1)

/* JW1 CHECK OTHER USER IS USING  ==================================*/
             CALL CHKC45 ('ECSC75' 'ECSC75' 'Y'  'CHK' &RTN1)
             IF         COND(&RTN1 *NE ' ') THEN(GOTO #STEP99)
/* =================================================================*/

 #STEP01:   /*======================================================*/
            /* INITIALAIZE                                          */
            /*======================================================*/
             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(AGAR01) PARM(&WSID &DEVT &IGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRNT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))

 /* JW1 *******  AREA CHECK */
   /**       CHKOBJ     OBJ(&WLIB/ECSC75ACT) OBJTYPE(*DTAARA)          **/
   /**       MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STPB))         **/
   /** STPA: SNDPGMMSG  MSG('( G ) LOCATION LABEL ISSUE MENU ALREADY + **/
   /**                    USING BY ANOTHER USER. WAIT FOR A WHILE') +  **/
   /**                    TOMSGQ(&WSID) MSGTYPE(*INQ) KEYVAR(&MBAN)    **/
   /**       RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +       **/
   /**                    MSG(&KOTE)                                   **/
   /**       IF         COND((&KOTE *NE 'G') *AND (&KOTE *NE 'g')) +   **/
   /**                    THEN(GOTO CMDLBL(STPA))                      **/
   /**       GOTO       CMDLBL(#STEP99)                                **/
   /**                                                                 **/
   /** STPB: CRTDTAARA  DTAARA(&WLIB/ECSC75ACT) TYPE(*CHAR) LEN(10) +  **/
   /**                    TEXT('ESCC75 ACT') AUT(*ALL)                 **/

 #STEP02:   /*======================================================*/
            /* PRINT DIE LOCATION LABEL                             */
            /*======================================================*/
             CLRPFM     FILE(&WLIB/ECSWP75)
             MONMSG     MSGID(CPF0000)

             CALL       PGM(ECSR75) PARM(&OUTR)

             IF         COND(&OUTR = 0) THEN(GOTO CMDLBL(#STEP98))

 #STEP03:   /*======================================================*/
            /* ISSUE DATA CREATE                                    */
            /*======================================================*/
             DLTF       FILE(&WLIB/ECSWP76)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/ECSWP76) RCDLEN(34) +
                        OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO)

             CALL       PGM(ECSR76) PARM(&OUTR)


 #STEP04:   /*======================================================*/
            /* LOCATION LABEL DATA TRANCEFER TO PC                  */
            /*======================================================*/

            /* DATA TRANCEFER IS EXECUTE BY PC APPLICATION */

 #STEP98:
            /* JW1 ** DLTDTAARA  DTAARA(&WLIB/ECSC75ACT)*************/

            /* JW1 =================================================*/
             CALL CHKC45 ('ECSC75' 'ECSC75' 'N'  '' '')
            /*======================================================*/

 #STEP99:   /*======================================================*/
            /*  END                                                 */
            /*======================================================*/

             ENDPGM
