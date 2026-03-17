             PGM
             /** YH029C **********************************************/
             /*要求受付の開始                                      */
             /* 2010.11.21 T.SAKASHITA                               */
             /********************************************************/

             SBMJOB     CMD(CALL PGM(HULFT/HULOBSD)) JOB(HULOBSD) +
                          JOBQ(HULFT/HULJOBQ)

             ENDPGM
