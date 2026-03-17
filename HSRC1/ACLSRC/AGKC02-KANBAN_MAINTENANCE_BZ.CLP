             PGM
             /*** AGKC02 ***********************************/
             /* KANBAN MAINTENANCE BZ                      */
             /*  ITS.              2013.12.25              */
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
             DCL        VAR(&AGKWP02) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             RTVJOBA    JOB(&WSID) USER(&PPUSER) DATE(&DDATE)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO

             CHGVAR     VAR(&AGKWP02) VALUE('AGKWP02' *CAT &WS3)

             CHGJOB     OUTQ(&PRTG)

 #STP10:
             DLTF       FILE(&WLIB/&AGKWP02)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AGKWP02) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(AGKWP02) +
                          OPTION(*NOLIST *NOSRC) SIZE(9999 500 +
                          3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AGKWP02) TOFILE(&WLIB/&AGKWP02)
             CALL       PGM(AGKR03)
 #STP20:
             OVRDBF     FILE(AGKWP02) TOFILE(&WLIB/&AGKWP02)
             CALL       PGM(AGKR02)

 END:
             ENDPGM
