             PGM
             /*** BTAC85N *********************************************/
             /*   PT ORDER ADJUSTMENT PLAN UPDATE                     */
             /*         A.MAMIYA    2005.02.21                        */
             /*         T.SAKASHITA 2009.06.03                        */
             /*-----------------------------------                    */
             /* JW1     2021.04.06 USE IFS.CSV INSTEAD OF P-COM FTP   */
             /*********************************************************/
             DCLF       FILE(BTAPW85N)
             DCL        VAR(&REC)     TYPE(*DEC) LEN(10)
             DCL        VAR(&WSID)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&MBAN)    TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&SYSTEM)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&P9ER1)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&P9ER2)   TYPE(*CHAR) LEN(1)

             DCL        VAR(&WLIB)    TYPE(*CHAR) LEN(8)
             DCL        VAR(&PPUSER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&FLIB)    TYPE(*CHAR) LEN(10)

             RTVJOBA    USER(&PPUSER)

             RTVJOBA    JOB(&WSID) USER(&USER)
             RTVNETA    SYSNAME(&SYSTEM)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGVAR     VAR(&FLIB) VALUE('TWFILE1  ')
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TWFILE1 ')
             ENDDO

@DSP01:
             SNDRCVF    DEV(&WSID) RCDFMT(DSP01)
             CHGVAR     VAR(&IN99) VALUE('0')
             /***************/
             /* F1 = END    */
             /***************/
             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(@EXIT))

             /****************/
             /* F5 = PROCESS */
             /****************/
             IF         COND(&IN05 *EQ '0') THEN(GOTO CMDLBL(@DSP01))

             /*********************/
             /* UPLOAD CSV DATE   */
             /*********************/
             CLRPFM     FILE(&FLIB/BTAWP85N)
             CPYFRMIMPF +
                          FROMSTMF('/QNTC/IAF-AS400-FILE/AS400-TRANS/+
                          PC/UPLOAD/PT.CSV') +
                          TOFILE(&FLIB/BTAWP85N) MBROPT(*REPLACE) +
                          FROMCCSID(*FILE) RCDDLM(*CRLF) +
                          FLDDLM(*TAB) DATFMT(*USA) TIMFMT(*USA) +
                          ERRRCDOPT(*REPLACE)

             CHGVAR     VAR(&REC) VALUE(0)
             RTVMBRD    FILE(&FLIB/BTAWP85N) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(DO)
             CHGVAR     VAR(&XMSG) VALUE('NO DATA EXISTS')
             CHGVAR     VAR(&IN99) VALUE('1')
             GOTO       CMDLBL(@DSP01)
             ENDDO

             CLRPFM     FILE(*LIBL/BTAPP85)
             CLRPFM     FILE(*LIBL/BTAPP8Y)

             /* BTAWP85N -> BTAPP85 */
             OVRDBF     FILE(BTAWP85) TOFILE(&FLIB/BTAWP85N)
             CALL       PGM(BTAR85)

             RUNQRY     QRY(TOBJ1/BTAPP85)

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
             DLTF       FILE(&FLIB/BTAWP86)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&FLIB/BTAWP86) RCDLEN(512) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             CPYF       FROMFILE(BTAPP05) TOFILE(MAMIYA/BTAPP05) +
                          MBROPT(*REPLACE) CRTFILE(*YES)


             /* BTAPP85 -> BTAPP05 */
             /* BTAPP85 -> BTAWP86 */
             CALL       PGM(BTAR86)  PARM(&P9ER1 &P9ER2)

/* JW1 SAVE BTAWP85N */
             DLTOVR     FILE(BTAWP85)
             CPYF       FROMFILE(&FLIB/BTAWP85N) +
                          TOFILE(TWFILE1/BTAWP85) MBROPT(*ADD) +
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

/* ERROR MSG */
             RTVMBRD    FILE(BTAWP86) NBRCURRCD(&REC)
             IF         COND(&REC *NE 0) THEN(DO)
             CALL       PGM(APLC94) PARM('1' 'BTAWP86' 'TWFILE1' 'PT +
                          CSV DATA ERROR' 'Y' 'N' 'Y')
             ENDDO

@EXIT:
@END:
             ENDPGM
