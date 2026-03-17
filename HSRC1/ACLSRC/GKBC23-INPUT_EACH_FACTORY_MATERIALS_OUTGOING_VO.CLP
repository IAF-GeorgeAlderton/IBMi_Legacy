             PGM
             /*** GKBC23 *********************************/
             /* INPUT EACH FACTORY MATERIALS OUTGOING VOTE */
             /*         H.ITO            88.10.01        */
             /********************************* GKBC23 ***/
             DCL        VAR(&WSNO)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&SW)    TYPE(*CHAR) LEN(8)
             DCL        VAR(&MBAN)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(9)
             /* SYSTEM VALUE INPUT WITH COMMAND                 */
             RTVJOBA    JOB(&WSNO) USER(&USER)

             CALL       AGAR00 PARM(&WSNO &PRT &TYPE &PRTG)

 STEP02:     CHGVAR     VAR(%SST(&FILE1 1 7)) VALUE('GKBWP23')
             CHGVAR     VAR(%SST(&FILE1 8 2)) VALUE(%SST(&WSNO 1 2))

             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE1) RCDLEN(100) +
                          TEXT('MATERIAL OUTGOING VOTE WORK') OPTION(*NOLIST) +
                          SIZE(500 100) LVLCHK(*NO)

             CHGJOB     OUTQ(&PRTG) SWS(00000000)
             OVRDBF     FILE(GKBWP23) TOFILE(&FILE1)
             CALL       PGM(GKBR23) PARM(&USER)

             RTVJOBA    SWS(&SW)
             IF         (%SST(&SW 1 1) *EQ '1') GOTO END

             CALL       PGM(GKBR24)
             DLTOVR     FILE(GKBWP23)

 END:        DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)

             ENDPGM
