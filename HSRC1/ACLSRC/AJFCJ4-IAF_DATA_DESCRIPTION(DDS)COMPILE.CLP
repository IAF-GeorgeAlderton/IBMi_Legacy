             PGM        PARM(&ASLIB &AOLIB &ASRC &AFILE &AKSN &ALIN +
                          &AR &APRT &ASIZ1 &ASIZ2 &ASIZ3 &ARECD +
                          &AER2 &AER3 &ATXT)
             /** AJFCJ4 ************************************/
             /*   IAF DATA DESCRIPTION(DDS)COMPILE.        */
             /*   JOBQ                                     */
             /* I-HASADA                     96.06.28      */
             /* JW1   2018.10.08 CHANGED FILE 7 TO 8A      */
             /* JW2   2020.12.14 CHG ALLOW FILE NAME WITH EP/EL  */
             /* JW    2022.07.29 ADD "AP" "AL"                   */
             /************************************ AJFCJ4 **/
             DCL        VAR(&ASLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&AOLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&ASRC) TYPE(*CHAR) LEN(8)

       /*JW1 DCL        VAR(&AFILE) TYPE(*CHAR) LEN(7) ***/
             DCL        VAR(&AFILE) TYPE(*CHAR) LEN(8)

             DCL        VAR(&WFILE) TYPE(*CHAR) LEN(9)
             DCL        VAR(&AKSN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ALIN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&AR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ATXT) TYPE(*CHAR) LEN(50)
             DCL        VAR(&APRT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ASIZ1) TYPE(*CHAR) LEN(6)
             DCL        VAR(&ASIZ2) TYPE(*CHAR) LEN(5)
             DCL        VAR(&ASIZ3) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ARECD) TYPE(*CHAR) LEN(3)
             DCL        VAR(&AER2) TYPE(*CHAR) LEN(1)
             DCL        VAR(&AER3) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WHLD) TYPE(*CHAR) LEN(4) VALUE('*YES')
             DCL        VAR(&WCHK) TYPE(*CHAR) LEN(4) VALUE('*YES')
             DCL        VAR(&WMIN) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WMAH) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WGY) TYPE(*CHAR) LEN(2) VALUE('66')
             DCL        VAR(&WOV) TYPE(*CHAR) LEN(2) VALUE('60')

             DCL        VAR(&ASLIB10) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ASRC10) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AFILE10) TYPE(*CHAR) LEN(10)

             DCL        VAR(&WKUBN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WFILE6) TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&ASLIB10) VALUE(&ASLIB)
             CHGVAR     VAR(&ASRC10)  VALUE(&ASRC)
             CHGVAR     VAR(&AFILE10)  VALUE(&AFILE)

             CHGVAR     VAR(&WKUBN) VALUE('O')
             IF         (%SST(&AFILE 4 2) *EQ 'PP') GOTO @OLD
             IF         (%SST(&AFILE 4 2) *EQ 'PL') GOTO @OLD
             IF         (%SST(&AFILE 4 2) *EQ 'TP') GOTO @OLD
             IF         (%SST(&AFILE 4 2) *EQ 'TL') GOTO @OLD
             IF         (%SST(&AFILE 4 2) *EQ 'WP') GOTO @OLD
             IF         (%SST(&AFILE 4 2) *EQ 'WL') GOTO @OLD
             IF         (%SST(&AFILE 4 2) *EQ 'NP') GOTO @OLD
             IF         (%SST(&AFILE 4 2) *EQ 'NL') GOTO @OLD
             IF         (%SST(&AFILE 4 2) *EQ 'PW') GOTO @OLD
             IF         (%SST(&AFILE 4 2) *EQ 'PR') GOTO @OLD
             CHGVAR     VAR(&WKUBN) VALUE('N')
             CHGVAR     VAR(&WFILE6) VALUE(%SST(&AFILE 6 1))
@OLD:
             ALCOBJ     OBJ((&ASLIB/&ASRC *FILE *SHRUPD &AFILE))
             MONMSG     MSGID(CPF0948 CPF1085) EXEC(DO)
             CHGVAR     VAR(&AER3) VALUE('E')
             GOTO       END
             ENDDO

             DLCOBJ     OBJ((&ASLIB/&ASRC *FILE *SHRUPD &AFILE))

             IF         (&AR *EQ 'R') DO
             CHGVAR     VAR(&WHLD) VALUE('*NO ')
             ENDDO

             IF         COND(&WKUBN *EQ 'O') THEN(GOTO CMDLBL(@OLD2))

             CHGVAR     VAR(&WMIN) VALUE('*IMMED')
