             PGM        PARM(&SDAT &PDAT)
/** ABFCE3 ************************************************/
/*  FORD 5 DAYS EDI ORDERS                                */
/*  JW    2022.07.07                                      */
/**********************************************************/
             DCL        VAR(&SDAT) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PDAT) TYPE(*CHAR) LEN(8)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&FNAM) TYPE(*CHAR) LEN(30)

             DCL        VAR(&DT1 ) TYPE(*CHAR) LEN(08)
             DCL        VAR(&YMD ) TYPE(*CHAR) LEN(03)
             DCL        VAR(&SEP ) TYPE(*CHAR) LEN(01)
             DCL        VAR(&DT2 ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SHP ) TYPE(*CHAR) LEN(10)

             DCL        VAR(&TRU )  TYPE(*CHAR) LEN(8)
             DCL        VAR(&FILN) TYPE(*CHAR) LEN(30)
             DCL        VAR(&DAT1) TYPE(*CHAR) LEN(6)
             DCL        VAR(&DIR1) TYPE(*CHAR) LEN(100)
             DCL        VAR(&DIR2) TYPE(*CHAR) LEN(100)
             DCL        VAR(&NOT1) TYPE(*CHAR) LEN(70)
             DCL        VAR(&NOT2) TYPE(*CHAR) LEN(80)
             DCL        VAR(&SUB1) TYPE(*CHAR) LEN(30)
             DCL        VAR(&SUB2) TYPE(*CHAR) LEN(40)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

/* SET DESCRIPTION */
             CHGVAR     VAR(&DT1) VALUE(&PDAT)
             CHGVAR     VAR(&YMD) VALUE('YMD')
             CHGVAR     VAR(&SEP) VALUE('-')
             CALL       PGM(EDTR01A) PARM(&DT1 &YMD &SEP &DT2)
             CHGVAR     VAR(&SHP) VALUE(&DT2)

/* CREATE WORK FILE */
             CLRPFM     FILE(ABFWPE3)
             CALL       PGM(ABFRE3) PARM(&SDAT &PDAT)

/* TEMP      */
/* GOTO ENDP */
/*           */

             CHGVAR     VAR(&FNAM) VALUE('FORD 5 DAYS (' *CAT &SHP +
                          *CAT ')')
             CALL       PGM(APLC94U) PARM('2' 'ABFWPE3' 'HWFILE1' +
                          &FNAM 'Y' ' ' 'N' 'QPGMR' 'N')
 /* SEND CSV BY MAIL     */
             CALL       PGM(UTLR01) PARM(' ' &TRU ' ')
             CHGVAR     VAR(&DAT1) VALUE(%SST(&TRU 3 6))
             CHGVAR     VAR(&NOT1) VALUE('FORD 5 DAYS ORDER' *BCAT +
                          &DAT1 *CAT '.(ABFCE3 )')
             CHGVAR     VAR(&SUB1) VALUE('FORD 5 DAYS ORDER')

             CHGVAR     VAR(&FILN) VALUE(&FNAM)
             CHGVAR     VAR(&DIR1) +
                          VALUE('/QNTC/IAF-AS400-FILE/AS400-TRANS/PC/+
                          DOWNLOAD/QPGMR/')
             CHGVAR     VAR(&DIR2) VALUE(&DIR1 *TCAT &FILN *CAT '.CSV')

     /**     SNDSMTPEMM RCP((JONATHON.JULSON@IAFI.COM) +              **/
     /**                  (ROBERT.STEUER@IAFI.COM)) SUBJECT(&SUB1) +  **/
     /**                  NOTE(&NOT1) ATTACH((&DIR2))                 **/
     /**     MONMSG     MSGID(TCP5092)                                **/


             SNDSMTPEMM RCP((KAZ.WATANABE@IAFI.COM)) SUBJECT(&SUB1) +
                          NOTE(&NOT1) ATTACH((&DIR2))
             MONMSG     MSGID(TCP5092)

ENDP:
             ENDPGM
