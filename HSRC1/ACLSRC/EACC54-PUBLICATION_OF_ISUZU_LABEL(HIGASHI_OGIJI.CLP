             PGM        PARM(&FILE2)
             /*** EACC54 *************************/
             /* PUBLICATION OF ISUZU LABEL(HIGASHI OGIJIMA) */
             /*       K.OKACHI 96.09.23 */
             /************************* EACC54 ***/
             DCL        VAR(&FILE2) TYPE(*CHAR) LEN(8)
             OVRDBF     FILE(DACWP12) TOFILE(&FILE2)
             OVRPRTF    FILE(EACPR50) PAGESIZE(54) OVRFLW(54) +
                          RPLUNPRT(*YES) OUTQ(QPRINTE) FORMTYPE(D998)
             CALL       PGM(EACR54)
             DLTOVR     FILE(*ALL)
             ENDPGM
