             PGM
             /** AGGC05 **************************/
             /*  ..自動ＳＮＤＮＥＴＳＰＬＦ..  */
             /*     I-HASADA      2000.12.11     */
             /****************** COPY FROM AGGC01 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(2)
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(9)
             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 2))

             CHGVAR     VAR(&FILE1) VALUE('AGGWP05' *CAT &WS)

             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE1) RCDLEN(150) +
                          IGCDTA(*YES) SIZE(*NOMAX) AUT(*ALL)

             CHGJOB     OUTQ(TPRINT)
             WRKOUTQ    OUTQ(TPRINT) OUTPUT(*PRINT)

             CPYSPLF    FILE(QPRTSPLQ) TOFILE(&FILE1) SPLNBR(*LAST)
             DLTSPLF    FILE(QPRTSPLQ) SPLNBR(*LAST)

             OVRDBF     FILE(AGGWP05) TOFILE(&FILE1)
             CALL       PGM(AGGR05)
             DLTF       FILE(&FILE1)
             DLTOVR     FILE(*ALL)

             ENDPGM
