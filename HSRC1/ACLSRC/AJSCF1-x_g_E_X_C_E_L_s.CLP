             PGM
             /** AJSCF1 *******************************************/
             /* めっき投入実績ＥＸＣＥＬへ転送                  */
             /*  KIRI                             2018.11.13      */
             /*****************************************************/
             DCL        VAR(&WSID)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)      TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)     TYPE(*CHAR) LEN(8)

             DCL        VAR(&REC)      TYPE(*DEC)  LEN(10 0)
             DCL        VAR(&PARM1)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&PARM2)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&PARM3)    TYPE(*CHAR) LEN(8)
             DCL        VAR(&PARM4)    TYPE(*CHAR) LEN(52) +
                          VALUE('C:/AS400/DATA/IAFめっき.CSV')
             DCL        VAR(&PARM5)    TYPE(*CHAR) LEN(2)


             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHGJOB     OUTQ(&PRTG)

        /*               */
             DLTF       FILE(AJSWPF1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/AJSWPF1) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AJSWPF1) OPTION(*NOLIST *NOSRC) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(AJSWPF2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/AJSWPF2) RCDLEN(128) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

         /*------------------------------------------------*/
         /* めっき投入実績集計                           */
         /*------------------------------------------------*/

             CALL       PGM(AJSRF1)


             RTVMBRD    FILE(HWFILE1/AJSWPF2) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(GOTO CMDLBL($STEP99))
 $STEP03:    /*==================================================*/
             /*        ＣＳＶデータ転送 < AJSWPF2 >            */
             /*==================================================*/
             CHGVAR     VAR(&PARM1) VALUE('HWFILE1   ')
             CHGVAR     VAR(&PARM2) VALUE('AJSWPF2   ')
             RTVNETA    SYSNAME(&PARM3)
             CHGVAR     VAR(&PARM5) VALUE(' 1')
             CALL       PGM(APLC98) +
                        PARM(&PARM1 &PARM2 &PARM3 &PARM4 &PARM5)


 $STEP99:
             ENDPGM
