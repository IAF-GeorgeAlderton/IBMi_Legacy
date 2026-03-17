             PGM
             /*** AH#C25 ************************************/
             /*   A-PICSかんばん発行　日当箱数集計リスト  */
             /*   ... ﾍ]ﾌﾞ]sﾞl ...                          */
             /*            H.ITO            88.02.16        */
             /************************************ AH#C25 ***/
             DCLF       FILE(AH#PW25)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PUS) TYPE(*CHAR) LEN(10)

             DCL        VAR(&REC)    TYPE(*DEC)  LEN(10 0)
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE2) TYPE(*CHAR) LEN(9)
             DCL        VAR(&XYY) TYPE(*CHAR) LEN(4)
             DCL        VAR(&XMM) TYPE(*CHAR) LEN(2)
             DCL        VAR(&XDD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PYY) TYPE(*DEC) LEN(4)
             DCL        VAR(&PMM) TYPE(*DEC) LEN(2)
             DCL        VAR(&PDD) TYPE(*DEC) LEN(2)
             RTVJOBA    JOB(&WSID) USER(&PUS)
             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 2))
             CHGVAR     VAR(&FILE1) VALUE('AH#WP25' *CAT &WS)
             CHGVAR     VAR(&FILE2) VALUE('AH#WP26' *CAT &WS)
             CHGJOB     RUNPTY(40)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00)  PARM(&WSID &PRT &TYPE &PRTG)

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(AH#PW251)
             IF         (&IN01 *EQ '1') GOTO END
             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN03) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         COND(&PBMON *EQ '    ') THEN(DO)
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT SECTION CODE ')
             GOTO STP1
             ENDDO

             IF         COND((&PBMON *NE '0111')) THEN(DO)
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) +
                          VALUE('SECTION CODE IS 0111')
             GOTO STP1
             ENDDO

             IF         COND(&PHIZ *EQ '        ') THEN(DO)
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT DATE')
             GOTO STP1
             ENDDO

             CHGVAR     VAR(&XYY) VALUE(%SST(&PHIZ 1 4))
             CHGVAR     VAR(&XMM) VALUE(%SST(&PHIZ 5 2))
             CHGVAR     VAR(&XDD) VALUE(%SST(&PHIZ 7 2))
             IF         COND((&XYY *EQ '    ') *OR (&XMM *EQ ' ') +
                          *OR (&XDD *EQ ' ')) THEN(DO)
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE SPECIFICATION AT THE +
                          DATE IS NOT CORRECT')
             GOTO STP1
             ENDDO

             CHGVAR     VAR(&PYY) VALUE(%SST(&PHIZ 1 4))
             CHGVAR     VAR(&PMM) VALUE(%SST(&PHIZ 5 2))
             CHGVAR     VAR(&PDD) VALUE(%SST(&PHIZ 7 2))

             IF         ((&PYY *LT 1989) *OR (&PMM *LT 01) *OR +
                        (&PMM *GT 12) *OR (&PDD *LT 01) *OR (&PDD +
                          *GT 31)) DO
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE SPECIFICATION AT THE +
                          DATE IS NOT CORRECT')
             GOTO STP1
             ENDDO

             IF         (&IN05 *EQ '0') GOTO STP1

             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE1) RCDLEN(50) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)

             OVRDBF     FILE(AH#WP25) TOFILE(&FILE1)
             CALL       PGM(AH#R25) PARM(&PBMON &PHIZ)

             CHGVAR     VAR(&REC) VALUE('0')
             RTVMBRD    FILE(HWFILE1/&FILE1) NBRCURRCD(&REC)
             IF         COND(&REC = 0) THEN(GOTO CMDLBL(END))

             DLTF       FILE(&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE2) RCDLEN(50) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)

             OVRDBF     FILE(AH#WP26) TOFILE(&FILE2)
             FMTDTA     INFILE((HWFILE1/&FILE1)) +
                          OUTFILE(HWFILE1/&FILE2) SRCFILE(FMTSRC) +
                          SRCMBR(AH#S25) OPTION(*NOPRT)
             DLTF       FILE(&FILE1)

             OVRPRTF    FILE(AH#PR25) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          132) LPI(6) CPI(10) OVRFLW(60) +
                          RPLUNPRT(*YES) OUTQ(QPRINTA) +
                          FORMTYPE(K6H1) MAXRCDS(*NOMAX)
 /*  AS400 NO.3 TEST */
 /*----------------------------------------------------------------*/
 /*          OVRPRTF    FILE(AH#PR25) DEVTYPE(*SCS) PAGESIZE(66 +
                          132) LPI(6) CPI(10) OVRFLW(60) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) +
                          FORMTYPE(K6H1) MAXRCDS(*NOMAX)      */
 /*----------------------------------------------------------------*/
             CALL       PGM(AH#R26) PARM(&PBMON &PHIZ)
             DLTF       FILE(&FILE2)
             DLTOVR     FILE(*ALL)

 END:        CHGJOB     RUNPTY(20)
             DLTOVR     FILE(*ALL)

             ENDPGM
