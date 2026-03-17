             PGM
             /** CHKC25 **********************************************/
             /*  CHECK & FIX EDIPP42 (NUMERIC DELIVERY#)             */
             /*  ADD JOB TO VJBC71  (JOB SCHEDULE  05:45 AM)         */
             /*  J.WATANABE 12/07/2017                               */
             /********************************************************/

             CALL       PGM(CHKR25) PARM('Y')

             ENDPGM