@OLD2:
             /*--------------*/
             /*  ..LVLCHK..  */
             /*--------------*/
             IF         (%SST(&AFILE 4 1) *EQ 'P') DO
             CHGVAR     VAR(&WMIN) VALUE('*IMMED')
             ENDDO
/* JW */
             IF         (%SST(&AFILE 4 1) *EQ 'A') DO
             CHGVAR     VAR(&WMIN) VALUE('*IMMED')
             ENDDO

             IF         (%SST(&AFILE 4 1) *EQ 'T') DO
             CHGVAR     VAR(&WMIN) VALUE('*DLY  ')
             ENDDO

             IF         (%SST(&AFILE 4 1) *EQ 'W') DO
             CHGVAR     VAR(&WMIN) VALUE('*IMMED')
             CHGVAR     VAR(&WCHK) VALUE('*NO ')
             ENDDO

             IF         (%SST(&AFILE 4 1) *EQ 'N') DO
             CHGVAR     VAR(&WMIN) VALUE('*IMMED')
             ENDDO
/*JW2*/
             IF         (%SST(&AFILE 4 1) *EQ 'E') DO
             CHGVAR     VAR(&WMIN) VALUE('*IMMED')
             ENDDO

             /*--------------------*/
             /*  LINE APPOINTMENT  */
             /*--------------------*/
             IF         (&ALIN *EQ '8') DO
             CHGVAR     VAR(&WGY) VALUE('88')
             CHGVAR     VAR(&WOV) VALUE('80')
             ENDDO

             OVRPRTF    FILE(QPDDSSRC) PAGESIZE(66 132) LPI(6) +
                          OVRFLW(60) RPLUNPRT(*YES ' ') OUTQ(&APRT) +
                          FORMTYPE(K6H1) HOLD(&WHLD)

             IF         COND(&WKUBN *EQ 'N') THEN(DO)
             IF         COND(&WFILE6 *EQ 'P') THEN(GOTO CMDLBL(@CRTPF))
             IF         COND(&WFILE6 *EQ 'L') THEN(GOTO CMDLBL(@CRTLF))
             IF         COND(&WFILE6 *EQ 'W') THEN(GOTO CMDLBL(@CRTPF))
             IF         COND(&WFILE6 *EQ 'N') THEN(GOTO CMDLBL(@CRTPF))
             IF         COND(&WFILE6 *EQ 'F') THEN(GOTO CMDLBL(@CRTLF))
             IF         COND(&WFILE6 *EQ 'D') THEN(GOTO +
                          CMDLBL(@CRTDSPF))
             IF         COND(&WFILE6 *EQ 'V') THEN(GOTO +
                          CMDLBL(@CRTPRTF))
             ENDDO


             /*-------------------*/
             /*  ..PP.TP.NP.WP..  */
             /*-------------------*/
             IF         (%SST(&AFILE 5 1) *EQ 'P') DO
@CRTPF:
             CALL       PGM(AJFR90) PARM(&ASLIB10 &ASRC10 &AFILE10 'C')

             CRTPF      FILE(&AOLIB/&AFILE) SRCFILE(&ASLIB/&ASRC) +
                          SRCMBR(&AFILE) TEXT(&ATXT) MAINT(&WMIN) +
                          SIZE(&ASIZ1 &ASIZ2 &ASIZ3) ALLOCATE(*NO) +
                          CONTIG(*NO) LVLCHK(&WCHK) AUT(*ALL)
             MONMSG     MSGID(CPF7302 CPF9999) EXEC(CHGVAR +
                          VAR(&AER2) VALUE('E'))

             GOTO       CMDLBL(@EXIT)

             ENDDO

             /*-------------------*/
             /*  ..PL.TL.NL.WL..  */
             /*-------------------*/
             IF         (%SST(&AFILE 5 1) *EQ 'L') DO
@CRTLF:
             CALL       PGM(AJFR90) PARM(&ASLIB10 &ASRC10 &AFILE10 'C')

             CRTLF      FILE(&AOLIB/&AFILE) SRCFILE(&ASLIB/&ASRC) +
                          SRCMBR(&AFILE) TEXT(&ATXT) MAINT(&WMIN) +
                          LVLCHK(&WCHK) AUT(*ALL)
             MONMSG     MSGID(CPF7302 CPF9999) EXEC(CHGVAR +
                          VAR(&AER2) VALUE('E'))

             GOTO       CMDLBL(@EXIT)

             ENDDO

             /*----------*/
             /*  ..PW..  */
             /*----------*/
             IF         (%SST(&AFILE 5 1) *EQ 'W') DO
