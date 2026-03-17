             PGM        PARM(&NOHZ &TDAT &ADON)
/** AB#C03E ***********************************************/
/*  FORD EDI862 PRE ORDER (V.2)                           */
/*  J.W  2022.01.17                                       */
/************************************************ AADC31 **/
             DCL        VAR(&NOHZ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&TDAT) TYPE(*CHAR) LEN(8)
             DCL        VAR(&ADON) TYPE(*CHAR) LEN(1)

             OVRPRTF    FILE(QPRINT) PAGESIZE(66 198) LPI(6) CPI(15) +
                          OVRFLW(60) OUTQ(QDKT) FORMTYPE(K6H1) +
                          HOLD(*YES)

             CALL       PGM(AB#R0E3A) PARM(&NOHZ &TDAT &ADON)

             DLTOVR     FILE(*ALL)

             ENDPGM
