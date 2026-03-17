             PGM
             /** ABTC35 **********************************************/
             /* SHORTAGE FOLLOW STATUS 2 (JC)                        */
             /*    SAKAKI.          2020.04.07                       */
             /*    JW1.   2020.03.19 ADD PRINTER SELECTION           */
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
             DCL        VAR(&ABTWP00) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ABTWP01) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ABTWP30) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ABTWP32) TYPE(*CHAR) LEN(10)
             DCL        VAR(&P1PG) TYPE(*DEC) LEN(05 0) VALUE(1)
             DCL        VAR(&P1CMD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&OBJL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&P1DATE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&P1TIME) TYPE(*CHAR) LEN(6)
             DCL        VAR(&DAT14) TYPE(*CHAR) LEN(14)
             DCL        VAR(&RTN  ) TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CHGVAR     VAR(&OBJL) VALUE('HOBJ1     ')
             IF         (&USER *EQ 'TEST      ') DO
             CHGVAR     VAR(&OBJL) VALUE('TOBJ1     ')
             ENDDO


             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

 STP00:
             DLTF       FILE(QTEMP/ABTWL32)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(QTEMP/ABTWP32)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/ABTWP32) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ABTWP32) OPTION(*NOLIST *NOSRC) +
                          SIZE(500000 1500 3) LVLCHK(*NO) AUT(*ALL)
             CRTLF      FILE(QTEMP/ABTWL32) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ABTWL32) OPTION(*NOLIST *NOSRC) +
                          LVLCHK(*NO) AUT(*ALL)
             CHGVAR     VAR(&P1PG) VALUE(1)
 STP10:
             CHKOBJ     OBJ(&OBJL/ABTR00ACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STP20))

             DLYJOB     DLY(10)
             GOTO       CMDLBL(STP10)

 STP20:     /* ABTWP01 -> ABTWP32 */
            /* ABTWP01 IS CREATED BY ABTC00 */
             OVRDBF     FILE(ABTWP32) TOFILE(QTEMP/ABTWP32)
             CALL       PGM(ABTR31) PARM('6')

 STP30:     /* ABTWP31 -> ABTWP32 */
            /* ABTWP31 IS CREATED BY ABTC00 */
             CALL       PGM(ABTR32) PARM('6')

             RTVDTAARA  DTAARA(ABTR00TIM) RTNVAR(&DAT14)
             CHGVAR     VAR(&P1DATE) VALUE(%SST(&DAT14 1 8))
             CHGVAR     VAR(&P1TIME) VALUE(%SST(&DAT14 9 6))

 STP40:
             RTVMBRD    FILE(QTEMP/ABTWP32) NBRCURRCD(&REC)
          /* DISPLAY ABTWP32 */
             CALL       PGM(ABTR35) PARM('6' &P1PG &P1DATE &P1TIME +
                          &REC &P1CMD)
             IF         COND(&P1CMD *EQ '01') THEN(GOTO CMDLBL(#END))
             IF         COND(&P1CMD *EQ '05') THEN(GOTO CMDLBL(STP00))
             IF         COND(&P1CMD *EQ '07') THEN(GOTO CMDLBL(STP50))
             IF         COND(&P1PG *EQ 1) THEN(GOTO CMDLBL(STP00))
             GOTO       CMDLBL(STP40)

 STP50:
          /* JW1 SELECT PRINTER */
             CALL UTLR69 (&PRTG &RTN)

             OVRPRTF    FILE(ABTPR34) PAGESIZE(66 132) OVRFLW(60) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1)
             CALL       PGM(ABTR34) PARM('6')
             GOTO       CMDLBL(STP40)

 #END:       ENDPGM
