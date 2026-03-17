             PGM
             /** ABBC55 *************************/
             /*  ..SETTING NUMBER CHECK LIST..  */
             /*                     07/24/01    */
             /*                                 */
             /*                                 */
             /************************* ABBC55 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)

             RTVJOBA    JOB(&WSID) USER(&US)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)


             OVRPRTF    FILE(QPRINT) RPLUNPRT(*YES) OUTQ(LANPRT03) +
                          FORMTYPE(K6H1)
             CALL       PGM(ABBR55)
             DLTOVR     FILE(QPRINT)


             ENDPGM
