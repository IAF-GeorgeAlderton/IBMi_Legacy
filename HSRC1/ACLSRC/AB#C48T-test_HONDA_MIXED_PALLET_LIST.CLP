             PGM

             DCL        VAR(&MIX)  TYPE(*DEC)  LEN(3 0) VALUE(60)
             DCL        VAR(&POUT) TYPE(*CHAR) LEN(10)

             CHGVAR     VAR(&POUT) VALUE(LANPRT03)

 /* AB#R48 */
             OVRPRTF    FILE(AB#PR45) PAGESIZE(66 80) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&POUT) FORMTYPE(K6S1) +
                          HOLD(*YES)
             CALL       PGM(AB#R48) PARM(&MIX)

 /* AB#R59 */
        /*   OVRPRTF    FILE(AB#PR59) PAGESIZE(66 80) LPI(6) +        */
        /*                RPLUNPRT(*YES) OUTQ(&POUT) FORMTYPE(K6S1)   */
        /*   CALL       PGM(AB#R59) PARM(&MIX)                        */

             ENDPGM
