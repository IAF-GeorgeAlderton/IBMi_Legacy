/*  ANDROID RE-PRINT PICK UP LIST/PALLETIZED LIST          */
/*   CALLED FROM AN#RG1                                    */
/*                                                         */
/* TCHK1 07/25/06 CREATE(AB#CG1)                           */
/*---------------------------------------------------------*/
             PGM        PARM(&PSIRE &PSIRK &PNOHZ &PREDT &PNOBN +
                          &PDOCK &POPTN &PSHDT)

             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PSIRE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PSIRK) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDOCK) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PNOHZ) TYPE(*DEC) LEN(8 0)
             DCL        VAR(&PREDT) TYPE(*DEC) LEN(8 0)
             DCL        VAR(&PSHDT) TYPE(*DEC) LEN(8 0)
             DCL        VAR(&PNOBN) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&PMANI) TYPE(*CHAR) LEN(11)
             DCL        VAR(&POPTN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PPICK) TYPE(*DEC) LEN(2)
             DCL        VAR(&PCUST) TYPE(*DEC) LEN(2)
             DCL        VAR(&TRAN)   TYPE(*CHAR) LEN(30)
             DCL        VAR(&CTYP)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&PCNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPS#) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&PTYPE) TYPE(*CHAR) LEN(2)

             RTVJOBA    JOB(&WSID) USER(&US)

             CALL       PGM(ALBC00) PARM(&US &WLIB)

             CHGVAR     VAR(&PTYPE) VALUE('01')
             CALL       PGM(AB#R91) PARM(&PSIRE &PTYPE &PPICK &PCUST +
                          &TRAN &CTYP &PCNAM)

  /* PICK UP LIST */
             IF         COND(&POPTN *NE '2') THEN(DO)

             DLTF       FILE(QTEMP/AN#WPF0)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AN#WPF0) RCDLEN(100) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AN#WPF0) TOFILE(QTEMP/AN#WPF0)

  /* CREATE WORK FILE FROM AB#PP10  */
             CALL       PGM(AN#R3H) PARM(&PSIRE &PSIRK &PNOHZ &PREDT +
                          &PNOBN &PDOCK &PMANI)

             IF         (%SWITCH(1XXXXXXX)) DO

             DLTF       FILE(QTEMP/AN#WPFB)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AN#WPFB) RCDLEN(100) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)
             FMTDTA     INFILE((QTEMP/AN#WPF0)) +
                          OUTFILE(QTEMP/AN#WPFB) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AB#S4F) +
                          OPTION(*NOPRT)


             OVRDBF     FILE(AN#WPFB) TOFILE(QTEMP/AN#WPFB)

             IF         COND(&PPICK *EQ 0) THEN(CHGVAR VAR(&PPICK) +
                          VALUE(1))
             IF         COND(&US *EQ 'TEST') THEN(DO)
             OVRPRTF    FILE(AN#PR3I) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) RPLUNPRT(*YES) OUTQ(QDKT) +
                          FORMTYPE(K6S1) COPIES(&PPICK)
             ENDDO

             IF         COND(&US *NE 'TEST') THEN(DO)
             OVRPRTF    FILE(AN#PR3I) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) RPLUNPRT(*YES) OUTQ(LANPRT02) +
                          FORMTYPE(K6S1) COPIES(&PPICK)
             ENDDO

             CALL       PGM(AN#R3I) PARM(&PSIRE &PREDT &PPS# &PMANI +
                          &PSHDT)
             DLTOVR     FILE(*ALL)

             ENDDO
             ENDDO

/* PALLETIZED LIST */
             IF         COND(&POPTN *NE '1') THEN(DO)

             IF         COND(&US *EQ 'TEST') THEN(DO)
             OVRPRTF    FILE(AN#PRF8) PAGESIZE(66 80) LPI(6) +
                          OVRFLW(62) RPLUNPRT(*YES) OUTQ(QDKT) +
                          FORMTYPE(K6S1) COPIES(1)
             ENDDO

             IF         COND(&US *NE 'TEST') THEN(DO)
             OVRPRTF    FILE(AN#PRF8) PAGESIZE(66 80) LPI(6) +
                          OVRFLW(62) RPLUNPRT(*YES) OUTQ(LANPRT02) +
                          FORMTYPE(K6S1) COPIES(1)
             ENDDO

             CALL       PGM(AN#RG3) PARM(&PSIRE &PDOCK &PNOHZ &PNOBN +
                          &PREDT)
             CALL       PGM(AN#RF8) PARM(&PSIRE &PDOCK &PNOHZ &PNOBN +
                          &PREDT &PPS# &PMANI)
             DLTOVR     FILE(*ALL)

             ENDDO


             ENDPGM
