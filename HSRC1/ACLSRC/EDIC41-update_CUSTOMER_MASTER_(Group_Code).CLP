             PGM
             /** EDIC41 ************************************/
             /*  UPDATE ADDRESS MASTER BY AB#PP2A          */
             /*       CREATE DATE : 2017.09.01             */
             /*       CODING      : J. WATANABE            */
             /**********************************************/

             OVRPRTF    FILE(QPRINT) OUTQ(#LOGOUTQ)
/* HONDA */
             CALL       PGM(EDIR41)
/* FORD  */
             CALL       PGM(EDIR42)
/* TOYOTA */
             CALL       PGM(EDIR43)

             ENDPGM
