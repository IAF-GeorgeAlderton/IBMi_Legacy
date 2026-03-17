             PGM
             /*** AJ#C01 ***********************************/
             /* A-PICS SORT M/F                            */
             /*  ITS.              2013.11.25              */
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
             DCL        VAR(&AJ#WP01) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             RTVJOBA    JOB(&WSID) USER(&PPUSER) DATE(&DDATE)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO

             CHGVAR     VAR(&AJ#WP01) VALUE('AJ#WP01' *CAT &WS3)

             CHGJOB     OUTQ(&PRTG)

 #STP10:
             DLTF       FILE(&WLIB/&AJ#WP01)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AJ#WP01) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(AJ#WP01) +
                          OPTION(*NOLIST *NOSRC) SIZE(9999 500 +
                          3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AJ#WP01) TOFILE(&WLIB/&AJ#WP01)
             CALL       PGM(AJ#R03)
             CALL       PGM(AJ#R01) PARM(&PCMD)
             IF         COND(&PCMD *EQ '01') THEN(DO)
             GOTO END
             ENDDO
 #STP20:
             CALL       PGM(AJ#R04)

 END:
             ENDPGM
