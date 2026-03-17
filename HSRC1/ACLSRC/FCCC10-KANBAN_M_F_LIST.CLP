             PGM
             /** FCCC10 ************************************/
             /* KANBAN M/F LIST                            */
             /*                                            */
             /*  DATE (CODING):K.OKACHI        1997.10.16  */
             /*                                            */
             /*  ADD SORTING OPTION                        */
             /*          08/13/01  (TCH)                   */
             /************************************ FCCC10 **/
             DCL        VAR(&REC) TYPE(*DEC)  LEN(10 0)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PM) TYPE(*CHAR) LEN(2)
             DCL        VAR(&ABADS1) TYPE(*CHAR) LEN(48)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ENDID) TYPE(*CHAR) LEN(1)


             RTVJOBA    JOB(&WSID)
             RTVDTAARA  DTAARA(ABADS1) RTNVAR(&ABADS1)
             CHGVAR     VAR(&PM) VALUE(%SST(&ABADS1 5 2))
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             DLTF       FILE(HWFILE1/FCCWP10)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/FCCWP10) RCDLEN(128) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)
             CALL       PGM(FCCR10) PARM(&PM &OPTN &ENDID)
             IF         COND(&ENDID *EQ '1') THEN(GOTO CMDLBL(SKIP))
             DLTF       FILE(HWFILE1/FCCWP11)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/FCCWP11) RCDLEN(128) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             IF         COND(&OPTN *EQ '1') THEN(DO)
             FMTDTA     INFILE((HWFILE1/FCCWP10)) +
                          OUTFILE(HWFILE1/FCCWP11) SRCFILE(FMTSRC) +
                          SRCMBR(FCCS10) OPTION(*NOPRT)
             ENDDO

             IF         COND(&OPTN *EQ '2') THEN(DO)
             FMTDTA     INFILE((HWFILE1/FCCWP10)) +
                          OUTFILE(HWFILE1/FCCWP11) SRCFILE(FMTSRC) +
                          SRCMBR(FCCS11) OPTION(*NOPRT)
             ENDDO

             IF         COND(&OPTN *EQ '3') THEN(DO)
             FMTDTA     INFILE((HWFILE1/FCCWP10)) +
                          OUTFILE(HWFILE1/FCCWP11) SRCFILE(FMTSRC) +
                          SRCMBR(FCCS12) OPTION(*NOPRT)
             ENDDO

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          OVRFLW(62) RPLUNPRT(*YES) OUTQ(&PRTG) +
                          FORMTYPE(K6H1) IGCDTA(&PIGCD)

             IF         COND(&OPTN *EQ '1') THEN(CALL PGM(FCCR11))

             IF         COND(&OPTN *EQ '2') THEN(CALL PGM(FCCR12))

             IF         COND(&OPTN *EQ '3') THEN(CALL PGM(FCCR13))

             DLTOVR     FILE(*ALL)
  SKIP:
             ENDPGM
