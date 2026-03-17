/** GDLC4B ************************************************/
/*  CREATE MATERIAL ORDER FOR POSCO (4550)                */
/*  (COPIED FROM GDLC3B)                                  */
/*  J.WATANABE  2020.12.23                                */
/**********************************************************/
PGM
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&SIRE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&REC) TYPE(*DEC)   LEN(10 0)

             RTVJOBA    JOB(&WSID) USER(&USER)

         /***CHGVAR     VAR(&SIRE) VALUE('4530')   ***/
             CHGVAR     VAR(&SIRE) VALUE('4550')

             CALL       PGM(ALBC00) PARM(&USER &WLIB)

         /***CLRPFM     FILE(GDOKP01)       ***/
         /***CLRPFM     FILE(*LIBL/GDOKP02) ***/
         /***CLRPFM     FILE(*LIBL/GDOKP03) ***/
             CLRPFM     FILE(*LIBL/GDOKP04)

         /***CALL       PGM(GDLR2B)         ***/
         /***CALL       PGM(GDLR3B)         ***/
             CALL       PGM(GDLR4B)

 /* COUNT RECORD NO. */
             RTVMBRD    FILE(*LIBL/GDOKP04) NBRCURRCD(&REC)
             IF         COND(&REC = 0) THEN(GOTO CMDLBL(END2))

 /*JW1 SAVE ORDER SHEET DATA */
             CPYF       FROMFILE(*LIBL/GDOKP04) +
                          TOFILE(*LIBL/GDOKP04S) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)

 /*JW1 IFS.CSV TRANSFER TO J:¥DOWNLOAD¥AS400¥OUTSRC */
             CALL       PGM(GDLC1G) PARM(&SIRE)

 END2:
             ENDPGM
