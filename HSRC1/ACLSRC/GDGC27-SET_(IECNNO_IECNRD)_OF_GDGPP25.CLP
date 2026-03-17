             PGM
             /** GDGC27 **************************************/
             /*   SET (IECNNO, IECNRD) OF GDGPP25            */
             /*     SEEK.                    2023.02.17      */
             /************************************************/
             DCLF       FILE(GDGPW27)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10) VALUE('HWFILE1')
             DCL        VAR(&RCDS) TYPE(*DEC) LEN(10 0) VALUE(0)

             RTVJOBA    JOB(&WSID)
@DSP01:
             SNDRCVF    DEV(&WSID) RCDFMT(DSP01)
             CHGVAR     VAR(&IN99) VALUE('0')
/***************/
/* F1: END     */
/***************/
             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(@END))
@OK:
/***************/
/* F5: PROCESS */
/***************/
             IF         COND(&IN05 *EQ '0') THEN(GOTO CMDLBL(@DSP01))
             CLRPFM     FILE(&LIB/GDGWP27)

             CPYFRMIMPF +
                          FROMSTMF('/QNTC/IAF-AS400-FILE/AS400-TRANS/+
                          PC/UPLOAD/CASE#.CSV') +
                          TOFILE(&LIB/GDGWP27) MBROPT(*REPLACE) +
                          FROMCCSID(*FILE) RCDDLM(*CRLF) +
                          STRDLM(*DBLQUOTE) DATFMT(*USA) +
                          TIMFMT(*USA) FROMRCD(2) +
                          ERRRCDOPT(*REPLACE) RPLNULLVAL(*FLDDFT)

             RTVMBRD    FILE(&LIB/GDGWP27) NBRCURRCD(&RCDS)
             IF (&RCDS = 0)    (DO)
             CHGVAR     VAR(&XMSG) VALUE('NO DATA EXISTS')
             CHGVAR     VAR(&IN99) VALUE('1')
             GOTO       CMDLBL(@DSP01)
             ENDDO

             CALL       PGM(GDGR27)
@END:
             ENDPGM
