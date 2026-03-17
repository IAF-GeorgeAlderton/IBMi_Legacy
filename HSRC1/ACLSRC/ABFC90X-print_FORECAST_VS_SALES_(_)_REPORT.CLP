             PGM
             /** ABFC80 ****************************************/
             /*  PRINT FORECAST VS SALES (%) REPORT            */
             /*  JW     2018.07.06                             */
             /**************************************************/

             DCLF       FILE(ABFPW80)
             DCL        VAR(&WSID)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD)    TYPE(*CHAR) LEN(4)
             DCL        VAR(&PRT)      TYPE(*CHAR) LEN(7)
             DCL        VAR(&WLIB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&QDATE)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&XDATE0)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&XDATE8)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&TRUE  )   TYPE(*CHAR) LEN(8)
             DCL        VAR(&RTN   )   TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

/* set DEFAULT DATE (TODAY)  */
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&QDATE)
             CHGVAR     VAR(&XDATE0) VALUE('20' *CAT &QDATE)
             CHGVAR     VAR(&XDATE ) VALUE(&XDATE0)
@DSP00:
             SNDRCVF    DEV(&WSID) RCDFMT(DSP01)
             CHGVAR     VAR(&XMSG) VALUE('   ')
             CHGVAR     VAR(&IN63) VALUE('0')

       /* F1: EXIT  */
             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(END))

       /* CHECK DATE  */
             CHGVAR     VAR(&XDATE8) VALUE(&XDATE *CAT '01')
             CALL       PGM(UTLC01) PARM(&XDATE8 &TRUE &RTN)

             IF         COND(&RTN *NE ' ') THEN(DO)
             CHGVAR     VAR(&IN63) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('Date is invalid!')
             GOTO @DSP00
             ENDDO

      /*     IF         COND(&XDATE *GT &XDATE0) THEN(DO)                */
      /*     CHGVAR     VAR(&IN63) VALUE('1')                            */
      /*     CHGVAR     VAR(&XMSG) VALUE('Date should not be futue !')   */
      /*     GOTO @DSP00                                                 */
      /*     ENDDO                                                       */

       /* F5: RUN  */
             IF         COND(&IN05 *EQ '0') THEN(DO)
             CHGVAR     VAR(&XMSG) VALUE('Date is valid. Press F5 to +
                          Run...')
             GOTO       CMDLBL(@DSP00)
             ENDDO
/* PRINT   */
                 IF         COND(&USER *NE 'I0777') THEN(DO)
                 OVRPRTF    FILE(QPRINT) OUTQ(LANPRT03)
                 ENDDO

                 CLRPFM     FILE(*LIBL/ABFPP80)
                 CLRPFM     FILE(*LIBL/ABFPP81)
                 CLRPFM     FILE(*LIBL/ABFWP80)
                 CLRPFM     FILE(*LIBL/ABFWP81)
                 CLRPFM     FILE(*LIBL/ABFWP82)
/* MANUAL FC */
                    /** CALL       PGM(ABFR92) PARM(&XDATE) **/
/* FORD FC   */
                    /** CALL       PGM(ABFR91) PARM(&XDATE) **/
/* HONDA FC  */
                        CALL       PGM(ABFR90) PARM(&XDATE)
/* SUMMAIZE  */
                        CALL       PGM(ABFR93) PARM(&XDATE)
/* PRINT ==WEEK== */
                    /** CALL       PGM(ABFR94) PARM(&XDATE) **/
/* PRINT ==DAY== */
                        CALL       PGM(ABFR95) PARM(&XDATE)
END:
             ENDPGM
