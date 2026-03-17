             PGM
             /** MRACPZ **********************************************/
             /*ネットワークファイルの監視プログラム投入（ＩＰＬ）  */
             /*   TRANCOM-ITS              2011.11.28                */
             /********************************************** MRACPZ **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CHK)  TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WSID)

             SBMJOB     JOB(BP0094) JOBD(QBATCH1)  JOBQ(JOBQ1)    +
                          RTGDTA(*JOBD) RQSDTA('CALL PGM(MRACZ1) +
                          PARM(''0094'' ''BP'')') INLLIBL(*CURRENT)


 END:        ENDPGM
