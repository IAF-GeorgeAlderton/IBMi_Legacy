             PGM        PARM(&PUS &WSRTK &PDAT1 &PDAT2 &PDAT3)
             /** FCQC35 ****************************/
             /*..REFERENCE TO THE DIE SPECIFICATION MASTER..*/
             /*     I-HASADA          94.07.04     */
             /**************************** FCQC35 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PUS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSRTK) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDAT1) TYPE(*CHAR) LEN(256)
             DCL        VAR(&PDAT2) TYPE(*CHAR) LEN(256)
             DCL        VAR(&PDAT3) TYPE(*CHAR) LEN(256)
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE2) TYPE(*CHAR) LEN(9)
             RTVJOBA    JOB(&WSID)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 2))

             CHGVAR     VAR(&FILE1) VALUE('FCQWP36' *CAT &WS)
             CHGVAR     VAR(&FILE2) VALUE('FCQWP35' *CAT &WS)

             CLRPFM     FILE(&FILE2)

             IF         (&WSRTK *EQ ' ') DO

             FMTDTA     INFILE((&FILE1)) OUTFILE(&FILE2) +
                          SRCFILE(FMTSRC) SRCMBR(FCQS35) OPTION(*NOPRT)

             ENDDO
             ELSE       DO

             FMTDTA     INFILE((&FILE1)) OUTFILE(&FILE2) +
                          SRCFILE(FMTSRC) SRCMBR(FCQS36) OPTION(*NOPRT)

             ENDDO

             CLRPFM     FILE(&FILE1)

             IF         ((&WS *EQ 'TF') *OR (&WS *EQ 'TG')) DO

             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1)
             OVRDBF     FILE(FCQWP35) TOFILE(&FILE2)
             CALL       PGM(FCQR40) PARM(&PUS &WSRTK &PDAT1 &PDAT2 +
                          &PDAT3)
             DLTOVR     FILE(*ALL)

             ENDDO
             ELSE       DO

             OVRPRTF    FILE(QPRINT) PAGESIZE(66 198) LPI(6) CPI(15) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1)
             OVRDBF     FILE(FCQWP35) TOFILE(&FILE2)
             CALL       PGM(FCQR35) PARM(&PUS &WSRTK &PDAT1 &PDAT2 +
                          &PDAT3)
             DLTOVR     FILE(*ALL)

             ENDDO

             CLRPFM     FILE(&FILE2)

             ENDPGM
