             PGM
             /** CHKCP2 ****************************************/
             /*  活動ジョブ監視プログラム                    */
             /*                            A.MAMIYA 99.08.26   */
             /*  ADD JOB TO QGPL/@QSTRUP (AFTER IPL)           */
             /**************************************** CHKCP2 **/
             DLTDTAARA  DTAARA(CHKCP1ACT)
             MONMSG     MSGID(CPF2105)

             CRTDTAARA  DTAARA(CHKCP1ACT) TYPE(*CHAR) LEN(10) +
                          TEXT('監視ＪＯＢ実行中')

             /*  SBMJOB-CHKCJ1      */

             SBMJOB     CMD(CALL PGM(CHKCJ3)) JOB(JOBCHK) +
                          JOBD(QBATCH4) JOBQ(JOBQ4) RTGDTA(*JOBD) +
                          INLLIBL(*JOBD)
             ENDPGM
