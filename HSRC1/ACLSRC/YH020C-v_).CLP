             PGM
             /** YH020C **********************************************/
             /*集信受付の開始                                      */
             /* 2010.11.21 T.SAKASHITA                               */
             /********************************************************/

             SBMJOB     CMD(CALL PGM(HULFT/HULRCVD)) JOB(HULRCVD) +
                          JOBQ(HULFT/HULJOBQ)

             ENDPGM
