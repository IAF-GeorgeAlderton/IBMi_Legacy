  PGM     PARM(&SELEC &PTITL)
/** AN#CF7 ************************************************/
/*  ANDROID EDI ORDER CREATE PROCESS                      */
/*                                                        */
/* TCHK1 07/12/06 CREATE(COPY FROM AB#CF7)                */
/* T.SAKAKI 05/13/15 CHANGE OUTQ FOR AB#R2G  %0001        */
/**********************************************************/
             DCLF       FILE(AN#PWF7)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PSIRE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&SELEC) TYPE(*CHAR) LEN(2)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&RDATE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&SDATE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&KEN) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&FDID) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ERID) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PTITL) TYPE(*CHAR) LEN(35)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(AN#PWF71)

             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN03) VALUE('0')
             CHGVAR     VAR(&IN04) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&IN01 *EQ '1') GOTO END


/* DELIVERY CODE CHECK               */
             IF         (&PSIRE *NE '    ') DO

             IF         (&PSIRK *EQ ' ') DO
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT NO. SUPPLIER')
             GOTO       STP1
             ENDDO

/* CHECK DELIVERY CODE*/
             CALL       PGM(AN#RF0) PARM(&PSIRE &FDID)

             IF         COND(&FDID *EQ ' ') THEN(DO)

             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('DELIVERY INCORRECT')
             GOTO       STP1
             ENDDO
             ENDDO


   /* DATE CHECK  */
             CALL       PGM(AB#RA7) PARM(&PRYYY &PRMMM &PRDDD &ERID)
             IF         COND(&ERID *EQ '1') THEN(DO)
             CHGVAR     VAR(&IN04) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('DATE ERROR.')
             GOTO       STP1
             ENDDO


             CALL       PGM(AB#RA7) PARM(&PSYYY &PSMMM &PSDDD &ERID)
             IF         COND(&ERID *EQ '1') THEN(DO)
             CHGVAR     VAR(&IN04) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('DATE ERROR.')
             GOTO       STP1
             ENDDO

             IF         COND(&ERID *EQ '2' *AND &IN21 *EQ '0') THEN(DO)
             CHGVAR     VAR(&IN04) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('IF THE DATE IS OK, HIT +
                          F21(SHIFT + F9)')
             GOTO       STP1
             ENDDO



             IF         COND(&IN05 *EQ '0' *AND &IN21 *EQ '0') +
                          THEN(GOTO CMDLBL(STP1))


/* CALL FRS PROCESS  */
             DLTF       FILE(QTEMP/AB#WP2A)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP2A) RCDLEN(100) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(AB#WP2A) TOFILE(QTEMP/AB#WP2A)

             CALL       PGM(AN#C2G) PARM(&PSIRE &SELEC &PRYYY +
                          &PRMMM &PRDDD &PSYYY &PSMMM &PSDDD)

             RTVMBRD    FILE(QTEMP/AB#WP2A) NBRCURRCD(&KEN)

             IF         (&KEN *GT 0) THEN(DO)
      /* %0001 */
      /*     OVRPRTF    FILE(QPRINT) PAGESIZE(66 132) OVRFLW(60) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)   */
             OVRPRTF    FILE(QPRINT) PAGESIZE(66 132) OVRFLW(60) +
                          RPLUNPRT(*YES) OUTQ(LANPRT09) FORMTYPE(K6H1)

/* FRS ERROR LIST */
             CALL       PGM(AB#R2G) PARM(&PSIRE)
             DLTF       FILE(QTEMP/AB#WP2A)
             ENDDO

   /*        GOTO       CMDLBL(STP1)    */

 END:        ENDPGM
