             PGM
             /********************************/
             /* REV. KANBAN ISSUE DATA GEN.  */
             /*                              */
             /*   B#AC21                     */
             /*                              */
             /*   H.ITO                      */
             /*                              */
             /*   1993.07.26                 */
             /*   2003.04.21  TCH            */
             /*   2004.02.23  TCH            */
             /*   2004.11.16  TCH            */
             /*   2006.01.09  TCHK1          */
             /*   2006.08.26  TCHK2          */
             /*   2011.10.18  TCHK3          */
             /********************************/
             DCLF       FILE(B#APW21)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CANFLG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SYORI) TYPE(*CHAR) LEN(1)
             DCL        VAR(&I1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SW1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FIL1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FIL2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FIL3) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FIL4) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FIL5) TYPE(*CHAR) LEN(8)

             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)

             CHGJOB     SWS(00000000)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

 @SCR0:      CHGVAR     VAR(&@SHORI) VALUE(' ')
             CHGVAR     VAR(&I1)     VALUE(' ')
             CHGVAR     VAR(&SW1) VALUE(' ')

 @SCR1:      SNDRCVF    DEV(&WSID) RCDFMT(B#APW211)
             CHGVAR     VAR(&CANFLG) VALUE(' ')

             DLTF       FILE(&WLIB/AANWP20)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AANWP20) RCDLEN(512) +
                           OPTION(*NOSRC *NOLIST) LVLCHK(*NO) +
                              AUT(*ALL)

 @SCR2:      IF         (&IN01 *EQ '1') DO
             IF         COND(%SWITCH(00000000)) THEN(DO)
             GOTO       @END
             ENDDO
             GOTO       SHORI
             ENDDO

             CHGVAR     VAR(&IN33) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')
             CHGVAR     VAR(&@ERR) +
                          VALUE('                                     -
   ')

             IF         (&@SHORI *EQ '1') GOTO @001
             IF         (&@SHORI *EQ '2') GOTO @001
/* %0001 */  IF         (&@SHORI *EQ '3') GOTO @001

             IF         COND(&@SHORI *EQ '4') THEN(DO)
     /*      CALL       PGM(AKBC14)  */
             CALL       PGM(AKBC16)
             CHGVAR     VAR(&@SHORI) VALUE(' ')
             GOTO       @SCR1
             ENDDO

             IF         COND(&@SHORI *EQ '5') THEN(DO)
             CALL       PGM(AKBC15)
             CHGVAR     VAR(&@SHORI) VALUE(' ')
             GOTO       @SCR1
             ENDDO
   /* WASHER RETRIEVAL */
             IF         COND(&@SHORI *EQ '6') THEN(DO)
             CALL       PGM(AKBC25)
             GOTO       @END
             ENDDO

/* TCHK1 S */
   /* ROLLING WASHER LOW-VOLUME LOCATION */
             IF         COND(&@SHORI *EQ '7') THEN(DO)
             CALL       PGM(AKBR26)
             CHGVAR     VAR(&@SHORI) VALUE(' ')
             GOTO       @SCR1
             ENDDO
/* TCHK1 E */
/* TCHK2 S */
   /* WASHER TEMPORARY KANBAN            */
             IF         COND(&@SHORI *EQ '8') THEN(DO)
             CALL       PGM(AKBC17)
             CHGVAR     VAR(&@SHORI) VALUE(' ')
             GOTO       @SCR1
             ENDDO
   /* PLATING RETRIEVAL KANBAN */
             IF         COND(&@SHORI *EQ '9') THEN(DO)
             CALL       PGM(ABHC26)
             CHGVAR     VAR(&@SHORI) VALUE(' ')
             GOTO       @SCR1
             ENDDO
/* TCHK2 E */

             CHGVAR     VAR(&IN33) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&@ERR) VALUE('===> WRONG CHOICE NO. +
                          ENTERD')
             GOTO       @SCR1

 @001:       IF     (&@SHORI *EQ '1')  GOTO MEKI  /* ﾒｯｷ  */
             IF     (&@SHORI *EQ '2')  GOTO YAKI  /* ﾔｷｲﾚ */
/* %0001 */  IF     (&@SHORI *EQ '3')  GOTO HANSEI /* ﾊﾝｾｲ   */


         /*  ﾒｯｷ  */
 MEKI:       IF         (%SWITCH(00XXXXXX)) DO
             DLTF       FILE(DATA1)
             MONMSG     MSGID(CPF3261 CPF2105)
             ENDDO

             CALL       PGM(AAFR13) PARM('AAFT0111' 'C')

             IF         (%SWITCH(XXXXXXX1)) DO
             CHGVAR     VAR(&IN33) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&@ERR) VALUE('DATA OF LAST TIME HAD NOT +
                          PROCESSED BY COMMUNICATION')
             GOTO       @SCR1
             ENDDO

             CALL       PGM(AAFR13) PARM('AAFT0111' 'H')

             CRTPF      FILE(&WLIB/DATA1) RCDLEN(1024) +
                          OPTION(*NOLIST) SIZE(1000) LVLCHK(*NO) +
                          AUT(*ALL)
             MONMSG     MSGID(CPF5813 CPF7302)

             CHGVAR     VAR(&SYORI) VALUE('C')
             CHGVAR     VAR(&CANFLG) VALUE(' ')
             CALL       PGM(B#AR24) PARM(&SYORI  &CANFLG &I1)

             IF         (&CANFLG *EQ '3')  DO
             CALL       PGM(AAFR13) PARM('AAFT0111' 'D')
             GOTO       @SCR0
             ENDDO

             IF         (%SWITCH(00XXXXXX)) DO
             DLTF       FILE(DATA1)
             CALL       PGM(AAFR13) PARM('AAFT0111' 'D')
             ENDDO

             IF         (&I1  *EQ '1')   DO
             CHGVAR     VAR(&IN01) VALUE('1')
             GOTO       @SCR2
             ENDDO

             GOTO       @SCR0

         /*  ﾔｷｲﾚ  */
 YAKI:       IF         (%SWITCH(00XXXXXX)) DO
             CHGVAR     VAR(&FIL1) VALUE('AAEWP' *CAT '0111' *CAT '1')
             DLTF       FILE(&FIL1)
             MONMSG     MSGID(CPF3261 CPF2105)
             ENDDO

             CALL       PGM(ADHR10) PARM('AAET0111' 'C')

             IF         (%SWITCH(XXXXXXX1)) DO
             CHGVAR     VAR(&IN33) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&@ERR) VALUE('DATA OF LAST TIME HAD NOT +
                          PROCESSED BY COMMUNICATION')
             GOTO       @SCR1
             ENDDO

             CALL       PGM(ADHR10) PARM('AAET0111' 'H')

             CRTPF      FILE(&WLIB/&FIL1) RCDLEN(1024) +
                          OPTION(*NOLIST) SIZE(3000 1000 2) +
                          LVLCHK(*NO) AUT(*ALL)

             CHGVAR     VAR(&SYORI) VALUE('B')
             CHGVAR     VAR(&CANFLG) VALUE(' ')

             OVRDBF     FILE(DATA2) TOFILE(&FIL1)
             CALL       PGM(B#AR24) PARM(&SYORI  &CANFLG &I1)

             IF         (&CANFLG *EQ '3')  DO
             CALL       PGM(ADHR10) PARM('AAET0111' 'D')
             GOTO       @SCR0
             ENDDO

             IF         (%SWITCH(00XXXXXX)) DO
             DLTF       FILE(&FIL1)
             CALL       PGM(ADHR10) PARM('AAET0111' 'D')
             ENDDO

             IF         (&I1  *EQ '1')   DO
             CHGVAR     VAR(&IN01) VALUE('1')
             GOTO       @SCR2
             ENDDO

             GOTO       @SCR0

HANSEI:
             CHKOBJ     OBJ(AANC10ACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(H_STP2))

 H_STP1:
             CHGVAR     VAR(&IN33) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&@ERR) VALUE('THIS PROCESSING IS BEING +
                          PROCESSED WITH OTHER COMPUTERS.')
             GOTO       @SCR1

 H_STP2:
             CRTDTAARA  DTAARA(&WLIB/AANC10ACT) TYPE(*CHAR) LEN(1) +
                          AUT(*ALL)

/* TCHK2 */  CLRPFM     FILE(&WLIB/AANWP21)

             OVRDBF     FILE(OUTPUT6) TOFILE(AANWP20)
             CHGVAR     VAR(&SYORI) VALUE('6')
             CHGVAR     VAR(&CANFLG) VALUE(' ')
             CALL       PGM(B#AR23) PARM(&SYORI  &CANFLG &I1)
             DLTOVR     *ALL

             DLTDTAARA  DTAARA(&WLIB/AANC10ACT)

             IF         (&I1  *EQ '1')   DO
             CHGVAR     VAR(&IN01) VALUE('1')
             GOTO       @SCR2
             ENDDO


             GOTO       @SCR0


         /*  xｮg  */
SHORI:       IF         (%SWITCH(1100XXXX)) DO

             DLTF       FILE(AAFWP11)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AAFWP11) RCDLEN(1024) +
                          OPTION(*NOLIST) SIZE(2000 1000 2) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(AAFWP12)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AAFWP12) RCDLEN(1024) +
                          OPTION(*NOLIST) SIZE(2000 1000 2) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(AAFT0111)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AAFT0111) RCDLEN(1024) +
                          OPTION(*NOLIST) SIZE(2000 1000 2) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((&WLIB/DATA1)) +
                          OUTFILE(&WLIB/AAFWP11) SRCFILE(FMTSRC) +
                          SRCMBR(AAFS10) OPTION(*NOPRT)

             OVRDBF     FILE(OUTPUT1) TOFILE(AAFWP11)
             OVRDBF     FILE(OUTPUT2) TOFILE(AAFWP12)
             CALL       PGM(AAFR80)
             DLTOVR     FILE(OUTPUT1)
             DLTOVR     FILE(OUTPUT2)

             OVRDBF     FILE(OUTPUT1) TOFILE(AAFWP12)
             OVRDBF     FILE(OUTPUT2) TOFILE(AAFT0111)
             CALL       PGM(AAFR81)
             DLTOVR     FILE(OUTPUT1)
             DLTOVR     FILE(OUTPUT2)

             CALL       PGM(AAFR13) PARM('AAFT0111' ' ')

             DLTF       FILE(AAFWP11)
             DLTF       FILE(DATA1)
             ENDDO

         /*  ﾔｷｲﾚ  */
             IF         (%SWITCH(1010XXXX)) DO
             CHGVAR     VAR(&FIL2) VALUE('AAEWP' *CAT '0111' *CAT '2')
             CHGVAR     VAR(&FIL3) VALUE('AAEWP' *CAT '0111')
             CHGVAR     VAR(&FIL4) VALUE('AAEWP' *CAT '0111' *CAT '3')
             CHGVAR     VAR(&FIL5) VALUE('AAET' *CAT '0111')

             DLTF       FILE(&FIL2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FIL2) RCDLEN(1024) +
                          OPTION(*NOLIST) SIZE(3000 1000 2) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((&WLIB/&FIL1)) +
                          OUTFILE(&WLIB/&FIL2) SRCFILE(FMTSRC) +
                          SRCMBR(AAES12) OPTION(*NOPRT)
             DLTF       FILE(&FIL1)

             DLTF       FILE(&FIL3)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FIL3) RCDLEN(1024) +
                          OPTION(*NOLIST) SIZE(3000 1000 2) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&FIL4)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FIL4) RCDLEN(1024) +
                          OPTION(*NOLIST) SIZE(3000 1000 2) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(OUTPUT1) TOFILE(&FIL2)
             OVRDBF     FILE(OUTPUT2) TOFILE(&FIL3)
             OVRDBF     FILE(OUTPUT3) TOFILE(&FIL4)
             CALL       PGM(ADHR12) PARM(' ' ' ' '0111' '      ')
             DLTF       FILE(&FIL2)
             DLTOVR     FILE(OUTPUT1)
             DLTOVR     FILE(OUTPUT2)
             DLTOVR     FILE(OUTPUT3)

             DLTF       FILE(&FIL5)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FIL5) RCDLEN(1024) +
                          OPTION(*NOLIST) SIZE(3000 1000 2) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(OUTPUT1) TOFILE(&FIL4)
             OVRDBF     FILE(OUTPUT2) TOFILE(&FIL5)
             CALL       PGM(ADHR13)
             CALL       PGM(ADHR10) PARM(&FIL5 ' ')
             DLTF       FILE(&FIL3)
        /*   DLTF       FILE(&FIL4)   */
             DLTOVR     FILE(OUTPUT1)
             DLTOVR     FILE(OUTPUT2)
             ENDDO

 @END:       CHGJOB     OUTQ(&PRT)

             ENDPGM
