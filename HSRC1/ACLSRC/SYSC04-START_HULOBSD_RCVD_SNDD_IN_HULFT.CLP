             PGM
             /** SYSC04 **********************************************/
             /*  START HULOBSD/RCVD/SNDD IN HULFT                    */
             /*  RETREIEVE FROM @QSTRUP (FROM 131.00)                */
             /*  QGPL/QCLSRC(@QSTRUP)                                */
             /*                                                      */
             /*  JW    2017.12.18                                    */
             /********************************************************/

 /* SBMJOB HULFT */
     CLRLIB     LIB(HULTEMP)
     SBMJOB     CMD(CALL PGM(HULFT/HULSNDD)) JOB(HULSNDD) +
                  JOBQ(HULFT/HULJOBQ)

     SBMJOB     CMD(CALL PGM(HULFT/HULRCVD)) JOB(HULRCVD) +
                  JOBQ(HULFT/HULJOBQ)

     SBMJOB     CMD(CALL PGM(HULFT/HULOBSD)) JOB(HULOBSD) +
                  JOBQ(HULFT/HULJOBQ)

             ENDPGM
