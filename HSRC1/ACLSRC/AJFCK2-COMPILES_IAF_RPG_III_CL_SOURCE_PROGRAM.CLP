             PGM        PARM(&ASLIB &AOLIB &ASRC &APGM &AI &AR &AY +
                          &AJOBQ &APRT &AER2 &AER3)
             /** AJFCK2 **********************************************/
             /* COMPILES IAF RPG III / CL SOURCE PROGRAM             */
             /* TEST LIBRARY                                         */
             /*  JOBQ                                                */
             /*        I-HASADA                    2000.12.12        */
             /********************************************** AJFCK2 **/
             DCL        VAR(&ASLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&AOLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&ASRC) TYPE(*CHAR) LEN(8)
             DCL        VAR(&APGM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&AI) TYPE(*CHAR) LEN(1)
             DCL        VAR(&AR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&AY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&AJOBQ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&APRT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AER2) TYPE(*CHAR) LEN(1)
             DCL        VAR(&AER3) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WHLD) TYPE(*CHAR) LEN(4) VALUE('*YES')
             DCL        VAR(&WOBJ) TYPE(*CHAR) LEN(9)

             CHGLIBL    LIBL(QGPL QTEMP QMGU QPCFSU TOBJ1 TFILE1 +
                          TWFILE1 TJRN1 HSRC1)

             IF         (&AOLIB *EQ 'HOBJ1   ') DO
             CHGVAR     VAR(&AOLIB) VALUE('TOBJ1   ')
             ENDDO

             IF         (&AR *EQ 'R') DO
             CHGVAR     VAR(&WHLD) VALUE('*NO ')
             ENDDO

             /*--------------*/
             /*   ..CMD ..   */
             /*--------------*/
             IF         (%SST(&APGM 4 1) *EQ 'M') DO

             OVRPRTF    FILE(QSYSPRT) PAGESIZE(66 132) LPI(6) +
                          OVRFLW(60) RPLUNPRT(*YES ' ') OUTQ(&APRT) +
                          FORMTYPE(K6H1) HOLD(&WHLD)
             CRTCMD     CMD(&AOLIB/&APGM) PGM(&AOLIB/&APGM) +
                          SRCFILE(&ASLIB/&ASRC) SRCMBR(&APGM) +
                          TEXT('CMD-PGM')
             DLTOVR     FILE(QSYSPRT)

             ENDDO

             /*--------------*/
             /*   ..RPG ..   */
             /*--------------*/
             IF         (%SST(&APGM 4 1) *EQ 'R') DO
             IF         (&AI *EQ 'I') DO

             ALCOBJ     OBJ((&ASLIB/&ASRC *FILE *SHRUPD &APGM))
             MONMSG     MSGID(CPF0948 CPF1085) EXEC(GOTO CMDLBL(STP2))
             DLCOBJ     OBJ((&ASLIB/&ASRC *FILE *SHRUPD &APGM))

             OVRPRTF    FILE(QSYSPRT) PAGESIZE(66 132) LPI(6) +
                          OVRFLW(60) RPLUNPRT(*YES ' ') OUTQ(&APRT) +
                          FORMTYPE(K6H1) HOLD(&WHLD)

             IF         (&AY *EQ 'Y') DO
             CRTRPGPGM  PGM(&AOLIB/&APGM) SRCFILE(&ASLIB/&ASRC) +
                          SRCMBR(&APGM) GENOPT(*OPTIMIZE)
             MONMSG     MSGID(QRG9001 CPF9999) EXEC(CHGVAR +
                          VAR(&AER2) VALUE('E'))
             ENDDO

             ELSE       DO
             CRTRPGPGM  PGM(&AOLIB/&APGM) SRCFILE(&ASLIB/&ASRC) +
                          SRCMBR(&APGM) OPTION(*NOXREF) +
                          GENOPT(*OPTIMIZE)
             MONMSG     MSGID(QRG9001 CPF9999) EXEC(CHGVAR +
                          VAR(&AER2) VALUE('E'))
             ENDDO
             DLTOVR     FILE(QSYSPRT)

             ENDDO
             ENDDO

             /*--------------*/
             /*   ..CL ..    */
             /*--------------*/
             IF         (%SST(&APGM 4 1) *EQ 'C') DO

             ALCOBJ     OBJ((&ASLIB/&ASRC *FILE *SHRUPD &APGM))
             MONMSG     MSGID(CPF0948 CPF1085) EXEC(GOTO CMDLBL(STP2))
             DLCOBJ     OBJ((&ASLIB/&ASRC *FILE *SHRUPD &APGM))

             OVRPRTF    FILE(QSYSPRT) PAGESIZE(66 132) LPI(6) +
                          OVRFLW(60) RPLUNPRT(*YES ' ') OUTQ(&APRT) +
                          FORMTYPE(K6H1) HOLD(&WHLD)
             CRTCLPGM   PGM(&AOLIB/&APGM) SRCFILE(&ASLIB/&ASRC) +
                          SRCMBR(&APGM)
             MONMSG     MSGID(CPF0801 CPF9999) EXEC(CHGVAR +
                          VAR(&AER2) VALUE('E'))
             DLTOVR     FILE(QSYSPRT)

             ENDDO

             GOTO       END

 STP2:       CHGVAR     VAR(&AER3) VALUE('E')

 END:        CHGLIBL    LIBL(QGPL QTEMP QMGU QPCFSU HOBJ1 HFILE1 +
                          HWFILE1 HJRN1 HSRC1)

             ENDPGM
