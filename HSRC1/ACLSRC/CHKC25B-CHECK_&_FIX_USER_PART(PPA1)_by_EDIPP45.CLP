             PGM
             /** CHKC25B *********************************************/
             /*  CHECK & FIX USER PART(PPA1) BY EDIPP45              */
             /*  ADD JOB TO VJBC71  (JOB SCHEDULE  05:45 AM)         */
             /*  J.WATANABE 2022.03.23                               */
             /********************************************************/

             OVRPRTF FILE(QPRINT) OUTQ(QDKT    )

             CALL       PGM(CHKR25B) PARM(' ' 'Y')

             ENDPGM
