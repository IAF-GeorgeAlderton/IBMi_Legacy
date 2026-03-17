             PGM
             /*** ECDCP1 ************************************/
             /* MATERIAL INCOMING LIST INPUT              */
             /*         M-OKUDA         1985.11.21          */
             /***********************************************/
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SW) TYPE(*CHAR) LEN(8)
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(7)
             /* SYSTEM VALUE COMMAND INPUT                  */
             RTVJOBA    JOB(&WSNO)

             CALL       PGM(AGAR00) PARM(&WSNO &PRT &TYPE &PRTG)

             CHGVAR     VAR(%SUBSTRING(&FILE1 1 5)) +
                          VALUE('ECDWP')
             CHGVAR     VAR(%SUBSTRING(&FILE1 6 2)) +
                          VALUE(%SUBSTRING(&WSNO 1 2))

             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE1) RCDLEN(88) +
                          TEXT('MATERIAL INCOMING LIST WORK') +
                          OPTION(*NOLIST) SIZE(9999 100) LVLCHK(*NO)

             CHGJOB     OUTQ(&PRTG) SWS(00000000)
             OVRDBF     FILE(ECDWP11) TOFILE(&FILE1)
             CALL       PGM(ECDR11)
             DLTOVR     FILE(ECDWP11)

             RTVJOBA    SWS(&SW)
             IF         (%SUBSTRING(&SW 1 1) *EQ '1') GOTO END

             OVRDBF     FILE(ECDWP11) TOFILE(&FILE1)
             CALL       PGM(ECDR12)
             DLTOVR     FILE(ECDWP11)

 END:        ENDPGM
