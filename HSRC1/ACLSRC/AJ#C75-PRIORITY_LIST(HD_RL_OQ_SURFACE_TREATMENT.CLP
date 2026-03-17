             PGM        PARM(&#@OUTQ)
             /*** AJ#C75 ***********************************/
             /* PRIORITY LIST(HD,RL,OQ,SURFACE TREATMENT)  */
             /*  ITS.              2015.05.13              */
             /**********************************************/
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
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&AJ#WP74) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AJ#WP75) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AJ#WP76) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&#@OUTQ) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID) USER(&PPUSER) DATE(&DDATE)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO
       /* AJ#WP74 CREATED AJ#C74 */
             CHGVAR     VAR(&AJ#WP74) VALUE('AJ#WP74' *CAT &WS3)
             CHGVAR     VAR(&AJ#WP75) VALUE('AJ#WP75' *CAT &WS3)
             CHGVAR     VAR(&AJ#WP76) VALUE('AJ#WP76' *CAT &WS3)

             CHGJOB     OUTQ(&PRTG)

 #STP10:
             DLTF       FILE(&WLIB/&AJ#WP75)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AJ#WP75) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(AJ#WP75) +
                          OPTION(*NOLIST *NOSRC) SIZE(9999 500 +
                          3) LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&WLIB/&AJ#WP76)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AJ#WP76) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(AJ#WP76) +
                          OPTION(*NOLIST *NOSRC) SIZE(9999 500 +
                          3) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(AJ#WP74) TOFILE(&WLIB/&AJ#WP74)
             OVRDBF     FILE(AJ#WP75) TOFILE(&WLIB/&AJ#WP75)
             CALL       PGM(AJ#R75)
 #STP20:
             OVRDBF     FILE(AJ#WP75) TOFILE(&WLIB/&AJ#WP75)
             OVRDBF     FILE(AJ#WP76) TOFILE(&WLIB/&AJ#WP76)
             CALL       PGM(AJ#R76)
 #STP30:
             OVRPRTF    FILE(AJ#PR77) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(&#@OUTQ) FORMTYPE(K6H1) HOLD(*NO)
             CALL       PGM(AJ#R77)

 END:
             ENDPGM
