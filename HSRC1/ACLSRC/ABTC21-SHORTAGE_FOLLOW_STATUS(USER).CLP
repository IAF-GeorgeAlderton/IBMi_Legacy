             PGM
             /** ABTC21 **********************************************/
             /* SHORTAGE FOLLOW STATUS(USER)                         */
             /*    SAKAKI.          2019.12.04                       */
             /********************************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&DDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&ABTWP22) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ABTWP23) TYPE(*CHAR) LEN(10)
             DCL        VAR(&P1PG) TYPE(*DEC) LEN(05 0) VALUE(1)
             DCL        VAR(&P1CMD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&OBJL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&P1DATE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&P1TIME) TYPE(*CHAR) LEN(6)
             DCL        VAR(&DAT14) TYPE(*CHAR) LEN(14)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CHGVAR     VAR(&OBJL) VALUE('HOBJ1     ')
             IF         (&USER *EQ 'TEST      ') DO
             CHGVAR     VAR(&OBJL) VALUE('TOBJ1     ')
             ENDDO

             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

 STP00:
             DLTF       FILE(QTEMP/ABTWP22)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/ABTWP22) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ABTWP22) OPTION(*NOLIST *NOSRC) +
                          SIZE(500000 1500 3) LVLCHK(*NO) AUT(*ALL)
             DLTF       FILE(QTEMP/ABTWP26)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/ABTWP26) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ABTWP26) OPTION(*NOLIST *NOSRC) +
                          SIZE(500000 1500 3) LVLCHK(*NO) AUT(*ALL)
             DLTF       FILE(QTEMP/ABTWP23)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/ABTWP23) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ABTWP23) OPTION(*NOLIST *NOSRC) +
                          SIZE(500000 1500 3) LVLCHK(*NO) AUT(*ALL)
             CHGVAR     VAR(&P1PG) VALUE(1)
 STP10:
             CHKOBJ     OBJ(&OBJL/ABTR20ACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STP20))
             DLYJOB     DLY(10)
             GOTO       CMDLBL(STP10)
 STP20:
             CHKOBJ     OBJ(&OBJL/ABBR7PACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STP30))
             DLYJOB     DLY(10)
             GOTO       CMDLBL(STP10)

 STP30:     /* ABTWP21 -> ABTWP22 */
            /* ABTWP21 IS CREATED BY ABTC20 */
             OVRDBF     FILE(ABTWP22) TOFILE(QTEMP/ABTWP22)
             CALL       PGM(ABTR22)
             OVRDBF     FILE(ABTWP26) TOFILE(QTEMP/ABTWP26)
             CALL       PGM(ABTR26)
             OVRDBF     FILE(ABTWP23) TOFILE(QTEMP/ABTWP23)
             CALL       PGM(ABTR23)

             RTVDTAARA  DTAARA(ABTR20TIM) RTNVAR(&DAT14)
             CHGVAR     VAR(&P1DATE) VALUE(%SST(&DAT14 1 8))
             CHGVAR     VAR(&P1TIME) VALUE(%SST(&DAT14 9 6))

 STP40:
             RTVMBRD    FILE(QTEMP/ABTWP23) NBRCURRCD(&REC)
             OVRDBF     FILE(ABTWP23) TOFILE(QTEMP/ABTWP23)
             CALL       PGM(ABTR24) PARM(&P1PG &P1DATE &P1TIME +
                          &REC &P1CMD)
             IF         COND(&P1CMD *EQ '01') THEN(GOTO CMDLBL(#END))
             IF         COND(&P1CMD *EQ '05') THEN(GOTO CMDLBL(STP00))
             IF         COND(&P1PG *EQ 1) THEN(GOTO CMDLBL(STP00))
             GOTO       CMDLBL(STP40)

 #END:       ENDPGM
