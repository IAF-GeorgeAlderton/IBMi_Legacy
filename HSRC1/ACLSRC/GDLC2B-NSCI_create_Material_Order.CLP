/** GDLC2B ************************************************/
/*  CREATE MATERIAL ORDER FOR NSCI(4530)                  */
/*  (COPIED FROM GDLC1B)                                  */
/*  JW     12/22/17 CREATE                                */
/*  JW1    11/01/18 ADD IFS.CSV TRANSFER                  */
/**********************************************************/
PGM
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&SIRE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&REC) TYPE(*DEC)   LEN(10 0)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&SIRE) VALUE('4530')

             CALL       PGM(ALBC00) PARM(&USER &WLIB)

         /***CLRPFM     FILE(GDOKP01)***/
             CLRPFM     FILE(*LIBL/GDOKP02)

             CALL       PGM(GDLR2B)

 /* COUNT RECORD NO. */
             RTVMBRD    FILE(*LIBL/GDOKP02) NBRCURRCD(&REC)
             IF         COND(&REC = 0) THEN(GOTO CMDLBL(END2))

 /*JW1 SAVE ORDER SHEET DATA */
             CPYF       FROMFILE(*LIBL/GDOKP02) +
                          TOFILE(*LIBL/GDOKP02S) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)

 /*JW1 IFS.CSV TRANSFER TO J:¥DOWNLOAD¥AS400¥OUTSRC */
             CALL       PGM(GDLC1G) PARM(&SIRE)

 END2:
             ENDPGM
