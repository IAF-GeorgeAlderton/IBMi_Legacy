             PGM
             /*** MBEC60 **********************************/
             /*  MONTHLY DELIVERY REPORT MAKING           */
             /*   KIRI 15.07.14                           */
             /*   T.SAKAKI 15.07.27  メール転送追加     */
             /********************************** MBEC50 ***/

             DCL        VAR(&WSID)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)      TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS01) TYPE(*CHAR) LEN(1)
             DCL        VAR(&IAFWFILE) TYPE(*CHAR) LEN(10) +
                                                   VALUE('HWFILE1   ')
             DCL        VAR(&MBEWP60)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&REC)      TYPE(*DEC)  LEN(10 0)

             DCL        VAR(&SYS)      TYPE(*CHAR) LEN(10)
             DCL        VAR(&PARM1)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&PARM2)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&PARM3)    TYPE(*CHAR) LEN(8)
             DCL        VAR(&PARM4)    TYPE(*CHAR) LEN(52)
             DCL        VAR(&PARM5)    TYPE(*CHAR) LEN(2)

        /*SEND MAIL SET */
             DCL        VAR(&TO1)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&SUB)  TYPE(*CHAR) LEN(30)
             DCL        VAR(&FNAME)  TYPE(*CHAR) LEN(30)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&WS01) VALUE(%SST(&WSID 1 1))

             CHGVAR     VAR(&TO1) VALUE('MAMIYAA@IAFI.COM')
             CHGVAR     VAR(&SUB) VALUE('SHIPPING DATA BY CUSTOMER ' +
                          *CAT &USER)
             CHGVAR     VAR(&FNAME) +
                          VALUE('SHIPPING-DATA-BY-CUSTOMER.CSV')

 $STEP01:    /*==================================================*/
             /*        ジョブ情報取得                          */
             /*==================================================*/

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             IF         COND(&USER *EQ 'TEST') THEN(DO)
             CHGVAR     VAR(&IAFWFILE) VALUE('TWFILE1')
             ENDDO

 $STEP02:    /*==================================================*/
             /*        ＣＳＶデータ作成                        */
             /*==================================================*/
             CHGVAR     VAR(&MBEWP60) VALUE('MBEWP60')
             DLTF       FILE(&IAFWFILE/&MBEWP60)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&IAFWFILE/&MBEWP60) RCDLEN(128) +
                          IGCDTA(*YES) OPTION(*NOLIST *NOSRC) +
                          SIZE(9999 5000 3) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(MBEWP60) TOFILE(&MBEWP60)
             CALL       PGM(MBER60) PARM(&TO1)
             DLTOVR     FILE(MBEWP60)

             RTVMBRD    FILE(&IAFWFILE/&MBEWP60) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(GOTO CMDLBL($STEP99))

             CHGVAR     VAR(&PARM1) VALUE(&IAFWFILE)
             CHGVAR     VAR(&PARM2) VALUE(&MBEWP60)
    /*  ＣＳＶ作成　メール転送のみ          */
             GOTO       CMDLBL($STEP04)

 $STEP03:    /*==================================================*/
             /*        ＣＳＶデータ転送 < ABHPP01 >            */
             /*==================================================*/
             RTVNETA    SYSNAME(&SYS)
             CHGVAR     VAR(&PARM3) VALUE(&SYS)
             CHGVAR     VAR(&PARM4) +
                          VALUE('C:/AS400/DATA/MBEWP60.CSV')

             CHGVAR     VAR(&PARM5) VALUE(' 1')
             CALL       PGM(APLC98) +
                        PARM(&PARM1 &PARM2 &PARM3 &PARM4 &PARM5)

 GOTO $STEP99

 $STEP04:    /*==================================================*/
             /*        ＣＳＶデータメール転送　　　　          */
             /*==================================================*/
             CALL       PGM(APLC30) PARM(&TO1 &SUB &PARM1 &PARM2 +
                          &FNAME)

 $STEP99:
             ENDPGM
