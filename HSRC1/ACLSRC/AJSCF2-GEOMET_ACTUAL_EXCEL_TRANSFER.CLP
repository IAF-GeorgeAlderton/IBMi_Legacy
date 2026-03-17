             PGM
             /** AJSCF1 *******************************************/
             /* ジオメット実績ＥＸＣＥＬへ転送                  */
             /*  改善シート№:18-565                            */
             /*  実施日　　　:2019.02.11                        */
             /*  実施者　　　:Y.NAKANO                          */
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
             DCL        VAR(&PARM4) TYPE(*CHAR) LEN(52) +
                          VALUE('C:/AS400/DATA/IAFジオメット.CSV')

             DCL        VAR(&PARM5)    TYPE(*CHAR) LEN(2)
             DCL        VAR(&PARM6)    TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHGJOB     OUTQ(&PRTG)

        /*               */
             DLTF       FILE(AJSWPF3)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/AJSWPF3) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AJSWPF3) OPTION(*NOLIST *NOSRC) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(AJSWPF4)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/AJSWPF4) RCDLEN(128) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

         /*------------------------------------------------*/
         /* めっき投入実績集計                           */
         /*------------------------------------------------*/

             CALL       PGM(AJSRF2) PARM(&PARM6)


             RTVMBRD    FILE(HWFILE1/AJSWPF4) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(GOTO CMDLBL($STEP99))
 $STEP03:    /*==================================================*/
             /*        ＣＳＶデータ転送 < AJSWPF4 >            */
             /*==================================================*/
             CHGVAR     VAR(&PARM1) VALUE('HWFILE1   ')
             CHGVAR     VAR(&PARM2) VALUE('AJSWPF4   ')
             RTVNETA    SYSNAME(&PARM3)
             CHGVAR     VAR(&PARM5) VALUE(' 1')

             IF    COND(&PARM6 *EQ 'A') THEN(DO)
             CALL  PGM(APLC98) PARM(&PARM1 &PARM2 &PARM3 &PARM4 &PARM5)
             ENDDO
             IF    COND(&PARM6 *EQ 'I') THEN(DO)

             CHGVAR     VAR(&PARM4) VALUE('IAF GEOMET RESULT LIST')


             CALL  PGM(APLC96) PARM('1' &PARM2 &PARM1 &PARM4 'Y' '')
             ENDDO

 $STEP99:
             ENDPGM
