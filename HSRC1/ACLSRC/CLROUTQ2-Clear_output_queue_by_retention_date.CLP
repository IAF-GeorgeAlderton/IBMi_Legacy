 /*   ************************************************************************/
 /*   * PROGRAM  : CLROUTQ                                                   */
 /*   * COPIED   : CLRSPLOUTQ (G3X1CUSOBJ)                                   */
 /*   * BY       : J.WATANABE                                                */
 /*   * DATE     : 2018.02.27                                                */
 /*   * PURPOSE  : Clear an output queue based on a retention date           */
 /*   *            Before compiling this program, file SPOOL132 must exist   */
 /*                in the library list.  It is suggested to create SPOOL132  */
 /*                in library QTEMP with a record length of 132, and then    */
 /*                to compile this program interactively.                    */
 /*                CRTPF FILE(QTEMP/SPOOL132) RCDLEN(132) SIZE(99999 10000)  */
 /*   ************************************************************************/
 CLRSPLOUTQ: PGM        PARM(&OUTQ &RETDATE)

             DCL        VAR(&OUTQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RETDATE) TYPE(*CHAR) LEN(08)
             DCL        VAR(&PRTFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBNAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBNBR) TYPE(*CHAR) LEN(06)
             DCL        VAR(&SPLNBR$) TYPE(*CHAR) LEN(04)
             DCL        VAR(&SPLNBR#) TYPE(*DEC) LEN(4 0)
             DCL        VAR(&SPLDATE) TYPE(*CHAR) LEN(08)
             DCL        VAR(&CHK) TYPE(*CHAR) LEN(02)
             DCL        VAR(&CHK2) TYPE(*CHAR) LEN(07)

             DCLF       FILE(QTEMP/SPOOL132)

             DLTF       FILE(QTEMP/SPOOL132)
             MONMSG     MSGID(CPF0000)
             CRTPF      FILE(QTEMP/SPOOL132) RCDLEN(132) SIZE(99999 10000)

 /* Delete any existing QPRTSPLQ                                       */
 LOOP1:      DLTSPLF    FILE(QPRTSPLQ) SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CNTNU01)
             GOTO       CMDLBL(LOOP1)

 CNTNU01:    WRKOUTQ    OUTQ(&OUTQ) OUTPUT(*PRINT)
             CPYSPLF    FILE(QPRTSPLQ) TOFILE(QTEMP/SPOOL132) +
                          SPLNBR(*LAST)

 LOOP2:      RCVF
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDPGM))

             CHGVAR     VAR(&CHK) VALUE(%SST(&SPOOL132  88 2))
 /* IF NOT DETAIL LINE, CYCLE    */
             IF         COND(&CHK *EQ '  ') THEN(GOTO CMDLBL(LOOP2))

             CHGVAR     VAR(&CHK2) VALUE(%SST(&SPOOL132  02 7))
 /* IF NOT DETAIL LINE, CYCLE    */
             IF         COND(&CHK2 *EQ '5770SS1') THEN(GOTO CMDLBL(LOOP2))

             CHGVAR     VAR(&JOBNBR) VALUE(%SST(&SPOOL132  95 6))
 /* IF NOT DETAIL LINE, CYCLE    */
             IF         COND(&JOBNBR *LT '000000' *OR &JOBNBR *GT +
                          '999999') THEN(GOTO CMDLBL(LOOP2))

             CHGVAR     VAR(&SPLDATE)  VALUE(%SST(&SPOOL132 102 08))
             IF         COND(&SPLDATE *LT &RETDATE) THEN(DO)
             CHGVAR     VAR(&PRTFILE)  VALUE(%SST(&SPOOL132   2  10))
             CHGVAR     VAR(&USER)     VALUE(%SST(&SPOOL132  13  10))
             CHGVAR     VAR(&JOBNAME)  VALUE(%SST(&SPOOL132  84  10))
             CHGVAR     VAR(&SPLNBR$)  VALUE(%SST(&SPOOL132  75  04))
             CHGVAR     VAR(&SPLNBR#)  VALUE(&SPLNBR$)

             DLTSPLF    FILE(&PRTFILE) JOB(&JOBNBR/&USER/&JOBNAME) +
                          SPLNBR(&SPLNBR#)
             ENDDO
             GOTO       CMDLBL(LOOP2)

 ENDPGM:

             DLTSPLF    FILE(QPRTSPLQ) SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CNTNU01)
             ENDPGM

