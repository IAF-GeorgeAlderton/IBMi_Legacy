             PGM

             DCL        VAR(&PWEIG) TYPE(*DEC) LEN(5 2)
             DCL        VAR(&PSIRE)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&PCNAM)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TRANS)  TYPE(*CHAR) LEN(30)

             CHGVAR     VAR(&PWEIG) VALUE(0.60)
             CHGVAR     VAR(&PSIRE) VALUE('4160')
             CHGVAR     VAR(&PCNAM) VALUE('ENGLAND')
             CHGVAR     VAR(&TRANS) VALUE('LTL ')

             OVRPRTF    FILE(QPRINT) PAGESIZE(*N 80) OUTQ(LANPRT03)

             OVRDBF     FILE(AB#WP39) TOFILE(TWFILE1/AB#WP38)

/* CALL (HONDA) CUSTOM SHEET PROGRAM */
             CALL       PGM(TOBJ1/AB#R4D) PARM(&PWEIG &PSIRE &PCNAM +
                          &TRANS)

             DLTOVR     FILE(*ALL)

             ENDPGM
