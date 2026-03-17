             PGM        PARM(&P@NTYM &PRTG@)
             /** ABMCZ1 ************************/
             /*材料かんばん変更リスト      */
             /*   HOTTA.           2018.10.26  */
             /**********************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&FLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&DDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&P@NTYM) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&P@ERR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&ABMWPZ1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ABMWPZ2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&FNAM) TYPE(*CHAR) LEN(30) +
                          VALUE('MATERIAL KANBAN CHANGE LIST')
             DCL        VAR(&PRTG@) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID) USER(&PPUSER) DATE(&DDATE)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO
             CHGVAR     VAR(&ABMWPZ1) VALUE('ABMWPZ1')
             CHGVAR     VAR(&ABMWPZ2) VALUE('ABMWPZ2')

 STP10:
         /*材料変更リスト*/
             DLTF       FILE(&WLIB/&ABMWPZ1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&ABMWPZ1) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ABMWPZ1) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 5000 20) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(ABMWPZ1) TOFILE(&WLIB/&ABMWPZ1)
         /* IZAPL01 <-> ABMWPZ1 */
             CALL       PGM(ABMRZ1) PARM(&P@NTYM)

             DLTF       FILE(&ABMWPZ2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&ABMWPZ2) RCDLEN(0256) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)
             OVRDBF     FILE(ABMWPZ1) TOFILE(&WLIB/&ABMWPZ1)
             OVRDBF     FILE(ABMWPZ2) TOFILE(&WLIB/&ABMWPZ2)

         /* ABMWPZ1 -> ABMWPZ2 */
             CALL       PGM(ABMRZ2)

             CALL       PGM(APLC96) PARM('1' &ABMWPZ2 &WLIB +
                          &FNAM 'Y' ' ')

             OVRDBF     FILE(ABMWPZ1) TOFILE(&WLIB/&ABMWPZ1)
             OVRPRTF    FILE(ABMPRZ3) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&PRTG@) FORMTYPE(K6H1) IGCDTA(&PIGCD)
         /* WIRE KANBAN CHANGE LIST */
             CALL       PGM(ABMRZ3)

         /*材料計画発行 UPDATE WIRE ORDER ADJUST PLAN */
         /* ABMWPZ1 -> BTBPL05 */
             CALL       PGM(ABMRZ4)

         /*材料変更実績UPDATE RESULT*/
         /* ABMWPZ1 -> ABMPPZ1 */
             CALL       PGM(ABMRZ5) PARM(&P@NTYM)

 #END:
 END:        ENDPGM
