             PGM        PARM(&PRTG)
             /** AJBCJ5 **************************/
             /* DATA BASE REFERENCE PROGRAM LIST */
             /* JOBQ.....                        */
             /*   I-HASADA            87.05.21   */
             /************************** AJBCJ5 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)

             RTVJOBA    JOB(&WSID)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             DLTF       FILE(AJBWPP5)
             MONMSG     MSGID(CPF3261 CPF2105)
             DSPOBJD    OBJ(*LIBL/*ALL) OBJTYPE(*PGM) +
                          OUTPUT(*OUTFILE) OUTFILE(HWFILE1/AJBWPP5)

             CLRPFM     FILE(AJBNPP5)
             CALL       PGM(AJBRP5)
             DLTF       FILE(AJBWPP5)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(60) RPLUNPRT(*YES ' ') +
                          ALIGN(*NO) OUTQ(&PRTG) FORMTYPE(K6S1) +
                          HOLD(*YES) IGCDTA(&PIGCD)
             CALL       PGM(AJBRJ5)
             DLTOVR     FILE(QPRINT)

             CLRPFM     FILE(AJBNPP5)

             ENDPGM
