             PGM
             /** AB#C38 ****************************************************/
             /*  ..RECORDING OF EDI FRS SALES & EDI(810) INVOICE DATA      */
             /*  ..ISSURANCE OF CANADA CUSTOM SHEET                        */
             /*    I-HASADA                             97.06.26           */
             /*    N-HYOTO  00.02.18 HOLD THE LIST                         */
             /*    N-HYOTO  00.09.22 ADD TMMWV                             */
             /*    N-HYOTO  01.06.19 CHANGE DEFULT WEIGHT                  */
             /*                      NOT RETRN TO MAIN MENU,STAY THIS MENU */
             /*    ADD AWNC 01.07.27                                       */
             /*    REMOVE UPDATE PGM 01.08.14                              */
             /*    A-INOUE  02.01.31 AB#R33 LIST RPG DELETE                */
             /*    H-AMANO  02.03.11 ADD BARCODE                           */
             /*    H-AMANO  02.05.15 ADD SHPPING TIME                      */
             /*    H-AMANO  02.09.23 CHANGE BIN 1 -> 2                     */
             /************************************************** AB#C38 ****/
             DCLF       FILE(AB#PW38)
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
             DCL        VAR(&RLDT)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&FLAG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FID) TYPE(*CHAR) LEN(1)
             DCL        VAR(&STM) TYPE(*CHAR) LEN(4)
             DCL        VAR(&TIM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&BIN) TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WSID) USER(&USER)
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&TIM)
             CHGJOB     SWS(00000000)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHKOBJ     OBJ(&WLIB/AB#C38ACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STPA))

 STPB:       SNDPGMMSG  MSG('( G ) FOR OCCUPIED BY OTHER TERMINAL, +
                          PLEASE TRY LATER, PLEASE RESPONSE BY "G" +
                          AND FINISH USING THIS TERMINAL') +
                          TOMSGQ(&WSID) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *NE 'G') *AND (&KOTAE *NE 'g')) +
                          THEN(GOTO CMDLBL(STPB))
             GOTO       END

 STPA:       CRTDTAARA  DTAARA(&WLIB/AB#C38ACT) TYPE(*CHAR) LEN(10) +
                          TEXT('EDI(810) INVOICE DATA &CANADA +
                          CUSTOM SHEET REISSUR') AUT(*ALL)

             CHGVAR     VAR(&PWEIG) VALUE(1.07)

  STP0:
             CRTDUPOBJ  OBJ(AB#WP76) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/AB#WP76
             OVRDBF     FILE(AB#WP76) TOFILE(QTEMP/AB#WP76)

             CHGVAR     VAR(&FLAG) VALUE(' ')
             CALL       PGM(AB#R3W) PARM(&PSIRE &PSIRK &PNOHZ &PNOBN +
                          &PWEIG &PTRCK &FLAG &STM &PSCAC &PTRAN)

             CHGVAR     VAR(&FID) VALUE('0')

             IF         COND(&FLAG *EQ '9') THEN(GOTO CMDLBL(END))
             IF         COND(&FLAG *EQ '1') THEN(GOTO CMDLBL(SKP1))
             IF         COND(&FLAG *EQ '2') THEN(GOTO CMDLBL(JUMP))

             CHGVAR     VAR(&STM) VALUE(%SST(&TIM 1 4))
 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(AB#PW381)

             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN03) VALUE('0')
             CHGVAR     VAR(&IN04) VALUE('0')
             CHGVAR     VAR(&IN06) VALUE('0')
             CHGVAR     VAR(&IN07) VALUE('0')
             CHGVAR     VAR(&IN08) VALUE('0')
             CHGVAR     VAR(&IN09) VALUE('0')
             CHGVAR     VAR(&IN10) VALUE('0')
             CHGVAR     VAR(&IN11) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')
             CHGVAR     VAR(&FID) VALUE('1')


             IF         (&IN01 *EQ '1') GOTO END
             IF         (&IN12 *EQ '1') GOTO STP0

             IF         (&PSIRE *EQ '    ') DO
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT DELIVERY CODE')
             GOTO       STP1
             ENDDO

             IF         (&PSIRK *EQ ' ') DO
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT DELIVERY CODE')
             GOTO       STP1
             ENDDO

             IF         (&STM *EQ '   ') DO
             CHGVAR     VAR(&IN09) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT SHIP TIME')
             GOTO       STP1
             ENDDO

             IF         (%SUBSTRING(&PNOHZ 1 4) *LT '1997') GOTO STP2
             IF         (%SUBSTRING(&PNOHZ 5 2) *GT '12') GOTO STP2
             IF         (%SUBSTRING(&PNOHZ 5 2) *LT '01') GOTO STP2
             IF         (%SUBSTRING(&PNOHZ 7 2) *GT '31') GOTO STP2
             IF         (%SUBSTRING(&PNOHZ 7 2) *LT '01') GOTO STP2
             GOTO       STP3
 STP2:       CHGVAR     VAR(&IN04) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) +
                          VALUE('DATE (YYMMDD) IS NOT RIGHT')
             GOTO       STP1

 STP3:       IF         COND(&PSIRE *EQ '3347' *OR &PSIRE *EQ +
                          '3348') THEN(DO)
             IF         (&PNOBN *EQ 0 ) DO
             CHGVAR     VAR(&IN07) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT BIN')
             GOTO       STP1
             ENDDO
             ENDDO

 STP5:
             IF         (&PWEIG *EQ 0) DO
             CHGVAR     VAR(&IN06) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT CONTAINER WEIGHT')
             GOTO       STP1
             ENDDO

             IF         (&PRISU *EQ ' ') DO
             IF         ((&PSIRE *EQ '3347') *OR +
                         (&PSIRE *EQ '3948') *OR +
                         (&PSIRE *EQ '3931') *OR +
                         (&PSIRE *EQ '3932') *OR +
                         (&PSIRE *EQ '0492') *OR +
                         (&PSIRE *EQ '3765') *OR +
                        (&PSIRE *EQ '4126')) DO
             IF         (&PTRCK *EQ '          ') DO
             CHGVAR     VAR(&IN08) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT TRUCK#.')
             GOTO       STP1
             ENDDO
             ENDDO
             ENDDO

             IF         COND((&PNOBN *LT 0) *OR (&PNOBN *GT 99)) +
                          THEN(DO)
             CHGVAR     VAR(&IN07) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT BIN FROM 1 TO 99')
             GOTO       STP1
             ENDDO
  /*  TISA */
             IF         COND(&PSIRE *EQ '0701' *OR &PSIRE *EQ '3556' +
                          *OR &PSIRE *EQ '3550') THEN(DO)
             IF         (&PSCAC *EQ ' ') DO
             CHGVAR     VAR(&IN10) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT SCAC CODE')
             GOTO       STP1
             ENDDO
             IF         COND(&PTRAN *LT '1' *OR &PTRAN *GT '5') +
                          THEN(DO)
             CHGVAR     VAR(&IN11) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('TRANSPORTATION METHOD ERROR')
             GOTO       STP1
             ENDDO
             ENDDO

             IF         (&IN05 *EQ '0') GOTO STP1

             IF         COND(&PRISU *EQ '1') THEN(GOTO CMDLBL(JUMP))
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
             CALL       PGM(AB#R32) PARM(&PSIRE &PSIRK &PNOHZ &PNOBN +
                          &RLDT)

             IF         (%SWITCH(0XXXXXXX)) DO
 STP6:       SNDPGMMSG  MSG('( G ) THERE IS NO DATA CORRESPONDS TO +
                          FRS.  < G-ENTER >') TOMSGQ(&WSID) +
                          MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)

             IF         COND(&FID *EQ '1') THEN(DO)
             IF         COND((&KOTAE = 'G') *OR (&KOTAE = 'g')) +
                          THEN(GOTO CMDLBL(STP1))
             ENDDO

             IF         COND(&FID *EQ '0') THEN(DO)
             IF         COND((&KOTAE = 'G') *OR (&KOTAE = 'g')) +
                          THEN(GOTO CMDLBL(STP0))
             ENDDO

             GOTO       STP6
             ENDDO

        /*   IF         (%SWITCH(X0XXXXXX)) DO   */
 STP7:  /*   SNDPGMMSG  MSG('( G ) SALES HAVE BEEN RECORDED FOR +
                          FRS.  < G-ENTER >') TOMSGQ(&WSID) +
                          MSGTYPE(*INQ) KEYVAR(&MBAN)  */
      /*     RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)  */
        /*   IF         COND((&KOTAE = 'G') *OR (&KOTAE = 'g')) +
                          THEN(GOTO CMDLBL(STP1))   */
       /*    GOTO       STP7                    */
       /*    ENDDO  */

/* SKP1:  */
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          HOLD(*YES) IGCDTA(&PIGCD)

             OVRDBF     FILE(AB#WP32) TOFILE(QTEMP/AB#WP32)
        /*   CALL       PGM(AB#R33) PARM(&PSIRE &PNOHZ) */

             CALL       PGM(AB#R34)

             OVRDBF     FILE(AB#WP33) TOFILE(QTEMP/AB#WP33)
             OVRDBF     FILE(MITANKF) TOFILE(QTEMP/MITANKF)
             CHGVAR     VAR(&PFLG) VALUE(' ')

             CALL       PGM(AB#R35) PARM(&PFLG)

 /* UNIT PRICE ERROR */
   /* UPDATE FILES  */
             CALL       PGM(AB#R3X) PARM(&USER &PNOHZ &PNOBN &PTRCK)
 JUMP:
/* TMMC */
             IF         COND(&PSIRE *EQ '3503' *OR &PSIRE *EQ +
                          '3504') THEN(DO)
             CLRPFM     FILE(EDI810TC)
             ENDDO

/* MAP */
             IF         (&PSIRE *EQ '4126') DO
             CLRPFM     FILE(EDI856HM)
             ENDDO

/* TMMK */
             IF         COND(&PSIRE *EQ '3347' *OR &PSIRE *EQ +
                          '3348') THEN(DO)
             CLRPFM     FILE(EDI856TK)
             ENDDO

/* TAKATA (MAIN OFFICE)*/
             IF         COND(&PSIRE *EQ '3656') THEN(DO)
             CLRPFM     FILE(EDI856TT)
             ENDDO

/* TAKATA (MEXICO)*/
             IF         COND(&PSIRE *EQ '3712') THEN(DO)
             CLRPFM     FILE(EDI856TX)
             ENDDO

/* TMMWV */
             IF         COND(&PSIRE *EQ '3931' *OR &PSIRE *EQ +
                          '3932') THEN(DO)
             CLRPFM     FILE(EDI856WV)
             ENDDO
/* TMMI */
             IF         COND(&PSIRE *EQ '3804' *OR &PSIRE *EQ +
                          '3805') THEN(DO)
             CLRPFM     FILE(EDI856TI)
             ENDDO

/* AWNC */
             IF         (&PSIRE *EQ '0492') DO
             CLRPFM     FILE(EDI856AW)
             ENDDO
/* NUMMI */
             IF         COND(&PSIRE *EQ '0541' *OR &PSIRE *EQ +
                          '0542') THEN(DO)
             CLRPFM     FILE(EDI810TN)
             ENDDO
/* SIA,DMAX */
             IF         COND((&PSIRE *EQ '0437') *OR +
                             (&PSIRE *EQ '0590')) THEN(DO)
             CLRPFM     FILE(EDI856IS)
             ENDDO
/* TISA     */
             IF         COND(&PSIRE *EQ '0701') THEN(DO)
             CLRPFM     FILE(EDI856TS)
             ENDDO
/* TOYOTETSU*/
             IF         COND(&PSIRE *EQ '3556' *OR &PSIRE *EQ +
                          '3550') THEN(DO)
             CLRPFM     FILE(EDI856TY)
             ENDDO
/* TMMAL */
             IF         COND(&PSIRE *EQ '3765') THEN(DO)
             CLRPFM     FILE(EDI856TA)
             ENDDO

             CHGVAR     VAR(&BIN) VALUE(&PNOBN)

             CALL       PGM(AB#C39) PARM(&PSIRE &PSIRK &PNOHZ &PWEIG +
                          &BIN &STM &PSCAC &PTRAN)

             DLTOVR     FILE(*ALL)
             CHGVAR     VAR(&PSIRE) VALUE('    ')
             CHGVAR     VAR(&PSIRK) VALUE(' ')
             CHGVAR     VAR(&PNOHZ) VALUE('        ')
             CHGVAR     VAR(&PNOBN) VALUE(0)
             CHGVAR     VAR(&PTRCK) VALUE('          ')
             CHGVAR     VAR(&PRISU) VALUE(' ')
             CHGVAR     VAR(&PSCAC) VALUE('    ')
             CHGVAR     VAR(&PTRAN) VALUE('    ')

             IF         COND(&FID *EQ '1') THEN(GOTO CMDLBL(STP1))

             IF         COND(&FID *EQ '0') THEN(GOTO CMDLBL(STP0))

 END:        DLTDTAARA  DTAARA(&WLIB/AB#C38ACT)

             ENDPGM
