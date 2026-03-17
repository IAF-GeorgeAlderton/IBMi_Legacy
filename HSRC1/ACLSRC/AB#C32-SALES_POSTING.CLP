             PGM
             /** AB#C32 ****************************************************/
             /*  ..RECORDING OF EDI FRS SALES & EDI(810) INVOICE DATA      */
             /*  ..ISSURANCE OF CANADA CUSTOM SHEET                        */
             /*    I-HASADA                             97.06.26           */
             /*    N-HYOTO  00.02.18 HOLD THE LIST                         */
             /*    N-HYOTO  00.09.22 ADD TMMWV                             */
             /*    N-HYOTO  01.06.19 CHANGE DEFULT WEIGHT                  */
             /*                      NOT RETRN TO MAIN MENU,STAY THIS MENU */
             /*    ADD AWNC 01.07.27                                       */
             /*    01.08.14     ONLY POSTING SALES RESULT                  */
             /*    A-INOUE  02.02.31 AB#R33 LIST PGM DELETE                */
             /*    H-AMANO  02.03.20 ADD BARCODE CHECK                     */
             /*                                                            */
             /*    TCHK1 01/19/07 RMV MANUAL ENTRY PROCESS                 */
             /*    JW2   07/08/19 CHG ERROR MESSAGE                        */
             /************************************************** AB#C32 ****/
             DCLF       FILE(AB#PW32)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PFLG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&FDID)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&FLAG)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&WWID)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)

             DCL        VAR(&MSGTXT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&PKINP) TYPE(*CHAR) LEN(5)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)
             CHGJOB     SWS(00000000)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

 STP0:
             IF         (&WWID *EQ '1') GOTO STP1

             SNDRCVF    DEV(&WSID) RCDFMT(AB#PW320)

             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')
             CHGVAR     VAR(&MSG) VALUE('             ')

             IF         (&IN01 *EQ '1') GOTO END
/* TCHK1 */  IF         (&IN19 *EQ '1') GOTO STP1

             CHGVAR     VAR(&WWID) VALUE('0')

             CALL       PGM(AB#R3V) PARM(&D@BARC &PSIRE &PSIRK  +
                   &PNOHZ &PNOBN &D@DLDT &FLAG)
             IF         (&FLAG *EQ '9') DO
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('BARCODE ERROR')
             GOTO       STP0
             ENDDO

             IF         (&FLAG *EQ ' ') GOTO SKP1

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(AB#PW321)

             CHGVAR     VAR(&WWID) VALUE('1')
             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN03) VALUE('0')
             CHGVAR     VAR(&IN04) VALUE('0')
             CHGVAR     VAR(&IN09) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&IN01 *EQ '1') GOTO END
             IF         COND(&IN12 *EQ '1') THEN(DO)
             CHGVAR     VAR(&WWID) VALUE('0')
             GOTO       STP0
             ENDDO

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

             IF         (%SUBSTRING(&PNOHZ 1 4) *LT '1997') GOTO STP2
             IF         (%SUBSTRING(&PNOHZ 5 2) *GT '12') GOTO STP2
             IF         (%SUBSTRING(&PNOHZ 5 2) *LT '01') GOTO STP2
             IF         (%SUBSTRING(&PNOHZ 7 2) *GT '31') GOTO STP2
             IF         (%SUBSTRING(&PNOHZ 7 2) *LT '01') GOTO STP2
     /* FORD CHECK  */
             CALL       PGM(AB#RF0) PARM(&PSIRE &FDID)

             IF         COND(&FDID *EQ '1' *AND &D@DLDT *EQ '        +
                          ') THEN(DO)
             CHGVAR     VAR(&IN09) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT RELEASE DATE')
             GOTO       STP1
             ENDDO

             IF         COND(&FDID *EQ ' ' *AND &D@DLDT *NE '        +
                          ') THEN(DO)
             CHGVAR     VAR(&IN09) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('RELEASE DATE IS ONLY FOR FORD')
             GOTO       STP1
             ENDDO

             GOTO       STP5
 STP2:       CHGVAR     VAR(&IN04) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) +
                          VALUE('DATE (YYMMDD) IS NOT RIGHT')
             GOTO       STP1

 STP5:

             IF         (&IN05 *EQ '0') GOTO STP1

 SKP1:
  /* CREATE WORK FILES  */
             CRTDUPOBJ  OBJ(AB#WP32) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/AB#WP32

             CRTDUPOBJ  OBJ(AB#WP33) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/AB#WP33

             CRTDUPOBJ  OBJ(MITANKF) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/MITANKF

             OVRDBF     FILE(AB#WP32) TOFILE(QTEMP/AB#WP32)
             OVRDBF     FILE(AB#WP33) TOFILE(QTEMP/AB#WP33)
             OVRDBF     FILE(MITANKF) TOFILE(QTEMP/MITANKF)
             CALL       PGM(AB#R32) PARM(&PSIRE &PSIRK &PNOHZ &PNOBN +
                          &D@DLDT)

             IF         (%SWITCH(0XXXXXXX)) DO
 STP6:
             CHGVAR     VAR(&MSGTXT) VALUE('THERE IS NO DATA +
                          CORRESPONDS TO FRS.  < TYPE G AND PRESS ENTER >')
             CHGVAR     VAR(&PKINP) VALUE('Gg   ')

             CALL       PGM(APLR90) PARM(&MSGTXT &PKINP &WSID &KOTAE)

             IF         COND((&KOTAE = 'G') *OR (&KOTAE = 'g')) +
                          THEN(GOTO CMDLBL(STP0))

             SNDPGMMSG  MSG('THERE IS NO DATA CORRESPONDS TO +
                          FRS.  < TYPE G AND PRESS ENTER >') TOMSGQ(&WSID) +
                          MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE = 'G') *OR (&KOTAE = 'g')) +
                          THEN(GOTO CMDLBL(STP0))
     /*      GOTO       STP0  */
     /*jw1*/ GOTO       STP6
             ENDDO

             IF         (%SWITCH(X0XXXXXX)) DO
 STP7:
 /*JW2*/     CHGVAR     VAR(&MSGTXT) VALUE('SALES HAVE BEEN +
                          POSTED ALREADY.  < TYPE G  AND PRESS ENTER >')
             CHGVAR     VAR(&PKINP) VALUE('Gg   ')

             CALL       PGM(APLR90) PARM(&MSGTXT &PKINP &WSID &KOTAE)

             IF         COND((&KOTAE = 'G') *OR (&KOTAE = 'g')) +
                          THEN(GOTO CMDLBL(STP0))

             SNDPGMMSG  MSG('SALES HAVE BEEN POSTED ALREADY +
                          < TYPE G AND PRESS ENTRR >') TOMSGQ(&WSID) +
                          MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE = 'G') *OR (&KOTAE = 'g')) +
                          THEN(GOTO CMDLBL(STP0))

     /*jw1*/ GOTO       STP7
             ENDDO

             OVRDBF     FILE(AB#WP32) TOFILE(QTEMP/AB#WP32)

             CALL       PGM(AB#R3Y)

             CHGVAR     VAR(&PFLG) VALUE(' ')

             CALL       PGM(AB#R35) PARM(&PFLG)

             IF         (&PFLG *EQ '*') DO

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(LANPRT50) +
                          FORMTYPE(K6H1) HOLD(*YES) IGCDTA(&PIGCD)

             CALL       PGM(AB#R36) PARM(&PSIRE &PNOHZ)

             CRTDUPOBJ  OBJ(PRT132B) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/PRT132B

             CPYSPLF    FILE(QPRINT) TOFILE(QTEMP/PRT132B) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             MONMSG     MSGID(CPF3429)

             OVRDBF     FILE(PRT132) TOFILE(QTEMP/PRT132B)
             CALL       PGM(AB#RW0)

             SNDDST     TYPE(*FILE) TOINTNET((SalesGroup@iafi.com) +
                          (Production_Control@iafi.com *CC)) +
                          DSTD('Unit price not registered') MSG('** +
                          ERROR ** Some parts need pricing. Please +
                          check the attached report. (AB#C32).') +
                          DOCFILE(QTEMP/PRT132B) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD('POSTING ERROR MESSAGE')
             MONMSG     MSGID(CPF0000)

             DLTOVR     FILE(PRT132)

             ENDDO

             CALL       PGM(AB#R37) PARM(&USER &PNOHZ &PNOBN &D@DLDT)

             DLTOVR     FILE(*ALL)
             CHGVAR     VAR(&PSIRE) VALUE('    ')
             CHGVAR     VAR(&PSIRK) VALUE(' ')
             CHGVAR     VAR(&PNOHZ) VALUE('        ')
             CHGVAR     VAR(&PNOBN) VALUE(0)
             CHGVAR     VAR(&D@DLDT) VALUE('        ')
             CHGVAR     VAR(&D@BARC) VALUE('         ')

             IF         COND(&WWID *EQ '0') THEN(GOTO CMDLBL(STP0))
             IF         COND(&WWID *EQ '1') THEN(GOTO CMDLBL(STP1))

 END:        ENDPGM
