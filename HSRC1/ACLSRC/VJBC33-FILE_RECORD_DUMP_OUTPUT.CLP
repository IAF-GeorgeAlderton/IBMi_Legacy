             PGM
             /*** VJBC33 ***************************/
             /*    FILE RECORD DUMP OUTPUT         */
             /*   C:N.HAYAKAWA     90.03.06        */
             /*************************** VJBC33 ***/
             DCLF       FILE(VJBPW33)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&ERR) TYPE(*CHAR) LEN(60)
             DCL        VAR(&ERR) TYPE(*CHAR) LEN(60)
             DCL        VAR(&OUTF) TYPE(*CHAR) LEN(5)
             RTVJOBA    JOB(&WSID)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGVAR     VAR(&OUTF) VALUE('*CHAR')
 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(VJBPW331)
             IF         (&IN01 *EQ '1') GOTO END
             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN03) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&FILE *EQ '       ') DO
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&ERR) VALUE('THE FILE NAME IS NOT INPUT.')
             GOTO       STP1
             ENDDO

             IF         COND(&OUTF *EQ '*CHAR') THEN(GOTO CMDLBL(OK))
             IF         COND(&OUTF *EQ '*HEX ') THEN(GOTO CMDLBL(OK))

             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&ERR) VALUE('THE OUTPUT FORM IS EIHER +
                          *HEX AND *CHAR.')
             GOTO       STP1

  OK:        IF         (%SST(&FILE 1 1) *EQ 'D') GOTO STPC
             IF         (%SST(&FILE 1 1) *EQ 'M') GOTO STPC
             IF         (%SST(&FILE 1 1) *EQ 'R') GOTO STPC
             IF         (%SST(&FILE 1 1) *EQ 'F') GOTO STPC
             IF         (%SST(&FILE 1 1) *EQ 'T') GOTO STPC
             IF         (%SST(&FILE 1 1) *EQ 'U') GOTO STPC
             IF         (%SST(&FILE 1 1) *EQ 'E') GOTO STPC
             IF         (%SST(&FILE 1 1) *EQ 'N') GOTO STPC
             IF         (%SST(&FILE 1 1) *EQ 'K') GOTO STPC
             IF         (%SST(&FILE 1 1) *EQ 'G') GOTO STPC
             IF         (%SST(&FILE 1 1) *EQ 'S') GOTO STPC
             IF         (%SST(&FILE 1 1) *EQ 'V') GOTO STPC
             IF         (%SST(&FILE 1 1) *EQ 'A') GOTO STPC
             IF         (%SST(&FILE 1 1) *EQ 'J') GOTO STPC
             IF         (%SST(&FILE 1 1) *EQ 'B') GOTO STPC
             IF         (%SST(&FILE 1 1) *EQ 'O') GOTO STPC
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&ERR) VALUE('THE FIRST DIGIT OF FILE +
                          NAME IS WRONG.')
             GOTO       STP1

 STPC:       GOTO @001
             IF         (%SST(&FILE 4 2) *EQ 'PP') GOTO @001
             IF         (%SST(&FILE 4 2) *EQ 'PL') GOTO @001
             IF         (%SST(&FILE 4 2) *EQ 'TP') GOTO @001
             IF         (%SST(&FILE 4 2) *EQ 'TL') GOTO @001
             IF         (%SST(&FILE 4 2) *EQ 'WP') GOTO @001
             IF         (%SST(&FILE 4 2) *EQ 'WL') GOTO @001
             IF         (%SST(&FILE 4 2) *EQ 'NP') GOTO @001
             IF         (%SST(&FILE 4 2) *EQ 'NL') GOTO @001
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&ERR) VALUE('THE 4TH DIGHT AND 5TH DIGHT +
                          OF THE NAME OF THE FILE ARE WRONG.')
             GOTO       STP1

 @001:       IF         (&IN05 *EQ '0') GOTO STP1

             CHKOBJ     OBJ(&FILE) OBJTYPE(*FILE) MBR(&FILE) AUT(*ALL)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(@ERR))
             OVRPRTF    FILE(QSYSPRT) PAGESIZE(66 132) LPI(6) +
                          OVRFLW(60) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          HOLD(*YES)
             CPYF       FROMFILE(&FILE) TOFILE(*PRINT) +
                          FROMMBR(&FILE) OUTFMT(&OUTF)
             DLTOVR     FILE(QSYSPRT)
             GOTO       END

 @ERR:       CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&ERR) VALUE('THE INPUT FILE NAME DOES +
                          NOT EXIST.')
             GOTO       STP1

 END:        ENDPGM
