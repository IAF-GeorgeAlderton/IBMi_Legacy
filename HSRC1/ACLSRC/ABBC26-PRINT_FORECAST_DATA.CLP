             PGM
             /** ABBC26 ********************************/
             /* FORECAST DATA LIST                                      LIST */
             /*      TCH  JUL/12/04                    */
             /******************************** ABBC26 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHKOBJ     OBJ(&WLIB/ABBWP26) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(&WLIB/ABBWP26) RCDLEN(256))
                          CLRPFM &WLIB/ABBWP26

             CALL       PGM(ABBR26)

             ENDPGM
