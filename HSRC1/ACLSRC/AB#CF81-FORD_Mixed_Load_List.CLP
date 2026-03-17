PGM
/** AB#CF81 ***********************************************/
/*  FORD MIXED LOAD LIST                                  */
/*                                                        */
/*  TCHK1  2005.11.04 CREATE                              */
/*  TCHK2  2010.01.04 ADD PARM                            */
/*  TCHK3  2012.04.26 ADD GROUP CONTROL                   */
/*  TCHK4  2013.03.15 ADD GROUP CONTROL                   */
/********************************************** AB#CF81 ***/
             DCLF       FILE(AB#PWF81)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PSIREX) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PDOCK)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&WNOHZ)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WREDT)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&PEND)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDOCKX) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PMANI)  TYPE(*CHAR) LEN(11)
             DCL        VAR(&PPS#)   TYPE(*DEC)  LEN(6 0)
             DCL        VAR(&WKSID)  TYPE(*CHAR) LEN(3)

             RTVJOBA    JOB(&WSID) USER(&US)
             CHGJOB     SWS(00000000)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CALL       PGM(ALBC00) PARM(&US &WLIB)

             CHGVAR     VAR(&WKSID) VALUE(%SUBSTRING(&WSID 1 3))

             CHKOBJ     OBJ(AB#WPF8H) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WPF8H) +
                          MBR(&WKSID))
             CHKOBJ     OBJ(AB#WPF8D) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WPF8D) +
                          MBR(&WKSID))

             CLRPFM     FILE(AB#WPF8H) MBR(&WKSID)
             CLRPFM     FILE(AB#WPF8D) MBR(&WKSID)
             OVRDBF     FILE(AB#WPF8H) TOFILE(AB#WPF8H) MBR(&WKSID)
             OVRDBF     FILE(AB#WPF8D) TOFILE(AB#WPF8D) MBR(&WKSID)


             CHGVAR     VAR(&PSIRE) VALUE('    ')
             CHGVAR     VAR(&PSIRK) VALUE('0')
             CHGVAR     VAR(&PNOHZ) VALUE(0)
             CHGVAR     VAR(&PNOBI) VALUE(0)
             CHGVAR     VAR(&PDOCK) VALUE('    ')
             CHGVAR     VAR(&PREDT) VALUE(0)
 /* T        CHGVAR     VAR(&PPS#)  VALUE(0)             */
 /* T        CHGVAR     VAR(&PMANI) VALUE('           ') */

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(AB#PWR81)

             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN03) VALUE('0')
             CHGVAR     VAR(&IN04) VALUE('0')
             CHGVAR     VAR(&IN06) VALUE('0')
             CHGVAR     VAR(&IN07) VALUE('0')
             CHGVAR     VAR(&IN08) VALUE('0')
/* TCHK3 */  CHGVAR     VAR(&IN09) VALUE('0')
 /* T        CHGVAR     VAR(&IN11) VALUE('0')            */
 /* T        CHGVAR     VAR(&IN12) VALUE('0')            */
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&IN01 *EQ '1') GOTO END

/* TCHK3 S */ /* TCHK4 */
             IF        ((&PFLAG *NE ' ') *AND +
                        (&PFLAG *NE '1') *AND +
                        (&PFLAG *NE '2') *AND +
                        (&PFLAG *NE '3') *AND +
                        (&PFLAG *NE '4')) DO
             CHGVAR     VAR(&IN09) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INVALID PROCESS TYPE')
             GOTO       STP1
             ENDDO
/* TCHK3 E */
             IF         (&PFLAG *EQ ' ') DO
             IF         (&PSIRE *EQ '    ') DO
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT NO. SUPPLIER')
             GOTO       STP1
             ENDDO

             IF         (&PSIRK *EQ ' ') DO
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT NO. SUPPLIER')
             GOTO       STP1
             ENDDO
             ENDDO

             CHGVAR     VAR(&WNOHZ) VALUE(&PNOHZ)
             IF         (%SUBSTRING(&WNOHZ 1 4) *LT '2000') GOTO STP2
             IF         (%SUBSTRING(&WNOHZ 5 2) *GT '12') GOTO STP2
             IF         (%SUBSTRING(&WNOHZ 5 2) *LT '01') GOTO STP2
             IF         (%SUBSTRING(&WNOHZ 7 2) *GT '31') GOTO STP2
             IF         (%SUBSTRING(&WNOHZ 7 2) *LT '01') GOTO STP2
             GOTO       STP3

 STP2:       CHGVAR     VAR(&IN04) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) +
                          VALUE('DATE (YYMMDD) IS NOT RIGHT')
             GOTO       STP1

 STP3:       IF         (&PNOBI *EQ 0) DO
             CHGVAR     VAR(&IN07) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT NO. BIN')
             GOTO       STP1
             ENDDO

 STP7:
             CHGVAR     VAR(&WREDT) VALUE(&PREDT)
             IF         (%SUBSTRING(&WREDT 1 4) *LT '2000') GOTO STP4
             IF         (%SUBSTRING(&WREDT 5 2) *GT '12') GOTO STP4
             IF         (%SUBSTRING(&WREDT 5 2) *LT '01') GOTO STP4
             IF         (%SUBSTRING(&WREDT 7 2) *GT '31') GOTO STP4
             IF         (%SUBSTRING(&WREDT 7 2) *LT '01') GOTO STP4
             GOTO       STP5

 STP4:       CHGVAR     VAR(&IN06) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) +
                          VALUE('DATE (YYMMDD) IS NOT RIGHT')
             GOTO       STP1

 STP5:
 /* T        IF         (&PPS# *EQ 0) DO                           */
 /* T        CHGVAR     VAR(&IN11) VALUE('1')                      */
 /* T        CHGVAR     VAR(&IN99) VALUE('1')                      */
 /* T        CHGVAR     VAR(&MSG) VALUE('INPUT NO. PACKING SLIP#') */
 /* T        GOTO       STP1                                       */
 /* T        ENDDO                                                 */

 /* T        IF         (&PMANI *EQ '           ') DO                */
 /* T        CHGVAR     VAR(&IN12) VALUE('1')                        */
 /* T        CHGVAR     VAR(&IN99) VALUE('1')                        */
 /* T        CHGVAR     VAR(&MSG) VALUE('INPUT NO. BILL OF LODING#') */
 /* T        GOTO       STP1                                         */
 /* T        ENDDO                                                   */

             IF         (&IN05 *EQ '0') GOTO STP1

             IF         (&PFLAG  *EQ ' ') DO
             GOTO SKIP1
             ENDDO

/* TCHK3     IF         (&PFLAG  *EQ '1') DO */
/* TCHK3 */  IF         (&PFLAG  *GE '1') DO
             CHGVAR     VAR(&PSIREX) VALUE('0000')
             CHGVAR     VAR(&PDOCKX) VALUE('    ')
             CHGVAR     VAR(&PEND)   VALUE(' ')
             ENDDO
 LOOP:
             CHGJOB     SWS(00000000)

/* TCHK2     CALL       PGM(AB#RFK) PARM(&PSIREX &PDOCKX &PEND) */
/* TCHK2 */  CALL       PGM(AB#RFK) PARM(&PSIREX &PDOCKX &PEND &PFLAG)
             CHGVAR     VAR(&PSIRE)  VALUE(&PSIREX)
             CHGVAR     VAR(&PDOCK)  VALUE(&PDOCKX)
             CHGVAR     VAR(&PSIRK) VALUE('0')

             IF         (&PEND   *EQ '1') DO
             GOTO END
             ENDDO

 SKIP1:

             CALL       PGM(AB#RF81) PARM(&PSIRE &PDOCK &PNOHZ &PNOBI +
                          &PREDT)
/* T                      &PREDT &PPS# &PMANI)           */

/* TCHK3     IF         (&PFLAG  *NE '1') DO */
/* TCHK3 */  IF         (&PFLAG  *EQ ' ') DO
             GOTO END
             ENDDO

             GOTO LOOP

 END:
             DLTOVR     FILE(*ALL)
             ENDPGM
