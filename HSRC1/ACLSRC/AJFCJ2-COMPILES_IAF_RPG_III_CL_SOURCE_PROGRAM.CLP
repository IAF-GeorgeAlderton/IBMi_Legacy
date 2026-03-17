             PGM        PARM(&ASLIB &AOLIB &ASRC &APGM &AI &AR &AY +
                          &AJOBQ &APRT &AER2 &AER3)
             /** AJFCJ2 **********************************************/
             /* COMPILES IAF RPG III / CL SOURCE PROGRAM             */
             /*  JOBQ                                                */
             /*        I-HASADA                      96.06.28        */
             /********************************************** AJFCJ2 **/
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

             DCL        VAR(&ASLIB10) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ASRC10) TYPE(*CHAR) LEN(10)
             DCL        VAR(&APGM10) TYPE(*CHAR) LEN(10)

             DCL        VAR(&WKUBN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WPGM1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WPGM6) TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&ASLIB10) VALUE(&ASLIB)
             CHGVAR     VAR(&ASRC10)  VALUE(&ASRC)
             CHGVAR     VAR(&APGM10)  VALUE(&APGM)

             CHGVAR     VAR(&WKUBN) VALUE('O')
             IF         (%SST(&APGM 4 1) *EQ 'R') GOTO @OLD
             IF         (%SST(&APGM 4 1) *EQ 'C') GOTO @OLD
             IF         (%SST(&APGM 4 1) *EQ 'M') GOTO @OLD
             CHGVAR     VAR(&WKUBN) VALUE('N')
             CHGVAR     VAR(&WPGM6) VALUE(%SST(&APGM 6 1))
@OLD:
             IF         (&AR *EQ 'R') DO
             CHGVAR     VAR(&WHLD) VALUE('*NO ')
             ENDDO

             IF         COND(&WKUBN *EQ 'N') THEN(DO)
             IF         COND(&WPGM6 *EQ 'R') THEN(GOTO CMDLBL(@RPG))
             IF         COND(&WPGM6 *EQ 'C') THEN(GOTO CMDLBL(@CL))
             ENDDO

             /*--------------*/
             /*   ..CMD ..   */
             /*--------------*/
             IF         (%SST(&APGM 4 1) *EQ 'M') DO
@CMD:
             OVRPRTF    FILE(QSYSPRT) PAGESIZE(66 132) LPI(6) +
                          OVRFLW(60) RPLUNPRT(*YES ' ') OUTQ(&APRT) +
                          FORMTYPE(K6H1) HOLD(&WHLD)
             CRTCMD     CMD(&AOLIB/&APGM) PGM(&AOLIB/&APGM) +
                          SRCFILE(&ASLIB/&ASRC) SRCMBR(&APGM) +
                          TEXT('CMD-PGM')
             DLTOVR     FILE(QSYSPRT)

             GOTO END

             ENDDO

             /*--------------*/
             /*   ..RPG ..   */
             /*--------------*/
             IF         (%SST(&APGM 4 1) *EQ 'R') DO
@RPG:



             IF         (&AI *EQ 'I') DO

             ALCOBJ     OBJ((&ASLIB/&ASRC *FILE *SHRUPD &APGM))
             MONMSG     MSGID(CPF0948 CPF1085) EXEC(GOTO CMDLBL(STP2))
             DLCOBJ     OBJ((&ASLIB/&ASRC *FILE *SHRUPD &APGM))

             OVRPRTF    FILE(QSYSPRT) PAGESIZE(66 132) LPI(6) +
                          OVRFLW(60) RPLUNPRT(*YES ' ') OUTQ(&APRT) +
                          FORMTYPE(K6H1) HOLD(&WHLD)

             CALL       PGM(AJFR90) PARM(&ASLIB10 &ASRC10 &APGM10 'C')

             IF         (&AY *EQ 'Y') DO
             CRTRPGPGM  PGM(&AOLIB/&APGM) SRCFILE(&ASLIB/&ASRC) +
                          SRCMBR(&APGM) GENOPT(*OPTIMIZE) ALWNULL(*YES)
             MONMSG     MSGID(QRG9001 CPF9999) EXEC(CHGVAR +
                          VAR(&AER2) VALUE('E'))
             ENDDO
             ELSE       DO
             CRTRPGPGM  PGM(&AOLIB/&APGM) SRCFILE(&ASLIB/&ASRC) +
                          SRCMBR(&APGM) OPTION(*NOXREF) +
                          GENOPT(*OPTIMIZE) ALWNULL(*YES)
             MONMSG     MSGID(QRG9001 CPF9999) EXEC(CHGVAR +
                          VAR(&AER2) VALUE('E'))
             ENDDO

             DLTOVR     FILE(QSYSPRT)




             ENDDO

             GOTO END

             ENDDO

             /*--------------*/
             /*   ..CL ..    */
             /*--------------*/
             IF         (%SST(&APGM 4 1) *EQ 'C') DO
@CL:
             ALCOBJ     OBJ((&ASLIB/&ASRC *FILE *SHRUPD &APGM))
             MONMSG     MSGID(CPF0948 CPF1085) EXEC(GOTO CMDLBL(STP2))
             DLCOBJ     OBJ((&ASLIB/&ASRC *FILE *SHRUPD &APGM))

             OVRPRTF    FILE(QSYSPRT) PAGESIZE(66 132) LPI(6) +
                          OVRFLW(60) RPLUNPRT(*YES ' ') OUTQ(&APRT) +
                          FORMTYPE(K6H1) HOLD(&WHLD)

             CALL       PGM(AJFR90) PARM(&ASLIB10 &ASRC10 &APGM10 'C')

             CRTCLPGM   PGM(&AOLIB/&APGM) SRCFILE(&ASLIB/&ASRC) +
                          SRCMBR(&APGM)
             MONMSG     MSGID(CPF0801 CPF9999) EXEC(CHGVAR +
                          VAR(&AER2) VALUE('E'))
             DLTOVR     FILE(QSYSPRT)

             ENDDO

             GOTO       END

 STP2:       CHGVAR     VAR(&AER3) VALUE('E')

 END:        ENDPGM
