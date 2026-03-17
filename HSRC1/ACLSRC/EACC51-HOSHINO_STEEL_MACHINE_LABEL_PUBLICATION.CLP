             PGM        PARM(&FILE2)
             /*** EACC51 *************************/
             /* HOSHINO STEEL MACHINE LABEL PUBLICATION */
             /* A:N.HAYAKAWA 93.01.20 */
             /*************** COPY FROM EACC50 ***/
             DCL        VAR(&FILE2) TYPE(*CHAR) LEN(8)
             OVRDBF     FILE(DACWP12) TOFILE(&FILE2)
             OVRPRTF    FILE(EACPR51) PAGESIZE(54) OVRFLW(54) +
                          RPLUNPRT(*YES) OUTQ(QPRINTE) +
                          FORMTYPE(D998)
             CALL       PGM(EACR51)
             DLTOVR     FILE(*ALL)
             ENDPGM
