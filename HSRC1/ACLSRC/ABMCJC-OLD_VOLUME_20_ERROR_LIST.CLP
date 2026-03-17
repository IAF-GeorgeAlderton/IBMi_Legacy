             PGM        PARM(&P@NTYM &PRTG@)
             /** ABMCJC ************************/
             /* OLD VOLUME 20 ERROR LIST */
             /*   HOTTA.           2018.09.13  */
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
             DCL        VAR(&ABMWP7E) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ABMWP7C) TYPE(*CHAR) LEN(10)
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
      /*     CHGVAR     VAR(&ABMWP7E) VALUE('ABMWP7E' *CAT &WS3)     */
      /*     CHGVAR     VAR(&ABMWP7C) VALUE('ABMWP7C' *CAT &WS3)     */
             CHGVAR     VAR(&ABMWP7E) VALUE('ABMWP7E')

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
 STP10:
         /*設定数２０ */
             DLTF       FILE(&WLIB/&ABMWP7E)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&ABMWP7E) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ABMWP7E) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 5000 20) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(ABMWP7E) TOFILE(&WLIB/&ABMWP7E)
             CALL       PGM(ABMR7E) PARM(&P@NTYM '4' &FNAM)

             OVRDBF     FILE(ABMWP7E) TOFILE(&WLIB/&ABMWP7E)
             OVRPRTF    FILE(ABMPRJC) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          198) CPI(15) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&PRTG@) FORMTYPE(K6H1) IGCDTA(&PIGCD)
             CALL       PGM(ABMRJC)

 #END:
 END:        ENDPGM
