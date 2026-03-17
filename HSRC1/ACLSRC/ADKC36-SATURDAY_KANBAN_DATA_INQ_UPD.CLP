             PGM
             /** ADKC36 **********************************************/
             /*臨時かんばん照会・更新                              */
             /*    KATOGI.          2015.12.21                       */
             /********************************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
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
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PAPHZ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&ADKWP36) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PSHN1) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PSHN2) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PSHN3) TYPE(*CHAR) LEN(2)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))
             CHGVAR     VAR(&ADKWP36) VALUE('ADKWP36' *CAT &WS3)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&USER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO
 STP10:
             CALL       PGM(ADKR36) PARM(&PAPHZ &PSHN1 &PSHN2 &PSHN3 +
                          &PCMD)
             IF         COND(&PCMD *EQ '01') THEN(GOTO CMDLBL(#END))
 STPA1:
             DLTF       FILE(&WLIB/&ADKWP36)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&ADKWP36) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(ADKWP36) +
                          OPTION(*NOLIST *NOSRC) SIZE(5000 1500 +
                          3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(ADKWP36) TOFILE(&WLIB/&ADKWP36)
             CALL       PGM(ADKR37) PARM(&PAPHZ &PSHN1 &PSHN2 &PSHN3 +
                          &PCMD)
             OVRDBF     FILE(ADKWP36) TOFILE(&WLIB/&ADKWP36)
             CALL       PGM(ADKR38) PARM(&PAPHZ &PSHN1 &PSHN2 &PSHN3 +
                          &PCMD)
             IF         COND(&PCMD *EQ '05') THEN(DO)
             CALL       PGM(ADKR35)
             ENDDO
             GOTO       CMDLBL(STP10)

 #END:       ENDPGM
