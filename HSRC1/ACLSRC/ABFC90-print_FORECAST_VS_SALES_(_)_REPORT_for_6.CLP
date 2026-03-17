             PGM
             /** ABFC90 ****************************************/
             /*  PRINT FORECAST VS SALES (%) REPORT            */
             /*  BY 6 MONTHS                                   */
             /*  JW     2018.08.01                             */
             /**************************************************/

             DCLF       FILE(ABFPW90)
             DCL        VAR(&WSID)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD)    TYPE(*CHAR) LEN(4)
             DCL        VAR(&PRT)      TYPE(*CHAR) LEN(7)
             DCL        VAR(&WLIB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&QDATE)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&XDATE8)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&TRUE  )   TYPE(*CHAR) LEN(8)
             DCL        VAR(&RTN1  )   TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTN2  )   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRNT  )   TYPE(*CHAR) LEN(1)

             DCL        VAR(&SI25  )   TYPE(*CHAR) LEN(1)
             DCL        VAR(&MO25  )   TYPE(*CHAR) LEN(2)
             DCL        VAR(&RT25  )   TYPE(*CHAR) LEN(1)

/* TARGET DATE */
             DCL        VAR(&TG_3  )   TYPE(*CHAR) LEN(6)
             DCL        VAR(&TG_2  )   TYPE(*CHAR) LEN(6)
             DCL        VAR(&TG_1  )   TYPE(*CHAR) LEN(6)
             DCL        VAR(&TG_0  )   TYPE(*CHAR) LEN(6)

/* CHECK OTHER USER IS USING  ======================================*/
             CALL       PGM(CHKC45) PARM('ABFC90' 'ABFC90' 'Y' 'CHK' &RTN1)
             IF         COND(&RTN1 *NE ' ') THEN(GOTO @ENDP)
/* =================================================================*/

             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

/* set DEFAULT DATE (TODAY)  */
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&QDATE)
             CHGVAR     VAR(&TG_0) VALUE('20' *CAT &QDATE)

             CHGVAR     VAR(&SI25) VALUE('-')
             CHGVAR     VAR(&MO25) VALUE('01')
             CALL UTLR25 (&TG_0 &SI25 &MO25 &TG_1 &RT25)
             CALL UTLR25 (&TG_1 &SI25 &MO25 &TG_2 &RT25)
             CALL UTLR25 (&TG_2 &SI25 &MO25 &TG_3 &RT25)

             CHGVAR     VAR(&XDATE ) VALUE(&TG_0)
@DSP00:
             SNDRCVF    RCDFMT(DSP01)
             CHGVAR     VAR(&XMSG) VALUE('   ')
             CHGVAR     VAR(&IN63) VALUE('0')

       /* F1: EXIT  */
             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(@ENDP1))

       /* CHECK DATE  */
             CHGVAR     VAR(&XDATE8) VALUE(&XDATE *CAT '01')
             CALL       PGM(UTLC01) PARM(&XDATE8 &TRUE &RTN2)

             IF         COND(&RTN2 *NE ' ') THEN(DO)
             CHGVAR     VAR(&IN63) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('Date is invalid!')
             GOTO @DSP00
             ENDDO

       /* F5: RUN  */
             IF         COND(&IN05 *EQ '0') THEN(DO)
             CHGVAR     VAR(&XMSG) VALUE('Date is valid. Press F5 to +
                          Run...')
             GOTO       CMDLBL(@DSP00)
             ENDDO

/* ---------------------------------------------------- */

                 CLRPFM     FILE(*LIBL/ABFWP81S)
                 CLRPFM     FILE(*LIBL/ABFWP82S)
                 CHGVAR     VAR(&PRNT) VALUE('N')

/* STEP1. FC(N-3) */
     CALL PGM(ABFC81) PARM(&TG_3 &PRNT)
     CPYF FROMFILE(ABFWP82) TOFILE(ABFWP82S) MBROPT(*ADD) FMTOPT(*MAP *DROP)

  /* CPYF FROMFILE(ABFWP81) TOFILE(ABFWP81S) MBROPT(*ADD) FMTOPT(*MAP *DROP) */

/* STEP2. FC(N-2) */
     CALL PGM(ABFC81) PARM(&TG_2 &PRNT)
     CPYF FROMFILE(ABFWP82) TOFILE(ABFWP82S) MBROPT(*ADD) FMTOPT(*MAP *DROP)

  /* CPYF FROMFILE(ABFWP81) TOFILE(ABFWP81S) MBROPT(*ADD) FMTOPT(*MAP *DROP) */

/* STEP3. FC(N-1) */
     CALL PGM(ABFC81) PARM(&TG_1 &PRNT)
     CPYF FROMFILE(ABFWP82) TOFILE(ABFWP82S) MBROPT(*ADD) FMTOPT(*MAP *DROP)

  /* CPYF FROMFILE(ABFWP81) TOFILE(ABFWP81S) MBROPT(*ADD) FMTOPT(*MAP *DROP)*/

/* STEP4. FC(N-0) */
     CALL PGM(ABFC91) PARM(&TG_0 &PRNT)
     CPYF FROMFILE(ABFWP82) TOFILE(ABFWP82S) MBROPT(*ADD) FMTOPT(*MAP *DROP)

  /* CPYF FROMFILE(ABFWP81) TOFILE(ABFWP81S) MBROPT(*ADD) FMTOPT(*MAP *DROP)*/

/* PRINT ==DAY== */
 /* PRINT   */
             RTVJOBA    USER(&USER)
             IF         COND(&USER *NE 'I0777') THEN(DO)
             OVRPRTF    FILE(QPRINT) OUTQ(LANPRT03)
             ENDDO

             CALL       PGM(ABFR96) PARM(&TG_0)

@ENDP1:
             CALL       PGM(CHKC45) PARM('ABFC90' 'ABFC90' 'N' '' '')
@ENDP:
             ENDPGM
