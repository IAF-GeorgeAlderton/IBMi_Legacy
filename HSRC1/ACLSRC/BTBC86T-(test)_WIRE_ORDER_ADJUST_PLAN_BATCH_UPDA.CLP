             PGM
             /*** BTBC86 *******************************************/
             /* WIRE ORDER ADJUST PLAN BATCH UPDATE                */
             /*      SHIMAZU.      2015.04.24                      */
             /*----------------------------------------------------*/
             /* JW1  2021.04.08 USE (J:)PT.CSV JINSTEAD OF PC-FTP  */
             /******************************************************/
             DCLF       FILE(BTBPW86)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&REC)    TYPE(*DEC) LEN(10 0)
             DCL        VAR(&WLIB)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&FLIB)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&DDATE)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&WS3)    TYPE(*CHAR) LEN(3)
             DCL        VAR(&P9ER1)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&P9ER2)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&MBAN)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PERR)   TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&PPUSER) DATE(&DDATE)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&FLIB) VALUE('TWFILE1  ')

             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)

             CRTDTAARA  DTAARA(&FLIB/BTBC86ACT) TYPE(*CHAR) LEN(10) +
                          VALUE(&USER) AUT(*ALL)
             MONMSG     MSGID(CPF1023) EXEC(DO)
STEP0:
             SNDPGMMSG  MSG('(G) SOMEONE IS USING THIS PROGRAM. +
                          PLEASE ENTER G AND TRY LATER.') +
                          TOMSGQ(&WSID) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTE)
             IF         COND((&KOTE *EQ 'G') *OR (&KOTE *EQ 'g')) +
                          THEN(GOTO CMDLBL(@END))
             GOTO       CMDLBL(STEP0)
             ENDDO

       /**   @RETRY:                                              **/
       /**   DLTF       FILE(&WLIB/BTBWP86)                       **/
       /**   MONMSG     MSGID(CPF3261 CPF2105)                    **/
       /**   CRTPF      FILE(&WLIB/BTBWP85) RCDLEN(2048) +        **/
       /**                OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)   **/

 @DSP01:
             SNDRCVF    DEV(&WSID) RCDFMT(DSP01)
             CHGVAR     VAR(&IN99) VALUE('0')
             /***************/
             /* F1: END     */
             /***************/
             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(@EXIT))
 @OK:
             /***************/
             /* F5: PROCESS */
             /***************/
             IF         COND(&IN05 *EQ '0') THEN(GOTO CMDLBL(@DSP01))

             /***********************/
             /* UPLOAD CSV DATA     */
             /***********************/
             CLRPFM     FILE(&FLIB/BTBWP85N)
             CPYFRMIMPF +
                          FROMSTMF('/QNTC/IAF-AS400-FILE/AS400-TRANS/+
                          PC/UPLOAD/WIRE.CSV') +
                          TOFILE(&FLIB/BTBWP85N) MBROPT(*REPLACE) +
                          FROMCCSID(*FILE) RCDDLM(*CRLF) +
                          FLDDLM(*TAB) DATFMT(*USA) TIMFMT(*USA) +
                          ERRRCDOPT(*REPLACE)

             CHGVAR     VAR(&REC) VALUE(0)
             RTVMBRD    FILE(BTBWP85N) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(DO)
             CHGVAR     VAR(&XMSG) VALUE('DATA IS 0.')
             CHGVAR     VAR(&IN99) VALUE('1')
             GOTO       CMDLBL(@DSP01)
             ENDDO

             CLRPFM     FILE(*LIBL/BTBPP85)
             CLRPFM     FILE(*LIBL/BTBPP8Y)

             /* BTBWP85N -> BTBPP85 */
             OVRDBF     FILE(BTBWP85) TOFILE(&FLIB/BTBWP85N)
             CALL       PGM(BTBR85)

             /* CHECK DATA         */
             CALL       PGM(BTBC87) PARM(&PERR)
             IF         COND(&PERR *EQ '9') THEN(GOTO CMDLBL(@EXIT))

             RUNQRY     QRY(TOBJ1/BTBPP85)
@RPRY:
             SNDPGMMSG  MSG('( G ) DATA IS OK? +
                          G:OK(UPDATE) C:NG(CALCEL)') +
                          TOMSGQ(&WSID) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTE)
             IF         COND((&KOTE *EQ 'G') *OR (&KOTE *EQ 'g')) +
                          THEN(GOTO CMDLBL(@EXEC))
             IF         COND((&KOTE *EQ 'C') *OR (&KOTE *EQ 'c')) +
                          THEN(GOTO CMDLBL(@EXIT))
             GOTO       CMDLBL(@RPRY)

@EXEC:
             DLTF       FILE(&FLIB/BTBWP86)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&FLIB/BTBWP86) RCDLEN(512) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)


             CPYF       FROMFILE(BTBPP05) TOFILE(MAMIYA/BTBPP05) +
                          MBROPT(*REPLACE) CRTFILE(*YES)

             /* BTBPP85 -> BTBPP05 */
             /* BTBPP85 -> BTBWP86 */
             CALL       PGM(BTBR86)  PARM(&P9ER1 &P9ER2)

/* JW1 SAVE BTBWP85 */
             DLTOVR     FILE(BTBWP85)
             CPYF       FROMFILE(TWFILE1/BTBWP85N) +
                          TOFILE(TWFILE1/BTBWP85) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)

             CHGVAR     VAR(&REC) VALUE(0)

             IF         COND(&P9ER1 *EQ '1') THEN(DO)
             SNDMSG     MSG('DATA WHICH IS NOT APICS HAS BEEN +
                          FOUNDED.') TOMSGQ(&WSID)
             STRPCO     PCTA(*NO)
             MONMSG     MSGID(CPF0000)
             ENDDO

              IF         COND(&P9ER2 *EQ '1') THEN(DO)
              SNDMSG     MSG('DATA CONTAINS QTY EXCEEDED 1000.') +
                           TOMSGQ(&WSID)
              STRPCO     PCTA(*NO)
              MONMSG     MSGID(CPF0000)
              ENDDO

             RTVMBRD    FILE(BTBWP86) NBRCURRCD(&REC)
             IF         COND(&REC *NE 0) THEN(DO)
             CALL       PGM(APLC94) PARM('1' 'BTBWP86' 'TWFILE1' +
                          'WIRE CSV DATA ERROR' 'Y' 'N' 'Y')
             ENDDO

@EXIT:
             DLTDTAARA  DTAARA(&FLIB/BTBC86ACT)
@END:
             ENDPGM
