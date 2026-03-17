             PGM
             /** AB#C6G ************************/
             /*  ..TMMNA ACCOUNT PAYBALE LIST  */
             /*                                */
             /* TCHK1 06/17/09 CHG LANPRT04 --> LANPRT03 */
             /************************ AB#C6G **/
             DCLF       FILE(AB#PW6G)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USR)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PNONY) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&DAT6)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&DAT8)  TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID) USER(&USR) DATE(&DAT6)
             CHGVAR     VAR(&DAT8) VALUE('20' *CAT &DAT6)
             CHGVAR     VAR(&DAT6) VALUE(%SUBSTRING(&DAT8 1 6))
             CHGVAR     VAR(&PDATE) VALUE(&DAT6)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CALL       PGM(ALBC00) PARM(&USR &WLIB)
 @STRT:
             SNDRCVF    RCDFMT(DSP01)

             CHGVAR     VAR(&IN61) VALUE('0')
             CHGVAR     VAR(&IN62) VALUE('0')

             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(@END))
             IF         COND(&IN05 *EQ '0') THEN(GOTO CMDLBL(@STRT))
             IF         COND(&SLCT *LT '1' *OR &SLCT *GT '3') +
                          THEN(GOTO CMDLBL(@STRT))

             IF         COND(&CUST *LT '1' *OR &CUST *GT '3') THEN(DO)
             CHGVAR     VAR(&IN61) VALUE('1')
             GOTO       CMDLBL(@STRT)
             ENDDO

             IF         COND(&CUST *LT '1' *OR &CUST *GT '3') THEN(DO)
             CHGVAR     VAR(&IN61) VALUE('1')
             GOTO       CMDLBL(@STRT)
             ENDDO

             IF         COND(&PDATE *EQ 0) THEN(DO)
             CHGVAR     VAR(&IN62) VALUE('1')
             GOTO       CMDLBL(@STRT)
             ENDDO

 /* LIST */
             IF         COND(&SLCT *NE '2') THEN(DO)

/* TCHK1     OVRPRTF    FILE(QPRINT)  OUTQ(LANPRT04) */
/* TCHK1 */  OVRPRTF    FILE(QPRINT)  OUTQ(LANPRT03)
             CALL       PGM(AB#R6H) PARM(&CUST &PDATE)
             ENDDO
  /* DATA */
             IF         COND(&SLCT *NE '1') THEN(DO)
             CLRPFM     FILE(AB#PP6B)
             CLRPFM     FILE(AB#PP6C)
             CALL       PGM(AB#R6I) PARM(&CUST &PDATE)
             ENDDO

 @END:       ENDPGM
