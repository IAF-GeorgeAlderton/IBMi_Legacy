             /** CHGC10 ************************************/
             /*MOVE SPOOLS FROM YAJIMA TO LANPRT03     */
             /*          　　　　　　　　　　　　　　　  */
             /*   T.SAKAKI                 2018.05.09      */
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

#STEP1:
             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 3))
             CHGVAR     VAR(&FILE1) VALUE('CHGWP10')
             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTPF      FILE(HWFILE1/&FILE1) RCDLEN(256) IGCDTA(*YES)

             CHKOBJ     OBJ(QUSRSYS/YAJIMA) OBJTYPE(*OUTQ)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(@END))

             OVRPRTF    FILE(QPDSPAJB) HOLD(*YES)
             WRKOUTQ    OUTQ(QUSRSYS/YAJIMA) OUTPUT(*PRINT)
             CPYSPLF    FILE(QPRTSPLQ) TOFILE(HWFILE1/&FILE1) +
                          SPLNBR(*LAST)
             DLTSPLF    FILE(QPRTSPLQ) SPLNBR(*LAST)

             CALL       PGM(CHGR10) PARM(&PAR)

             DLTOVR     FILE(*ALL)

             STRRMTWTR  OUTQ(QUSRSYS/YAJIMA2)
             MONMSG     MSGID(CPF0000)

             WRKOUTQ    OUTQ(QUSRSYS/YAJIMA2)

 @END:       ENDPGM
