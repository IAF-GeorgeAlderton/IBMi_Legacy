             PGM
             /** ECSCA1 ******************************/
             /* 海外拠点金型出庫実績データ作成     */
             /*  EXCEL CSV                           */
             /*    I-HASADA            2017/10/06    */
             /****************************** ECSCA1 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PJSYY) TYPE(*CHAR) LEN(4)

             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&SYS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PARM4)  TYPE(*CHAR) LEN(52)

             CHGJOB     SWS(00000000)
             RTVJOBA    JOB(&WSID) USER(&USER)
             RTVNETA    SYSNAME(&SYS)
    /*--------------*/
    /*  PGM:ECSRA1  */
    /*--------------*/
             DLTF       FILE(ECSWPA1)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/ECSWPA1) RCDLEN(100) +
                          TEXT('海外拠点出庫実績データ') +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)

             CALL       PGM(ECSRA1) PARM(&PJSYY)

    /*--------*/
    /* 終了 */
    /*--------*/
             IF         (%SWITCH(X1XXXXXX)) DO
             DLTF       FILE(ECSWPA1)
             GOTO       END
             ENDDO

    /*--------------*/
    /*  PGM:ECSRA2  */
    /*--------------*/
             DLTF       FILE(ECSWPA2)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/ECSWPA2) RCDLEN(300) +
                          IGCDTA(*YES) +
                          TEXT('海外拠点金型出庫実績データ<EXCEL>') +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)

             CALL       PGM(ECSRA2) PARM(&PJSYY)

             RTVMBRD    FILE(ECSWPA2) NBRCURRCD(&REC)
             IF         COND(&REC *NE 0) THEN(DO)
             CHGVAR     VAR(&PARM4) VALUE('C:/AS400/DATA/IAFKATA.CSV')
             CALL       PGM(APLC98) PARM('HWFILE1' 'ECSWPA2' &SYS +
                          &PARM4 ' 1')
             ENDDO

 END:        ENDPGM
