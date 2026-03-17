             PGM
             /** AJAC80 ***********************************/
             /*  ..パススルーＡＯＹＡＭＡ→ＩＡＦ ..  */
             /*  PASS THRU (AOYAMA --> IAF)               */
             /*     I-HASADA                97.09.22      */
             /*********************************** AJAC80 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(2)
             DCL        VAR(&VWS) TYPE(*CHAR) LEN(2)

             RTVJOBA    JOB(&WSID)

             CHGVAR     VAR(&WS) VALUE(%SUBSTRING(&WSID 1 2))

             IF         COND((&WS *NE 'Z2') *AND (&WS *NE 'Z3') *AND +
                          (&WS *NE 'Z4') *AND (&WS *NE 'Z5') *AND +
                          (&WS *NE 'Z7') *AND (&WS *NE 'Z8') *AND +
                          (&WS *NE 'Z9') *AND (&WS *NE 'ZC') *AND +
                          (&WS *NE 'VN')) THEN(DO)
             SNDPGMMSG  +
                          MSG('このテレビからは、ＩＡＦにパススルー+
                          をする事が出来ません。情報開発チームに連+
                          絡下さい。') TOMSGQ(QSYSOPR)
             ENDDO

             CHGVAR     VAR(&VWS) VALUE(&WS)
             CHGVAR     VAR(%SST(&VWS 1 1)) VALUE('F')

             STRPASTHR  RMTLOCNAME(IAF) VRTDEV(&VWS) MODE(#INTER) +
                          LCLLOCNAME(AOYAMA) RMTNETID(IBMIN)

             MONMSG     MSGID(CPF8921 CPF8916) EXEC(DO)
             SNDPGMMSG  +
                          MSG('相手側のＡＳ／４００と接続されている+
                          か又、このテレビからは、パススルーをする+
                          事が出来ない。又、パススルーのラインが活+
                          動状態になっていない。') TOMSGQ(&WSID)
             GOTO       END
             ENDDO

             MONMSG     MSGID(CPF8936) EXEC(DO)
             SNDPGMMSG  +
                          MSG('相手側のＡＳ／４００のパスワードが違+
                          うか登録されていない為、確認しなさい。') +
                          TOMSGQ(&WSID)
             GOTO       END
             ENDDO

             MONMSG     MSGID(CPF8905 CPF8933) EXEC(DO)
             SNDPGMMSG  +
                          MSG('相手側のＡＳ／４００の電源が入ってな+
                          ぃか又、ラインが活動状態になってぃなぃか+
                          のどちらかなので確認しなさい。') +
                          TOMSGQ(&WSID)
             ENDDO

 END:        ENDPGM
