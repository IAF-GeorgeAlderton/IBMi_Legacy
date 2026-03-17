             PGM        PARM(&BATCH)
             /** ABFC21 *********************************************/
             /*  DOWNLOAD FORD RAW EDI862 DATA TO CSV BY BATCH#     */
             /*  JW       2023.11.01                                */
             /*******************************************************/
             DCL        VAR(&TYP  ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&BATCH) TYPE(*CHAR) LEN(7)
             DCL        VAR(&RTN  ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SPLF ) TYPE(*CHAR) LEN(10)

             DCL        VAR(&JOB  ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USR  ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR  ) TYPE(*CHAR) LEN(6)
             DCL        VAR(&FIL  ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FL#  ) TYPE(*CHAR) LEN(6)
             DCL        VAR(&OUT  ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&EDT  ) TYPE(*CHAR) LEN(1)

/* PRINT EDI RAW DATA TO QPRINT */
             CHGVAR     VAR(&TYP) VALUE('I')
             CALL       PGM(EDIC04) PARM(&TYP &BATCH &RTN)

/* COPY LATEST SPOOL TO TXT132  */
             CALL       PGM(UTLC71B)

/* GET JOB/USR/NBR */
             OVRDBF     FILE(TXT132) TOFILE(QTEMP/TXT132)
             CALL       PGM(UTLR71B) PARM(&JOB &USR &NBR &FIL &FL#)

/* DOWNLOAD           */
             CHGVAR     VAR(&OUT) VALUE('1')
             CHGVAR     VAR(&EDT) VALUE('Y')
             CALL       PGM(SPLC02) PARM(&JOB &USR &NBR &FIL &FL# +
                          &OUT &EDT 'Y')

             DLTOVR     FILE(*ALL)

 ENDP:       ENDPGM
