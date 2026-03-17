             PGM
             /** ABMCG0 ************************/
             /*未納ＫＰＩ                      */
             /*   HOTTA.           2018.09.14  */
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
             DCL        VAR(&ABMWPG1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ABMWPG2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&FNAM)  TYPE(*CHAR) LEN(30)
             DCL        VAR(&P9SYUN) TYPE(*DEC) LEN(7 0)
             DCL        VAR(&P9APCS) TYPE(*DEC) LEN(7 0)
             DCL        VAR(&P9KTNA) TYPE(*DEC) LEN(7 0)
             DCL        VAR(&P9SYKA) TYPE(*DEC) LEN(9 2)
             DCL        VAR(&P9HAK)  TYPE(*DEC) LEN(9 2)
             RTVJOBA    JOB(&WSID) USER(&PPUSER) DATE(&DDATE)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO
             CHGVAR     VAR(&ABMWPG1) VALUE('ABMWPG1' *CAT &WS3)
             CHGVAR     VAR(&ABMWPG2) VALUE('ABMWPG2' *CAT &WS3)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

 STP00:
             CALL       PGM(ABMRG0) PARM(&P@NTYM &PCMD)
             IF         COND(&PCMD *EQ '01') THEN(GOTO CMDLBL(#END))
 STP10:
         /*瞬間未納*/
             DLTF       FILE(&WLIB/&ABMWPG1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&ABMWPG1) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ABMWPG1) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 5000 20) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(ABMWPG1) TOFILE(&WLIB/&ABMWPG1)
             CALL       PGM(ABMRG1) PARM(&P@NTYM &P9SYUN)

         /*工程内・A-PICS */
             DLTF       FILE(&WLIB/&ABMWPG2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&ABMWPG2) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ABMWPG2) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 5000 20) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(ABMWPG2) TOFILE(&WLIB/&ABMWPG2)
             CALL       PGM(ABMRG2) PARM(&P@NTYM &P9APCS &P9KTNA)

         /*出荷*/
             CALL       PGM(ABMRG3) PARM(&P@NTYM &P9SYKA &P9HAK)

         /*表示*/
             CALL       PGM(ABMRG4) PARM(&P@NTYM &P9SYUN &P9APCS +
                          &P9KTNA &P9SYKA &P9HAK &PCMD)
             GOTO       CMDLBL(STP00)
 #END:
 END:        ENDPGM
