             PGM        PARM(&P@NTYM &P@PP01 &PRTG@)
             /** ABMCA0 ************************/
             /*内示数異常リスト          */
             /*   HOTTA.           2018.08.28  */
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
             DCL        VAR(&ABMWPA0) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ABMWPA3) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ABMWP12) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&P@PP01) TYPE(*CHAR) LEN(1)
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
             CHGVAR     VAR(&ABMWPA0) VALUE('ABMWPA0')
             CHGVAR     VAR(&ABMWPA3) VALUE('ABMWPA3')
             CHGVAR     VAR(&ABMWP12) VALUE('ABMWP12')

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
 STP10:
         /*内示数異常リスト*/
             DLTF       FILE(&WLIB/&ABMWP12)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&ABMWP12) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ABMWP12) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 5000 20) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(ABMWP12) TOFILE(&WLIB/&ABMWP12)
             CALL       PGM(ABMRA0) PARM(&P@NTYM &P@PP01)
         /*構成品でFCEPP01にもある品番*/
             CALL       PGM(ABMRA8) PARM(&P@NTYM &P@PP01)
         /*内示数異常リスト*/
             DLTF       FILE(&WLIB/&ABMWPA0)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&ABMWPA0) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ABMWPA0) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 5000 20) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(ABMWP12) TOFILE(&WLIB/&ABMWP12)
             OVRDBF     FILE(ABMWPA0) TOFILE(&WLIB/&ABMWPA0)
             CALL       PGM(ABMRA1) PARM(&P@NTYM &P@PP01 &FNAM)

             OVRDBF     FILE(ABMWPA0) TOFILE(&WLIB/&ABMWPA0)
             OVRPRTF    FILE(ABMPRA5) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          198) CPI(15) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&PRTG@) FORMTYPE(K6H1) IGCDTA(&PIGCD)
             CALL       PGM(ABMRA5) PARM(&FNAM)

 #END:
 END:        ENDPGM
