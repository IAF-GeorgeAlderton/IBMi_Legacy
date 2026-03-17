             PGM
             /** ABMCH1 ************************/
             /*仕入先オーダー警告リスト      */
             /*  SUPPLIER ORDER WARNING LIST   */
             /*   HOTTA.           2018.11.01  */
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
             DCL        VAR(&P@ERR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&ABMWPH1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&FNAM)  TYPE(*CHAR) LEN(30)
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
             CHGVAR     VAR(&ABMWPH1) VALUE('ABMWPH1' *CAT &WS3)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
 STP00:
             CALL       PGM(ABMRH0) PARM(&PCMD &PRTG@)
             IF         COND(&PCMD *EQ '01') THEN(GOTO CMDLBL(#END))
 STP10:
             DLTF       FILE(&WLIB/&ABMWPH1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&ABMWPH1) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ABMWPH1) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 5000 20) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(ABMWPH1) TOFILE(&WLIB/&ABMWPH1)
             CALL       PGM(ABMRH1)

             OVRPRTF    FILE(ABMPRH2) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          198) CPI(15) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&PRTG@) FORMTYPE(K6H1) IGCDTA(&PIGCD)
             CALL       PGM(ABMRH2)

             CALL       PGM(ABMRH3)

 #END:
 END:        ENDPGM
