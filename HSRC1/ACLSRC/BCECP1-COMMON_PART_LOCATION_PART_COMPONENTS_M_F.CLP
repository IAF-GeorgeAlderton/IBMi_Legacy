             PGM
             /** BCECP1 *****************************************/
             /* ..COMMON PART.LOCATION.PART.COMPONENTS M/F.FOR END OF MONTH */
             /* PRIORITY                                        */
             /*             K6H1.......1                        */
             /*             K6H3.......2                        */
             /*             K6S1.......3                        */
             /*             K6S3.......4                        */
             /*            KOHHY.           90.04.26            */
             /***************************************** BCECP1 **/
             DCLF       FILE(FCEPW70)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBNO) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PS1) TYPE(*DEC) LEN(2) VALUE(0)
             DCL        VAR(&PSM1) TYPE(*DEC) LEN(2) VALUE(0)
             CHGVAR     VAR(&FTHI) VALUE('G')
             RTVJOBA    JOB(&WS) USER(&US) NBR(&JOBNO)
             CHGJOB     RUNPTY(40) SWS(00000000)

             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)
             CALL       PGM(AGAR01) PARM(&WS &PDEVT &PIGCD)

 BTP1:       SNDRCVF    DEV(&WS) RCDFMT(FCEPW701)
             IF         (&IN01 *EQ '1') RETURN
             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&FS1 *EQ 0) GOTO BTP2
             IF         (&FTHI *EQ 'G') GOTO BTP2
             IF         (&FTHI *EQ 'Z') GOTO BTP2
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT EITHER OF SHIPPING +
                          ORDER INSTRUCTION (G.Z)')
             GOTO       BTP1

 BTP2:       IF         (&IN05 *EQ '1') GOTO BTP3
             GOTO       BTP1

 BTP3:       CLRPFM     FILE(FCEWP24)
             IF         (&FS1 *EQ 0) GOTO STP1
             CHGJOB     JOB(&JOBNO/&US/&WS) OUTPTY(5)
             CHGVAR     VAR(&PS1) VALUE(&FS1)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) LPI(6) RPLUNPRT(*YES) OUTQ(&PRTG) +
                          FORMTYPE(K6H1) COPIES(&PS1) +
                          SCHEDULE(*JOBEND) IGCDTA(&PIGCD)
             CALL       PGM(FCER11) PARM(&FTHI)
             DLTOVR     FILE(QPRINT)

 STP1:       IF         (&FS6 *EQ 0) GOTO STP3
             CHGJOB     JOB(&JOBNO/&US/&WS) OUTPTY(5)
             CHGVAR     VAR(&PS1) VALUE(&FS6)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) LPI(6) RPLUNPRT(*YES) OUTQ(&PRTG) +
                          FORMTYPE(K6H1) COPIES(&PS1) +
                          SCHEDULE(*JOBEND) IGCDTA(&PIGCD)
             CALL       PGM(FCER16)
             DLTOVR     FILE(QPRINT)

 STP3:       IF         (&FS5 *EQ 0) GOTO STP7
             CHGJOB     JOB(&JOBNO/&US/&WS) OUTPTY(5)
             CHGVAR     VAR(&PS1) VALUE(&FS5)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) LPI(6) RPLUNPRT(*YES) OUTQ(&PRTG) +
                          FORMTYPE(K6H1) COPIES(&PS1) +
                          SCHEDULE(*JOBEND) IGCDTA(&PIGCD)
             CALL       PGM(FCER41)
             DLTOVR     FILE(QPRINT)

STP7:        IF         (&FS2 *EQ 0) GOTO STP11
             CALL       PGM(FCER24)
             CHGJOB     JOB(&JOBNO/&US/&WS) OUTPTY(5)
             CHGVAR     VAR(&PS1) VALUE(&FS2)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 80) +
                          LPI(6) RPLUNPRT(*YES) OUTQ(&PRTG) +
                          FORMTYPE(K6S1) COPIES(&PS1) +
                          SCHEDULE(*JOBEND) IGCDTA(&PIGCD)
             CALL       PGM(BCER25) PARM(&FHAK)
             DLTOVR     FILE(QPRINT)
             CLRPFM     FILE(FCEWP24)

 STP11:      IF         (&FS4 *EQ 0) GOTO STP14
             CHGJOB     SWS(10000000)
             CHGJOB     JOB(&JOBNO/&US/&WS) OUTPTY(5)
             CHGVAR     VAR(&PS1) VALUE(&FS4)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 80) +
                          LPI(6) RPLUNPRT(*YES) OUTQ(&PRTG) +
                          FORMTYPE(K6S1) COPIES(&PS1) +
                          SCHEDULE(*JOBEND) IGCDTA(&PIGCD)
             CALL       PGM(BCER27)
             DLTOVR     FILE(QPRINT)

 STP14:      IF         (&FS3  *EQ 0) GOTO END
             CHGJOB     SWS(00000000)
             CHGJOB     JOB(&JOBNO/&US/&WS) OUTPTY(5)
             CHGVAR     VAR(&PS1) VALUE(&FS3)

             CHGVAR     VAR(&PSM1) VALUE(&PS1)
             IF         (&PS1 *GT 01) CHGVAR VAR(&PSM1) VALUE(&PSM1-1)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 80) +
                          LPI(6) RPLUNPRT(*YES) OUTQ(&PRTG) +
                          FORMTYPE(K6S1) COPIES(&PSM1) +
                          SCHEDULE(*JOBEND) IGCDTA(&PIGCD)
             CALL       PGM(BCER28) PARM('     ')
             DLTOVR     FILE(QPRINT)

             IF         (&PS1 *GT 01) DO
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 80) +
                          LPI(6) RPLUNPRT(*YES) OUTQ(&PRTG) +
                          FORMTYPE(K6S1) COPIES(1) +
                          SCHEDULE(*JOBEND) IGCDTA(&PIGCD)
             CALL       PGM(BCER28) PARM('90041')
             DLTOVR     FILE(QPRINT)
             ENDDO

 END:        CHGJOB     RUNPTY(20)
             SIGNOFF

             ENDPGM
