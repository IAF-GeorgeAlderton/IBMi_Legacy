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

             CHGVAR     VAR(&SLCT) VALUE('AFDTAD *EQ ' *CAT &DAT +
                          *CAT ' *AND AFDTAT *GE ''' *CAT &TM1 *CAT +
                          ''' *AND AFDTAT *LE ''' *CAT &TM2 *CAT '''')

             OPNQRYF    FILE((AUDREC)) OPTION(*ALL) QRYSLT(&SLCT)

             CALL       PGM(AB#RE0) PARM(&ID)

             CLOF       OPNID(AUDREC)

             IF         COND(&ID *EQ '1') THEN(DO)
             CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT132A) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)

             OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132A)
             CALL       PGM(AB#RW0)
             DLTOVR     FILE(PRT132)

/*JW*/       DLTSPLF    FILE(QPRINT) JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000)

/* TCHK1     SNDDST     TYPE(*FILE) TOINTNET((CoxA@iafi.com) +
                          (HancockG@iafi.com) (MillerJ@iafi.com) +
                          (TanebeK@iafi.com *CC)) DSTD('ASN/Invoice +
                          rejected') MSG('ASN/Invoice data was +
                          rejected. Please check the attached +
                          list.(AB#C0C).') DOCFILE(HWFILE1/PRT132A) +
                          DOCTYPE(*FFT) SNDFMT(*NOTE) +
                          DOCD('ASN/Invoice rejected') */
             SNDDST     TYPE(*FILE) +
                          TOINTNET((EDIASNorInvoiceRejected@iafi.com)+
                          ) DSTD('ASN/Invoice rejected') MSG('** +
                          ERROR ** ASN/Invoice data was rejected. +
                          Please check the attached +
                          list.(AB#C0C).') DOCFILE(HWFILE1/PRT132A) +
                          DOCTYPE(*FFT) SNDFMT(*NOTE) +
                          DOCD('ASN/Invoice rejected') /* TCHK1 */
             ENDDO
             DLTOVR     FILE(QPRINT)

             ENDPGM
