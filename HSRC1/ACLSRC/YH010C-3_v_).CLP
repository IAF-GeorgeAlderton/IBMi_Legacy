             PGM
             /** YH029C **********************************************/
             /*配信受付の開始                                      */
             /* 2010.11.21 T.SAKASHITA                               */
             /********************************************************/

             SBMJOB     CMD(CALL PGM(HULFT/HULSNDD)) JOB(HULSNDD) +
                          JOBQ(HULFT/HULJOBQ)

             ENDPGM