@CRTDSPF:
             OVRDBF     FILE(SRCFILE) TOFILE(&ASLIB/&ASRC) MBR(&AFILE)
             CALL       PGM(AJFR08) PARM(&WMAH)
             MONMSG     MSGID(CPF9999 CPF4102)

             IF         (&AKSN *EQ 'Y') DO

             CALL       PGM(AJFR90) PARM(&ASLIB10 &ASRC10 &AFILE10 'C')

             CRTDSPF    FILE(&AOLIB/&AFILE) SRCFILE(&ASLIB/&ASRC) +
                          SRCMBR(&AFILE) IGCEXNCHR(*NO) TEXT(&ATXT) +
                          RSTDSP(*YES) DFRWRT(*NO) WAITRCD(&WMAH) +
                          AUT(*ALL)
             MONMSG     MSGID(CPF7302 CPF9999) EXEC(CHGVAR +
                          VAR(&AER2) VALUE('E'))
             ENDDO
             ELSE       DO

             CALL       PGM(AJFR90) PARM(&ASLIB10 &ASRC10 &AFILE10 'C')

             CRTDSPF    FILE(&AOLIB/&AFILE) SRCFILE(&ASLIB/&ASRC) +
                          SRCMBR(&AFILE) IGCEXNCHR(*NO) TEXT(&ATXT) +
                          RSTDSP(*YES) WAITRCD(&WMAH) AUT(*ALL)
             MONMSG     MSGID(CPF7302 CPF9999) EXEC(CHGVAR +
                          VAR(&AER2) VALUE('E'))
             ENDDO

             GOTO       CMDLBL(@EXIT)

             ENDDO

             /*----------*/
             /*  ..PR..  */
             /*----------*/
             IF         (%SST(&AFILE 5 1) *EQ 'R') DO
@CRTPRTF:
             IF         ((&ARECD *NE '156') *AND (&ARECD *NE '198')) DO

             CALL       PGM(AJFR90) PARM(&ASLIB10 &ASRC10 &AFILE10 'C')

             CRTPRTF    FILE(&AOLIB/&AFILE) SRCFILE(&ASLIB/&ASRC) +
                          SRCMBR(&AFILE) TEXT(&ATXT) PAGESIZE(&WGY +
                          132) LPI(&ALIN) OVRFLW(&WOV) +
                          FORMTYPE(K6H1) MAXRCDS(*NOMAX) +
                          SCHEDULE(*FILEEND) AUT(*ALL)
             MONMSG     MSGID(CPF7302 CPF9999) EXEC(CHGVAR +
                          VAR(&AER2) VALUE('E'))
             ENDDO
             ELSE       DO

             IF         (&ARECD *EQ '156') DO

             CALL       PGM(AJFR90) PARM(&ASLIB10 &ASRC10 &AFILE10 'C')

             CRTPRTF    FILE(&AOLIB/&AFILE) SRCFILE(&ASLIB/&ASRC) +
                          SRCMBR(&AFILE) TEXT(&ATXT) PAGESIZE(&WGY +
                          156) LPI(&ALIN) CPI(12) OVRFLW(&WOV) +
                          FORMTYPE(K6H1) MAXRCDS(*NOMAX) +
                          SCHEDULE(*FILEEND) AUT(*ALL)
             MONMSG     MSGID(CPF7302 CPF9999) EXEC(CHGVAR +
                          VAR(&AER2) VALUE('E'))
             ENDDO
             ELSE       DO

             CALL       PGM(AJFR90) PARM(&ASLIB10 &ASRC10 &AFILE10 'C')

             CRTPRTF    FILE(&AOLIB/&AFILE) SRCFILE(&ASLIB/&ASRC) +
                          SRCMBR(&AFILE) TEXT(&ATXT) PAGESIZE(&WGY +
                          198) LPI(&ALIN) CPI(15) OVRFLW(&WOV) +
                          FORMTYPE(K6H1) MAXRCDS(*NOMAX) +
                          SCHEDULE(*FILEEND) AUT(*ALL)
             MONMSG     MSGID(CPF7302 CPF9999) EXEC(CHGVAR +
                          VAR(&AER2) VALUE('E'))
             ENDDO
             ENDDO
             ENDDO
@EXIT:
             DLTOVR     FILE(QPDDSSRC)

 END:        ENDPGM
