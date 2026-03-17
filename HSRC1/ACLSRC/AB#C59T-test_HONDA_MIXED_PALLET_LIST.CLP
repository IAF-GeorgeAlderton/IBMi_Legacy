             PGM

             DCL        VAR(&MIX) TYPE(*DEC) LEN(3 0) VALUE(60)

             OVRPRTF    FILE(AB#PR59) PAGESIZE(66 80) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(LANPRT03) +
                          FORMTYPE(K6S1) COPIES(1)

             CALL       PGM(AB#R59) PARM(&MIX)

             ENDPGM
