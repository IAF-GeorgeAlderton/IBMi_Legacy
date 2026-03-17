             PGM
             /***ABBC7O *******************************************/
             /* PGM   : PRIORITY LIST DATA DOWNLOAD TO CSV        */
             /* OUTPUT: HWFILE1/ABBWP7B                           */
             /* ADD JOB TO FCKC03  (JOB SCHEDULE  07:30 AM)       */
             /* JW    : 2022.06.14                                */
             /*****************************************************/
             DCL        VAR(&TRU ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&DT8 ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&TG8 ) TYPE(*CHAR) LEN(8)

             DCL        VAR(&FDAT)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&FTIM)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&TDAT)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&TTIM)  TYPE(*CHAR) LEN(6)

             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FIL ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIB ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILN) TYPE(*CHAR) LEN(30)
             DCL        VAR(&CSV ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CLM ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSG ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DAT1) TYPE(*CHAR) LEN(6)
             DCL        VAR(&DIR1) TYPE(*CHAR) LEN(100)
             DCL        VAR(&DIR2) TYPE(*CHAR) LEN(100)
             DCL        VAR(&REC)  TYPE(*DEC)  LEN(10 0) VALUE(0)
             DCL        VAR(&NOT1) TYPE(*CHAR) LEN(70)
             DCL        VAR(&NOT2) TYPE(*CHAR) LEN(80)
             DCL        VAR(&SUB1) TYPE(*CHAR) LEN(30)
             DCL        VAR(&SUB2) TYPE(*CHAR) LEN(40)

 /*** TEMP ***/
             GOTO       CMDLBL(ENDP)
 /************/

             CLRPFM     FILE(HWFILE1/ABBWP7B)
             CLRPFM     FILE(HWFILE1/ABBWP7C)

 /* CREATE HWFILE1/ABBWP7B */
             CHGVAR     VAR(&FTIM) VALUE('060000')
             CHGVAR     VAR(&TTIM) VALUE('060000')
    /* GET TODAY */
             CALL       PGM(UTLR01) PARM(' ' &TRU ' ')
             CHGVAR     VAR(&TDAT) VALUE(&TRU)
    /* GET LAST DAY */
             CHGVAR     VAR(&DT8 ) VALUE(&TRU)
             CALL       PGM(UTLR10) PARM(&DT8 '-' '0001' 'N' &TG8 ' ')
             CHGVAR     VAR(&FDAT) VALUE(&TG8)

             CALL       PGM(ABBR7O) PARM(&FDAT &FTIM &TDAT &TTIM)

             CHGVAR     VAR(&NOT1) VALUE('PRIORITY SCAN DATA (FROM:' +
                          *CAT &FDAT *BCAT '6AM' *BCAT ' TO:' *CAT +
                          &TDAT *BCAT '6AM). (ABBC7O)')
             CHGVAR     VAR(&NOT2) VALUE('PRIORITY SCAN DATA NOT +
                          FOUND! (FROM:' *CAT &FDAT *BCAT '6AM' +
                          *BCAT ' TO:' *CAT &TDAT *BCAT '6AM). +
                          (ABBC7O)')
             CHGVAR     VAR(&SUB1) VALUE('PRIORITY SCAN DATA ' *CAT +
                          &TDAT)
             CHGVAR     VAR(&SUB2) VALUE('PRIORITY SCAN DATA NOT +
                          FOUND ' *CAT &TDAT)
 /* CHECK ABBWP7B */
             RTVMBRD    FILE(BACKUP/ABBWP72) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(DO)
             SNDDST     TYPE(*LMSG) +
                          TOINTNET((KAZ.WATANABE@IAFI.COM)) +
                          DSTD(&SUB2) LONGMSG(&NOT2) DOCD('PRIORITY +
                          SCAN DATA NOT FOUND')
             MONMSG     MSGID(CPF0000)

   /**       SNDDST     TYPE(*LMSG) +                                  **/
   /**                    TOINTNET((TATSUO.OGAWA@IAFI.COM)) +          **/
   /**                    DSTD(&SUB2) LONGMSG(&NOT2) DOCD('PRIORITY +  **/
   /**                    SCAN DATA NOT FOUND')                        **/
   /**       MONMSG     MSGID(CPF0000)                                 **/

             GOTO       CMDLBL(ENDP)
               ENDDO

 /* COPY HWFILE1/ABBWP7B --> ABBWP7C */
             CALL       PGM(ABBR7O2)

 /*************/
 /* GOTO ENDP */
 /*************/

 /* CREATE CSV             */
             CHGVAR     VAR(&TYPE) VALUE('2')
             CHGVAR     VAR(&FIL ) VALUE('ABBWP7C')
             CHGVAR     VAR(&LIB ) VALUE('HWFILE1')
             CHGVAR     VAR(&FILN) VALUE('PRIORITY SCAN DATA')
             CHGVAR     VAR(&CSV ) VALUE('C')
             CHGVAR     VAR(&CLM ) VALUE('N')
             CHGVAR     VAR(&MSG ) VALUE('N')

             CALL       PGM(APLC94 ) PARM(&TYPE &FIL &LIB &FILN +
                          &CSV &CLM &MSG)

 /* SEND CSV BY MAIL     */
             CHGVAR     VAR(&DAT1) VALUE(%SST(&TRU 3 6))
             CHGVAR     VAR(&DIR1) +
                          VALUE('/QNTC/IAF-AS400-FILE/AS400-TRANS/PC/+
                          DOWNLOAD/I0777/')
             CHGVAR     VAR(&DIR2) VALUE(&DIR1 *TCAT &FILN *BCAT +
                          &DAT1 *TCAT '.CSV')

             SNDSMTPEMM RCP((KAZ.WATANABE@IAFI.COM)) SUBJECT(&SUB1) +
                          NOTE(&NOT1) ATTACH((&DIR2))
             MONMSG     MSGID(TCP5092)

             SNDSMTPEMM RCP((TATSUO.OGAWA@IAFI.COM)) SUBJECT(&SUB1) +
                          NOTE(&NOT1) ATTACH((&DIR2))
             MONMSG     MSGID(TCP5092)

ENDP:
             ENDPGM
