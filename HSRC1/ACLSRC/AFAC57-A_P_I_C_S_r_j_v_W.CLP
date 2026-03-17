             PGM
             /** AFAC57 **************************************/
             /*  ..Ａ－ＰＩＣＳ生産指示データ　受信処理..  */
             /*             ＦＤにて受信処理               */
             /*       I-HASADA              1992.05.02       */
             /*       N.HAYAKAWA            1999.06.18       */
             /**************************** COPY FROM AFAC50 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PBMN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PKBN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDAT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PBIN) TYPE(*CHAR) LEN(2) VALUE('00')
             DCL        VAR(&PSBN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PTSR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PFIL) TYPE(*CHAR) LEN(9)
             RTVJOBA    JOB(&WSID)

             CHGJOB     SWS(00000000)

         /* 工場名の決定  */
             CALL       PGM(AFAR58) PARM(&PBMN &PKBN &PDAT &PBIN +
                          &PSBN &PTSR)

         /* 終了の条件  */
             IF         COND(&PBMN = '0000') THEN(DO)
             GOTO       END
             ENDDO
             IF         (%SWITCH(1XXXXXXX)) DO
             GOTO       END
             ENDDO

             CALL       PGM(AFAR57) PARM(&PBMN &PDAT &PBIN &PSBN +
                          &PTSR &PFIL)

             IF         (%SWITCH(X1XXXXXX)) DO
             GOTO       END
             ENDDO

         /*  m]cﾎ[hﾞ ﾈｮn  */
             CHGVAR     VAR(&PKBN) VALUE('*')
             CALL       PGM(AFAR51) PARM(&PBMN &PKBN &PDAT &PBIN +
                          &PSBN &PTSR)

 END:        ENDPGM
