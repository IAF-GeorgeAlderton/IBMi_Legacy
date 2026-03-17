             PGM
/** A$DC01 ************************************************/
/*  IAF REGULER CALENDAR MAINTENANCE (FIRM ORDER)         */
/*  J.WATANABE  2017.06.19                                */
/*  ------------------------                              */
/*  JW1         2021.12.23 CHG STEP2                      */
/**********************************************************/
             DCLF       FILE(AGDPW01)

             DCL        VAR(&US)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&US)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

/* TCHK  */  OVRDBF     FILE(AGDPP11) TOFILE(HFILE1/A$DPP11)
/* TCHK  */  OVRDBF     FILE(AGDPL11) TOFILE(HFILE1/A$DPL11)
/* TCHK  */  OVRDBF     FILE(AGDPL12) TOFILE(HFILE1/A$DPL12)

             CHGVAR     VAR(&IN90)  VALUE('1')
             CHGVAR     VAR(&XTITL) VALUE('(REGULAR CALENDAR)')
             CHGVAR     VAR(&XFILE) VALUE('A$DPP11')
             CHGVAR     VAR(&@NO1)  VALUE('1')

 /* SCREEN CHECK 1 */
 /**         CHGVAR     VAR(&@NO1) VALUE('1')                          **/
 /**  STEP1: CHGVAR     VAR(&IN01) VALUE('0')                          **/
 /**  STP1:  SNDRCVF    DEV(&WSID) RCDFMT(AGDPW011)                    **/
 /**         CHGVAR     VAR(&IN02) VALUE('0')                          **/
 /**         CHGVAR     VAR(&IN08) VALUE('0')                          **/
 /**         CHGVAR     VAR(&IN09) VALUE('0')                          **/
 /**         CHGVAR     VAR(&IN99) VALUE('0')                          **/
 /**                                                                   **/
 /**         IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(END))     **/
 /**                                                                   **/
 /**         IF         COND(&@NO1 *NE '1') THEN(DO)                   **/
 /**         CHGVAR     VAR(&IN02) VALUE('1')                          **/
 /**         CHGVAR     VAR(&IN99) VALUE('1')                          **/
 /**         CHGVAR     VAR(&MSG) VALUE('ENTER 1 !          ')         **/
 /**         GOTO       CMDLBL(STP1)                                   **/
 /**         ENDDO                                                     **/
 /**                                                                   **/
 /**         IF         COND(&@NO1 *EQ '1') THEN(DO)                   **/
 /**         CHGVAR     VAR(&IN08) VALUE('1')                          **/
 /**         CHGVAR     VAR(&IN09) VALUE('0')                          **/
 /**         ENDDO                                                     **/
 /**         IF         COND(&@NO1 *EQ '3') THEN(DO)                   **/
 /**         CHGVAR     VAR(&IN08) VALUE('0')                          **/
 /**         CHGVAR     VAR(&IN09) VALUE('1')                          **/
 /**         ENDDO                                                     **/

 /* SCREEN CHECK 2 */
             CHGVAR     VAR(&@NO2) VALUE(' ')
 STEP2:      CHGVAR     VAR(&IN01) VALUE('0')

 STP2:       SNDRCVF    DEV(&WSID) RCDFMT(AGDPW012)
             CHGVAR     VAR(&IN03) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(END))

             IF         COND(&IN90 *EQ '1' *AND &IN09 *EQ '0') THEN(DO)
             IF         COND(&@NO2 *NE '1' *AND &@NO2 *NE '2' *AND +
                          &@NO2 *NE '3' *AND &@NO2 *NE '4') THEN(DO)
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('ENTER 1, 2, 3 OR 4 !     ')
             GOTO       CMDLBL(STP2)
             ENDDO
             ENDDO


             IF         COND(&IN90 *EQ '1' *AND &IN09 *EQ '1') THEN(DO)
             IF         COND(&@NO2 *NE '1' *AND &@NO2 *NE '2' *AND +
                          &@NO2 *NE '3' *AND &@NO2 *NE '4' *AND +
                          &@NO2 *NE '5') THEN(DO)
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('ENTER 1, 2, 3, 4 OR 5 !')
             GOTO       CMDLBL(STP2)
             ENDDO
             ENDDO

             ELSE DO

             IF         (&IN90 *EQ '0' *AND &@NO2 *NE '1') DO
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('ENTER 1 !          ')
             GOTO       CMDLBL(STP2)
             ENDDO
             ENDDO


 /* INQUIRY */
             IF         COND(&@NO2 *EQ '1') THEN(DO)
             CHGJOB     SWS(00000000)
             IF         COND(&IN09 *EQ '0') THEN(DO)
             CALL       PGM(AGDR01) PARM(&@NO1 &@NO2)
             ENDDO

             IF         COND(&IN09 *EQ '1') THEN(DO)
             CALL       PGM(AGDR33)
             ENDDO
             IF         (%SWITCH(1XXXXXXX)) DO
       /***  GOTO       STEP1 ***/
             GOTO       STEP2
             ENDDO
             ENDDO

 /* MAKING DATA */
             IF         COND(&@NO2 *EQ '2') THEN(DO)
             CHGJOB     SWS(00000000)
             IF         COND(&IN09 *EQ '0') THEN(DO)
             CALL       PGM(AGDR02) PARM(&@NO1 &@NO2)
             ENDDO

             IF         COND(&IN09 *EQ '1') THEN(DO)
             CALL       PGM(AGDR31)
             ENDDO
             IF         (%SWITCH(1XXXXXXX)) DO
       /***  GOTO       STEP1 ***/
             GOTO       STEP2
             ENDDO
             ENDDO

 /* CHANGE */
             IF         COND(&@NO2 *EQ '3') THEN(DO)
             CHGJOB     SWS(00000000)
             IF         COND(&IN09 *EQ '0') THEN(DO)
             CALL       PGM(AGDR03) PARM(&@NO1 &@NO2)
             ENDDO

             IF         COND(&IN09 *EQ '1') THEN(DO)
             CALL       PGM(AGDR32)
             ENDDO
             IF         (%SWITCH(1XXXXXXX)) DO
       /***  GOTO       STEP1 ***/
             GOTO       STEP2
             ENDDO
             ENDDO


 /* MAKING LIST */
             IF         COND(&@NO2 *EQ '4') THEN(DO)
             CHGJOB     SWS(00000000)
             IF         COND(&IN09 *EQ '0') THEN(DO)
             CALL       PGM(AGDC04) PARM(&@NO1 &@NO2)
             ENDDO

             IF         COND(&IN09 *EQ '1') THEN(DO)
             CALL       PGM(AGDR34)
             ENDDO
             IF         (%SWITCH(1XXXXXXX)) DO
       /***  GOTO       STEP1 ***/
             GOTO       STEP2
             ENDDO
             ENDDO


 /* INQUIRY OF  ALL CUSTOMER AND FACTORIES */
             IF         COND(&IN09 *EQ '1' *AND &@NO2 *EQ '5') THEN(DO)
             CHGJOB     SWS(00000000)
             CALL       PGM(AGDR35)
             ENDDO

             IF         (%SWITCH(1XXXXXXX)) DO
       /***  GOTO       STEP1 ***/
             GOTO       STEP2
             ENDDO

 END:        ENDPGM
