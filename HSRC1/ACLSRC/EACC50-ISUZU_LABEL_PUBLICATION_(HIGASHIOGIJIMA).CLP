             PGM        PARM(&FILE2)
             /*** EACC50 *************************/
             /* ISUZU  LABEL PUBLICATION (HIGASHIOGIJIMA)  */
             /*        H.ITO 87.09.28 */
             /************************* EACC50 ***/
             DCL        VAR(&FILE2) TYPE(*CHAR) LEN(8)
             OVRDBF     FILE(DACWP12) TOFILE(&FILE2)
             OVRPRTF    FILE(EACPR50) PAGESIZE(54) OVRFLW(54) +
                          RPLUNPRT(*YES) OUTQ(QPRINTE) FORMTYPE(D998)
             CALL       PGM(EACR50)
             DLTOVR     FILE(*ALL)
             ENDPGM
