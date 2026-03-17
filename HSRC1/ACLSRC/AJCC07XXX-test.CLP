             PGM
             /** AJCC07 ******************************************************/
             /* TEST                                                         */
             /****************************************************** AJCC02 **/
             DCL        VAR(&RQS) TYPE(*CHAR) LEN(80)

             CHGVAR     VAR(&RQS) VALUE('CALL ABBC7O')

             SBMJOB     JOB(TEST) JOBD(QBATCH7) JOBQ(JOBQ7) +
                          RQSDTA(&RQS) CURLIB(HOBJ1) INLLIBL(HOBJ1 +
                          HFILE1 HWFILE1 QGPL)

 END:        ENDPGM
