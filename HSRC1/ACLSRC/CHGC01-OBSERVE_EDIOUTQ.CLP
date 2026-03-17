             /** CHGC01 ************************************/
             /*OBSERVE EDIOUTQ                       */
             /*   T.SAKAKI                 2015.12.23      */
             /**********************************************/
             DCL        VAR(&SYSN) TYPE(*CHAR) LEN(8)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OUTO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OUTN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PAR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&OSTS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&OLDT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS)   TYPE(*CHAR) LEN(3)
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)   TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 3))
             CHGVAR     VAR(&FILE1) VALUE('CHGWP01')
           /*--------------------------------------------*/
           /*    CHECK ENVIRONMENT                        */
           /*--------------------------------------------*/
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

             DLTF       FILE(&WLIB/&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTPF      FILE(&WLIB/&FILE1) RCDLEN(256) IGCDTA(*YES) +
                          SIZE(25000)

             CHKOBJ     OBJ(QGPL/EDIOUTQ) OBJTYPE(*OUTQ)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(@END))

             OVRPRTF    FILE(QPDSPAJB) HOLD(*YES)
             WRKOUTQ    OUTQ(QGPL/EDIOUTQ) OUTPUT(*PRINT)
             CPYSPLF    FILE(QPRTSPLQ) TOFILE(&WLIB/&FILE1) +
                          SPLNBR(*LAST)
             DLTSPLF    FILE(QPRTSPLQ) SPLNBR(*LAST)
             OVRDBF     FILE(CHGWP01) TOFILE(&FILE1)

             CALL       PGM(CHGR01) PARM(&PAR)

             DLTOVR     FILE(*ALL)

 @END:       ENDPGM
