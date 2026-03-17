/** GDLC1B ************************************************/
/*  Material Order data create for O&K                    */
/*                                                        */
/*  TCHK1  10/14/05 CREATE                                */
/*  JW1    11/01/18 ADD IFS.CSV TRANSFER                  */
/************************************************ GDLC1B **/
PGM
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&SIRE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&REC)  TYPE(*DEC)  LEN(10 0)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&SIRE) VALUE('4511')

             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CLRPFM     FILE(*LIBL/GDOKP01)
             CALL       PGM(GDLR1B)

 /* COUNT RECORD NO. */
             RTVMBRD    FILE(*LIBL/GDOKP01) NBRCURRCD(&REC)
             IF         COND(&REC = 0) THEN(GOTO CMDLBL(END2))

 /*JW1 SAVE ORDER SHEET DATA */
             CPYF       FROMFILE(*LIBL/GDOKP01) +
                          TOFILE(*LIBL/GDOKP01S) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)

 /*JW1 IFS.CSV TRANSFER TO J:¥DOWNLOAD¥AS400¥OUTSRC */
             CALL       PGM(GDLC1G) PARM(&SIRE)
 END2:
             ENDPGM
