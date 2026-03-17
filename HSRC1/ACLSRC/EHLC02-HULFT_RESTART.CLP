             PGM
             /** EHLC02 **********************************************/
             /* HULFT RESTART                                        */
             /* 2016.10.13 T.SAKAKI                                  */
             /********************************************************/

             CALL HULFT/UTLKILLSND
             CALL HULFT/UTLKILLRCV
             CALL HULFT/UTLKILLOBS
             ENDSBS SBS(HULFT) OPTION(*IMMED)

             DLYJOB     DLY(5)

             STRSBS SBSD(HULFT/HULFT)
             DLYJOB     DLY(5)
             SBMJOB     CMD(CALL PGM(HULFT/HULSNDD)) JOB(HULSNDD) +
                          JOBQ(HULFT/HULJOBQ)
             SBMJOB     CMD(CALL PGM(HULFT/HULRCVD)) JOB(HULRCVD) +
                          JOBQ(HULFT/HULJOBQ)
             SBMJOB     CMD(CALL PGM(HULFT/HULOBSD)) +
                          JOBQ(HULFT/HULJOBQ) JOB(HULOBSD)

             ENDPGM
