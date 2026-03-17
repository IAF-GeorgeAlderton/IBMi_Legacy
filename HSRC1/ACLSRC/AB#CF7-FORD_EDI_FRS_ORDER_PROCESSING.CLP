             PGM        PARM(&SELEC &PTITL)
             /** AB#CF7 **************************************/
             /*  FORD EDI(830) FRS ORDER PROCESSING..        */
             /*  TCH  06.06.00                               */
             /*  TCH  07.17.00 ADD FILE CLEAR ABFBP01        */
             /*  TCH  09.21.00 ADD DOCK CODE                 */
             /*  TCH  10.25.00 NIRVANA                       */
             /*  TCH  04.25.01 ADD UPDATE CUM. PGM AB#RFF    */
             /*  TCH 2001.09.14 RETRIEVE FORD CODE FROM ABF9P01(AB#RF0)     */
             /*  TCH 2002.04.04 ADD DATE CHECK(PAST)                        */
             /*  TCH 2002.05.29 ADD DATE CHECK(FUTURE)                      */
             /*  TCH 2002.06.06 SIMPLIFY THE SCREEN                         */
             /* TCHK1 01/08/10 ADD GROUPE CONTROL            */
             /* TCHK2 11/18/11 ADD BIN#                      */
             /* TCHK3 03/15/13 ADD GROUPE CONTROL '3'        */
             /* T.SAKAKI 05/13/05 CHANGE OUTQ FOR AB#R2G %0001 */
             /***************************** AB#CF7 ***********/
             DCLF       FILE(AB#PWF7)
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
      /***** DCL        VAR(&RDATE) TYPE(*CHAR) LEN(8)  *****/
      /***** DCL        VAR(&SDATE) TYPE(*CHAR) LEN(8)  *****/
             DCL        VAR(&KEN) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&FDID) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ERID) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PTITL) TYPE(*CHAR) LEN(35)

             DCL        VAR(&F05  ) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&PDAT ) TYPE(*CHAR) LEN(8) VALUE(' ')
             DCL        VAR(&SDAT ) TYPE(*CHAR) LEN(8) VALUE(' ')

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(AB#PWF71)

             CHGVAR     VAR(&IN41) VALUE('0')
             CHGVAR     VAR(&IN42) VALUE('0')
             CHGVAR     VAR(&IN43) VALUE('0')
             CHGVAR     VAR(&IN44) VALUE('0')
             CHGVAR     VAR(&IN45) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')
/* F1: END */
             IF         (&IN01 *EQ '1') GOTO ENDP

/* CHECK SHIP DATE */
             CALL       PGM(AB#RA7) PARM(&PSYYY &PSMMM &PSDDD &ERID)
             IF         COND(&ERID *EQ '1') THEN(DO)
             CHGVAR     VAR(&IN41) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('SHIPPING DATE ERROR ')
             GOTO       STP1
             ENDDO

/* CHECK RELEASE DATE */
             CALL       PGM(AB#RA7) PARM(&PRYYY &PRMMM &PRDDD &ERID)
             IF         COND(&ERID *EQ '1') THEN(DO)
             CHGVAR     VAR(&IN42) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('RELEASE DATE ERROR ')
             GOTO       STP1
             ENDDO

/* DELIVERY CODE CHECK               */
             IF         (&PSIRE *NE '    ') DO
             IF         (&PSIRK *EQ ' ') DO
             CHGVAR     VAR(&IN44) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT SUPPLIER FACTORY')
             GOTO       STP1
             ENDDO

/* CHECK GROUP */
             IF         (&PGRP  *NE ' ') DO
             CHGVAR     VAR(&IN43) VALUE('1')
             CHGVAR     VAR(&IN45) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT DELIVERY OR GROUP')
             GOTO       STP1
             ENDDO

/* CHECK DELIVERY CODE*/
             CALL       PGM(AB#RF0) PARM(&PSIRE &FDID)
             IF         COND(&FDID *EQ ' ') THEN(DO)
             CHGVAR     VAR(&IN43) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('DELIVERY INCORRECT')
             GOTO       STP1
             ENDDO
             ENDDO

/* GROUP CODE CHECK */
             IF         COND((&PGRP  *EQ ' ') *OR +
                        (&PGRP  *EQ '1')      *OR +
                        (&PGRP  *EQ '2')      *OR +
                        (&PGRP  *EQ '3'))
             ELSE       DO
             CHGVAR     VAR(&IN45) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('GROUP# ERROR ')
             GOTO       STP1
             ENDDO

/* IF NO ERROR... */
             IF         COND(&ERID *EQ '2' *AND &IN21 *EQ '0') THEN(DO)
             CHGVAR     VAR(&IN41) VALUE('1')
             CHGVAR     VAR(&IN42) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('IF DATES ARE CORRECT, PRESS +
                          F21(SHIFT + F9)')
             GOTO       STP1
             ENDDO

 /* F5: PROCESS */
             IF         COND(&IN05 *EQ '0' *AND &IN21 *EQ '0') +
                          THEN(GOTO CMDLBL(STP1))

             CHGVAR     VAR(&F05) VALUE('Y')

/* CALL FRS PROCESS  */
             DLTF       FILE(QTEMP/AB#WP2A)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP2A) RCDLEN(100) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(AB#WP2A) TOFILE(QTEMP/AB#WP2A)

/* TCHK1     CALL       PGM(AB#C2G) PARM(&PSIRE &SELEC &PRYYY +     */
/*******                  &PRMMM &PRDDD &PSYYY &PSMMM &PSDDD)       */
/* TCHK2 X TCHK1 CALL   PGM(AB#C2G) PARM(&PSIRE &SELEC &PRYYY +     */
/*******                  &PRMMM &PRDDD &PSYYY &PSMMM &PSDDD &PGRP) */

/* TCHK2 */  CALL       PGM(AB#C2G) PARM(&PSIRE &SELEC &PRYYY +
                          &PRMMM &PRDDD &PSYYY &PSMMM &PSDDD  +
                          &PGRP &PBIN#)

             RTVMBRD    FILE(QTEMP/AB#WP2A) NBRCURRCD(&KEN)

             IF         (&KEN *GT 0) THEN(DO)
          /* %0001                                                     */
          /* OVRPRTF    FILE(QPRINT) PAGESIZE(66 132) OVRFLW(60) +     */
          /*              RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +  */
          /*              IGCDTA(&PIGCD)                               */

             IF         COND(&USER *NE 'TEST') THEN(DO)
             OVRPRTF    FILE(QPRINT) PAGESIZE(66 132) OVRFLW(60) +
                          RPLUNPRT(*YES) OUTQ(LANPRT09) FORMTYPE(K6H1)
                        ENDDO

/* FRS ERROR LIST */
             CALL       PGM(AB#R2G) PARM(&PSIRE)
             DLTF       FILE(QTEMP/AB#WP2A)
             ENDDO

   /*        GOTO       CMDLBL(STP1)    */

 ENDP:
   /* "5 DAYS ORDER" REPORT  */
             IF         COND(&F05 *EQ 'Y') THEN(DO)
             CALL       PGM(UTLR02T) PARM(&PDAT)
             CALL       PGM(UTLR02M) PARM(&PSYYY &PSMMM &PSDDD &SDAT)
             CALL       PGM(ABFCE3 ) PARM(&SDAT &PDAT)
             ENDDO

             ENDPGM
