PGM
             /**** APLC04 *****************************************/
             /* TRANSFER CSV TO PF                                */
             /*          FROM --> TO                              */
             /* JW  2020.05.06                                    */
             /* FROM: (J:) /PC/UPLOAD/UPL20A.CSV                  */
             /* TO  : HWFILE1 / UPLWP10                           */
             /*****************************************************/
             DCLF       FILE(APLPW04)

             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

             /*** DISPLAY INITIAL SCREEN ***/
 DSP01:
             SNDRCVF    DEV(&WSID) RCDFMT(DSP01)
             CHGVAR     VAR(&XMSG) VALUE(' ')

             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(XEND))

             IF         COND(&IN05 *EQ '0') THEN(DO)
             CHGVAR     VAR(&XMSG) VALUE('PRESS F5 TO UPLOAD DATA...')
                        GOTO CMDLBL(DSP01)
                        ENDDO

             /*** TRANSFER FROM J: ***/
             CPYFRMIMPF +
                          FROMSTMF('/QNTC/IAF-AS400-FILE/AS400-TRANS/+
                          PC/Upload/UPL20A.csv') +
                          TOFILE(&WLIB/UPLWP10) MBROPT(*REPLACE) +
                          FROMCCSID(*FILE) RCDDLM(*CRLF) +
                          STRDLM(*DBLQUOTE) DATFMT(*USA) +
                          TIMFMT(*USA) ERRRCDOPT(*REPLACE)
             MONMSG     MSGID(CPF2817)

 XEND:
             ENDPGM
