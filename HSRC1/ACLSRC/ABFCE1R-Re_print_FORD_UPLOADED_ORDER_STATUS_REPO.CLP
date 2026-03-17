             PGM        PARM(&SDAT &PDAT)
/** ABFCE1R ***********************************************/
/*  RE-PRINT FORD UPLOADED VS ORIGINAL ORDER REPORT       */
/*  JW    2023.02.22                                      */
/**********************************************************/
             DCL        VAR(&SDAT) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PDAT) TYPE(*CHAR) LEN(8)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)

             DCL        VAR(&DT1 ) TYPE(*CHAR) LEN(08)
             DCL        VAR(&YMD ) TYPE(*CHAR) LEN(03)
             DCL        VAR(&SEP ) TYPE(*CHAR) LEN(01)
             DCL        VAR(&DT2 ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SHP ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DSC1) TYPE(*CHAR) LEN(78)
             DCL        VAR(&DSC2) TYPE(*CHAR) LEN(09)
             DCL        VAR(&DSC3) TYPE(*CHAR) LEN(40)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

/* SET DESCRIPTION */
             CHGVAR     VAR(&DT1) VALUE(&SDAT)
             CHGVAR     VAR(&YMD) VALUE('YMD')
             CHGVAR     VAR(&SEP) VALUE('/')
             CALL       PGM(EDTR01A) PARM(&DT1 &YMD &SEP &DT2)
             CHGVAR     VAR(&SHP) VALUE(&DT2)
             CHGVAR     VAR(&DSC1) VALUE('(DAILY REPORT) FORD UPLOAD +
                          VS ORIGINAL EDI ORDER COMPARISON REPORT. +
                          (SHIP DATE')
             CHGVAR     VAR(&DSC2) VALUE('). ABFCE1.')

             CHGVAR     VAR(&DSC3) VALUE('FORD ORDER STATUS')

/* CREATE WORK FILE */
             CLRPFM     FILE(ABFWPE1)
             CALL       PGM(ABFRE1) PARM(&SDAT &PDAT)

/* PRINT */
             OVRPRTF    FILE(QPRINT5) PAGESIZE(*N 198) CPI(15) +
                          OUTQ(QPRINT5) FORMTYPE(K6H1)
             CALL       PGM(ABFRE2R) PARM(&SDAT)

/*SEND REPORT */
             CRTDUPOBJ  OBJ(PRT198 ) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/PRT198 )
             CPYSPLF    FILE(QPRINT5) TOFILE(QTEMP/PRT198 ) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT198) TOFILE(QTEMP/PRT198 )
             CALL       PGM(AB#RW1)

             SNDDST     TYPE(*FILE) +
                          TOINTNET((kaz.watanabe@iafi.com)) +
                          DSTD('FORD ORDER STATUS') MSG(&DSC1 *BCAT +
                          &SHP *CAT &DSC2) DOCFILE(QTEMP/PRT198) +
                          DOCTYPE(*FFT) SNDFMT(*NOCHG) DOCD('FORD +
                          ORDER STATUS')

     /**     SNDDST     TYPE(*FILE) +                                   **/
     /**                  TOINTNET((Lisa.Thrasher@iafi.com) +           **/
     /**                  (Amanda.Morrison@iafi.com) +                  **/
     /**                  (Holly.Tanner@iafi.com) +                     **/
     /**                  (jonathon.julson@iafi.com) +                  **/
     /**                  (ProductionControl@iafi.com)) DSTD('FORD +    **/
     /**                  ORDER STATUS') MSG(&DSC1 *BCAT &SHP *CAT +    **/
     /**                  &DSC2) DOCFILE(QTEMP/PRT198) +                **/
     /**                  DOCTYPE(*FFT) SNDFMT(*NOCHG) DOCD('FORD +     **/
     /**                  ORDER STATUS')                                **/

             DLTOVR     FILE(*ALL)

             ENDPGM
