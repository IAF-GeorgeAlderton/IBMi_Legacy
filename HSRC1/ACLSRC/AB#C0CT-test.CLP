             PGM
             /** AB#C0C **********************************/
             /*    EDI ORDER PROCESSING (GENTRAN)        */
             /*                                          */
             /* TCHK1 08/23/06 CHG SNDDST                */
             /********************************** AB#C0C **/
             DCL        VAR(&ID) TYPE(*CHAR) LEN(1)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&DAT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TM1) TYPE(*CHAR) LEN(4)
             DCL        VAR(&TM2) TYPE(*CHAR) LEN(4)
             DCL        VAR(&SLCT) TYPE(*CHAR) LEN(80)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)
  /* ASN REJECTED */
             OVRPRTF    FILE(QPRINT) OUTQ(SAVEOUTQ) SAVE(*YES)

             CALL       PGM(AB#REA) PARM(&DAT &TM1 &TM2)

             OVRDBF     FILE(AUDREC) TOFILE(AUDREC) +
                          SHARE(*YES)

             CHGVAR     VAR(&DAT) VALUE('1181130')
             CHGVAR     VAR(&TM1) VALUE('1030')
             CHGVAR     VAR(&TM2) VALUE('1040')

             CHGVAR     VAR(&SLCT) VALUE('AFDTAD *EQ ' *CAT &DAT +
                          *CAT ' *AND AFDTAT *GE ''' *CAT &TM1 *CAT +
                          ''' *AND AFDTAT *LE ''' *CAT &TM2 *CAT '''')

             OPNQRYF    FILE((AUDREC)) OPTION(*ALL) QRYSLT(&SLCT)

             CALL       PGM(AB#RE0) PARM(&ID)

             CLOF       OPNID(AUDREC)

             DLTOVR     FILE(QPRINT)

             ENDPGM
