             PGM
             /** AU#C10 *****************************************/
             /* .. A-PICS ORDER RECEIPT NUMBER ABNORMAL LIST .. */
             /*                                                 */
             /* CODING:K.OKACHI    2002/07/16                   */
             /***************************************************/
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)

             DCL        VAR(&WS)     TYPE(*CHAR) LEN(2)
             DCL        VAR(&FILE01) TYPE(*CHAR) LEN(10)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0) VALUE(0)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 2))
             CHGVAR     VAR(&FILE01)  VALUE('AU#WP10' *CAT &WS)

             DLTF       FILE(&WLIB/&FILE01)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE01) RCDLEN(512) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AU#WP10) TOFILE(&WLIB/&FILE01)
             CALL       PGM(AU#R10)
             DLTOVR AU#WP10
             RTVMBRD    FILE(&WLIB/&FILE01) NBRCURRCD(&REC)
             IF (&REC *NE 0) DO
                 FMTDTA     INFILE((&WLIB/&FILE01)) +
                              OUTFILE(&WLIB/&FILE01) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AU#S10) +
                          OPTION(*NOPRT)
                 OVRDBF     FILE(AU#WP10) TOFILE(&WLIB/&FILE01)
                 OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)
                 CALL   AU#R11
                 DLTOVR *ALL
             ENDDO

EXIT:
             ENDPGM
