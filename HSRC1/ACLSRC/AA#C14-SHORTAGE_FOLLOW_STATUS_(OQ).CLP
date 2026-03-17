             PGM
             /** AA#C14 **********************************************/
             /* SHORTAGE FOLLOW STATUS (OQ)                          */
             /*    OSHIMA.         2021.04.15                        */
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
             CHGVAR     VAR(&P1PG) VALUE(1)
 STP10:
             CHKOBJ     OBJ(&OBJL/AA#C10ACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STP20))

             DLYJOB     DLY(10)
             GOTO       CMDLBL(STP10)
 STP20:

             RTVDTAARA  DTAARA(AA#C10TIM) RTNVAR(&DAT14)
             CHGVAR     VAR(&P1DATE) VALUE(%SST(&DAT14 1 8))
             CHGVAR     VAR(&P1TIME) VALUE(%SST(&DAT14 9 6))
 STP30:
             DLTF       FILE(QTEMP/AA#WP14)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AA#WP14) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AA#WP14) OPTION(*NOLIST *NOSRC) +
                          SIZE(500000 1500 3) LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(AA#C15)

       /*    CPYF       FROMFILE(&WLIB/AA#WP14) +                      */
       /*                 TOFILE(QTEMP/AA#WP14) MBROPT(*REPLACE) +     */
       /*                 FMTOPT(*MAP *DROP)                           */

             OVRDBF     FILE(AA#WP14) TOFILE(QTEMP/AA#WP14)
             RTVMBRD    FILE(QTEMP/AA#WP14) NBRCURRCD(&REC)
             CALL       PGM(AA#R14) PARM(&P1PG &P1DATE &P1TIME +
                          &REC &P1CMD)
             DLTOVR     FILE(AA#WP14)
             IF         COND(&P1CMD *EQ '01') THEN(GOTO CMDLBL(#END))
             IF         COND(&P1CMD *EQ '05') THEN(GOTO CMDLBL(STP00))
             IF         COND(&P1PG *EQ 1) THEN(GOTO CMDLBL(STP00))
             GOTO       CMDLBL(STP30)

 #END:       ENDPGM
