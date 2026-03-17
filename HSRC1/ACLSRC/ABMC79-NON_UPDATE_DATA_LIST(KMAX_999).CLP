             PGM        PARM(&P@NTYM &PRTG@)
             /** ABMC79 ************************/
             /* NON UPDATE DATA LIST(KMAX > 999) */
             /*   HOTTA.           2018.09.03  */
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
             DCL        VAR(&ABMWP70) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ABMWP79) TYPE(*CHAR) LEN(10)
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
             CHGVAR     VAR(&ABMWP70) VALUE('ABMWP70')
             CHGVAR     VAR(&ABMWP79) VALUE('ABMWP79')

 STP10:
         /*更新なしリストNON UPDATE PART NO M/F */
             DLTF       FILE(&WLIB/&ABMWP70)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&ABMWP70) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ABMWP70) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 5000 20) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(ABMWP70) TOFILE(&WLIB/&ABMWP70)
             CALL       PGM(ABMR7D) PARM(&P@NTYM '6' &FNAM)

             DLTF       FILE(&ABMWP79)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&ABMWP79) RCDLEN(0256) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)
             OVRDBF     FILE(ABMWP70) TOFILE(&WLIB/&ABMWP70)
             OVRDBF     FILE(ABMWP79) TOFILE(&WLIB/&ABMWP79)
             CALL       PGM(ABMR79)

             CALL       PGM(APLC96) PARM('1' &ABMWP79 &WLIB +
                          &FNAM 'Y' ' ')

             OVRDBF     FILE(ABMWP70) TOFILE(&WLIB/&ABMWP70)
             OVRPRTF    FILE(ABMPRJ9) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&PRTG@) FORMTYPE(K6H1) IGCDTA(&PIGCD)
             CALL       PGM(ABMRJ9)

 #END:
 END:        ENDPGM
