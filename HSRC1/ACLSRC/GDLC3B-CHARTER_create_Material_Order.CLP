/** GDLC3B ************************************************/
/*  CREATE MATERIAL ORDER FOR CHARTER STEEL (4540)        */
/*  (COPIED FROM GDLC2B)                                  */
/*  J.WATANABE  2020.09.09                                */
/**********************************************************/
PGM
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&SIRE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&REC) TYPE(*DEC)   LEN(10 0)

             RTVJOBA    JOB(&WSID) USER(&USER)
         /***CHGVAR     VAR(&SIRE) VALUE('4530')  ***/
             CHGVAR     VAR(&SIRE) VALUE('4540')

             CALL       PGM(ALBC00) PARM(&USER &WLIB)

         /***CLRPFM     FILE(GDOKP01)       ***/
         /***CLRPFM     FILE(*LIBL/GDOKP02) ***/
             CLRPFM     FILE(*LIBL/GDOKP03)

         /***CALL       PGM(GDLR2B)         ***/
             CALL       PGM(GDLR3B)

 /* COUNT RECORD NO. */
             RTVMBRD    FILE(*LIBL/GDOKP03) NBRCURRCD(&REC)
             IF         COND(&REC = 0) THEN(GOTO CMDLBL(END2))

 /*JW1 SAVE ORDER SHEET DATA */
             CPYF       FROMFILE(*LIBL/GDOKP03) +
                          TOFILE(*LIBL/GDOKP03S) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)

 /*JW1 IFS.CSV TRANSFER TO J:¥DOWNLOAD¥AS400¥OUTSRC */
             CALL       PGM(GDLC1G) PARM(&SIRE)

 END2:
             ENDPGM
