/**** GDKC20 ****************************************************/
/*      UNIT PRICE MASTER LIST                                  */
/*       GBC                             2000/11/15             */
/****************************************************************/
             PGM
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)

             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE2) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGVAR     VAR(&FILE1) VALUE(GDKWP20 *CAT &WSID)
             CHGVAR     VAR(&FILE2) VALUE(GDKWP21 *CAT &WSID)

 /*  WORK-FILE CRT */
             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE1) RCDLEN(128) +
                          OPTION(*NOLIST *NOSRC) SIZE(10000 5000 5) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE2) RCDLEN(128) +
                          OPTION(*NOLIST *NOSRC) SIZE(10000 5000 5) +
                          LVLCHK(*NO) AUT(*ALL)

 /*  DATA SELECT */
             OVRDBF     FILE(GDKWP20) TOFILE(&FILE1)
             CALL       PGM(GDKR20) PARM(&USER)

             RTVMBRD    FILE(HWFILE1/&FILE1) NBRCURRCD(&REC)

             IF         COND(&REC *EQ 0) THEN(DO)
             DLTF       FILE(&FILE1)
             GOTO       END
             ENDDO

 /*  FMTDTA      */
             FMTDTA     INFILE((HWFILE1/&FILE1)) +
                          OUTFILE(HWFILE1/&FILE2) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(GDKS21) +
                          OPTION(*NOPRT)
             DLTF       FILE(&FILE1)

             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1)
             OVRDBF     FILE(GDKWP21) TOFILE(&FILE2)
             CALL       PGM(GDKR21) PARM(&USER)
             DLTF       FILE(&FILE2)
             DLTOVR     FILE(*ALL)

 END:        ENDPGM
