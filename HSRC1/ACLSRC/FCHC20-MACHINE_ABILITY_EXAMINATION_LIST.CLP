             PGM
             /** FCHC20 *************************/
             /* ...MACHINE ABILITY EXAMINATION LIST ... */
             /* I-HASADA 85.01.12 */
             /************************* FCHC20 **/
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PKB) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FKB) TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WSID) USER(&US)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

 STP1:       OVRPRTF    FILE(QPRINT) DEVTYPE(*AFPDS) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1)
             CALL       PGM(FCHR20) PARM(&PKB &FKB)
             DLTOVR     FILE(QPRINT)

             IF         (&PKB *EQ 'E') GOTO END
             IF         (&FKB *EQ '2') GOTO STP2
             OVRPRTF    FILE(QPRINTL) DEVTYPE(*AFPDS) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1)
             CALL       PGM(FCHR21) PARM(&US)
             DLTOVR     FILE(QPRINTL)
             GOTO       STP1

 STP2:       OVRPRTF    FILE(QPRINTL) DEVTYPE(*AFPDS) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1)
             CALL       PGM(FCHR23) PARM(&US)
             DLTOVR     FILE(QPRINTL)
             GOTO       STP1

 END:        ENDPGM
