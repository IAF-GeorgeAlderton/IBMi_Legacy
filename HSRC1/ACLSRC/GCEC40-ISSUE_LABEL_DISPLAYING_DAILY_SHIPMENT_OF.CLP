             PGM
             /** GCEC40 ********************************************/
             /* .. WASHER LABEL                                        */
             /*                                                    */
             /**********************************************GCEC40**/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SKUB) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PEND) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)


             DLTF       FILE(QTEMP/GCEWP31)
              MONMSG     MSGID(CPF3261 CPF2105)

             CRTPF      FILE(QTEMP/GCEWP31) RCDLEN(100) TEXT('ISSUE +
                          LABEL DISPLAYING DAILY SHIPMENT OF AN +
                          ADD') OPTION(*NOLIST) SIZE(5000) LVLCHK(*NO)

             CALL       PGM(GCER40) PARM(&PEND)
             IF         COND(&PEND *EQ '1') THEN(GOTO CMDLBL(END))

             DLTF       FILE(QTEMP/GCEWP32)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/GCEWP32) RCDLEN(100) +
                          TEXT('ISSUE LABEL DISPLAYING DAILY +
                          SHIPMENT OF AN ADD') OPTION(*NOLIST) +
                          SIZE(5000) LVLCHK(*NO)

             FMTDTA     INFILE((QTEMP/GCEWP31)) +
                          OUTFILE(QTEMP/GCEWP32) SRCFILE(FMTSRC) +
                          SRCMBR(GCES31) OPTION(*NOPRT)

             /******/
             OVRPRTF    FILE(GCEPR30) DEVTYPE(*AFPDS) LPI(6) +
                          FOLD(*YES) RPLUNPRT(*YES) OUTQ(QPRINTC) +
                          FORMTYPE(D997)
             MONMSG     MSGID(CPF5004)
             CALL       PGM(GCER31)
             DLTOVR     FILE(GCEPR30)

 END:

             ENDPGM
