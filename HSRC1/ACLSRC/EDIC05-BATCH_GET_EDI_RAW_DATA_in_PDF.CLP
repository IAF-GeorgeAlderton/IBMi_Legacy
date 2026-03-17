             PGM        PARM(&TYP &BATCH &RTN)
             /** EDIC05 ************************************/
             /*  GET EDI RAW DATA IN PDF                   */
             /* J.WATANABE   2023.010.17                   */
             /* COMPILE:     NEED LIBRARY G3X1PGM         */
             /**********************************************/
             DCL        VAR(&TYP)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&BATCH) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PSIRE) TYPE(*CHAR) LEN(4) VALUE('RAW ')
             DCL        VAR(&RTN)   TYPE(*CHAR) LEN(1) VALUE(' ')

 /* PRINT EDI */
             CALL       EDIC04 (&TYP &BATCH &RTN)
             IF         COND(&RTN *NE ' ') THEN(DO)
             GOTO       CMDLBL(ENDP)
             ENDDO

/* DOWNLOAD TO PDF */
            CALL       PGM(SPLC20) PARM('FORD EDI862' &PSIRE +
                         'QPRINT' 'Y')

ENDP:
             ENDPGM
