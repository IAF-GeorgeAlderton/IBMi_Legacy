/**JW1       PGM   **/
             PGM   PARM(&PSHFT)
             /***ABBC7O3 ******************************************/
             /* PGM   : PRIORITY LIST DATA DOWNLOAD TO CSV        */
             /* OUTPUT: HWFILE1/ABBWP72A                          */
             /* ADD JOB SCHEDULE  06:30AM (CHK.ABBC70)            */
             /*                   02:00PM (CHK.ABBC71)            */
             /* JW    : 2022.06.28                                */
             /* JW1   : 2022.07.21 ADD PARAMETER PSHFT            */
             /*****************************************************/
             DCL        VAR(&PSHFT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TRU )  TYPE(*CHAR) LEN(8)
             DCL        VAR(&TDAT)  TYPE(*CHAR) LEN(8)

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

 /** SET CUST#/DELIV# IN ABAEP20S (HONDA) **/
             CALL       PGM(HOBJ1/CHKR49D)

 /* GET TODAY */
             CALL       PGM(UTLR01) PARM(' ' &TRU ' ')
             CHGVAR     VAR(&TDAT) VALUE(&TRU)
             CALL       PGM(ABBC7J3) PARM(&PSHFT)

             CHGVAR     VAR(&NOT1) VALUE('PRIORITY SCAN DATA' *BCAT +
                          &TDAT *BCAT 'SHIFT:' *BCAT &PSHFT *BCAT +
                          '.(ABBC7O3)')
             CHGVAR     VAR(&NOT2) VALUE('PRIORITY SCAN DATA NOT +
                          FOUND!' *BCAT &TDAT *BCAT 'SHIFT:' *BCAT +
                          &PSHFT *BCAT '. (ABBC7O3)')
             CHGVAR     VAR(&SUB1) VALUE('PRIORITY SCAN DATA ')
             CHGVAR     VAR(&SUB2) VALUE('PRIORITY SCAN DATA NOT +
                          FOUND ')
 /* CHECK ABBWP72 */
             RTVMBRD    FILE(QTEMP/ABBWP72) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(DO)
             SNDDST     TYPE(*LMSG) +
                          TOINTNET((KAZ.WATANABE@IAFI.COM)) +
                          DSTD(&SUB2) LONGMSG(&NOT2) DOCD('PRIORITY +
                          SCAN DATA NOT FOUND')
             MONMSG     MSGID(CPF0000)

             SNDDST     TYPE(*LMSG) +
                          TOINTNET((TATSUO.OGAWA@IAFI.COM)) +
                          DSTD(&SUB2) LONGMSG(&NOT2) DOCD('PRIORITY +
                          SCAN DATA NOT FOUND')
             MONMSG     MSGID(CPF0000)

             GOTO       CMDLBL(ENDP)
               ENDDO

 /* COPY HWFILE1/ABBWP72 --> ABBWP72A  */
             OVRDBF     FILE(ABBWP72 ) TOFILE(QTEMP/ABBWP72 )
             OVRDBF     FILE(ABBWP72A) TOFILE(QTEMP/ABBWP72A)
             CALL       PGM(ABBR7O3) PARM(&PSHFT)

 /*************/
 /* GOTO ENDP */
 /*************/

 /* CREATE CSV             */
             CHGVAR     VAR(&TYPE) VALUE('2')
             CHGVAR     VAR(&FIL ) VALUE('ABBWP72A')
             CHGVAR     VAR(&LIB ) VALUE('QTEMP ')
             CHGVAR     VAR(&FILN) VALUE('PRIORITY SCAN DATA SHIFT-' +
                          *CAT &PSHFT)
             CHGVAR     VAR(&CSV ) VALUE('C')
             CHGVAR     VAR(&CLM ) VALUE('N')
             CHGVAR     VAR(&MSG ) VALUE('N')

             CALL       PGM(APLC94U) PARM(&TYPE &FIL &LIB &FILN +
                          &CSV &CLM &MSG 'QPGMR' 'Y')

 /* SEND CSV BY MAIL     */
             CHGVAR     VAR(&DAT1) VALUE(%SST(&TRU 3 6))
             CHGVAR     VAR(&DIR1) +
                          VALUE('/QNTC/IAF-AS400-FILE/AS400-TRANS/PC/+
                          DOWNLOAD/QPGMR/')
             CHGVAR     VAR(&DIR2) VALUE(&DIR1 *TCAT &FILN *BCAT +
                          &DAT1 *TCAT '.CSV')

       /**   SNDSMTPEMM RCP((KAZ.WATANABE@IAFI.COM)) SUBJECT(&SUB1) +  **/
       /**                NOTE(&NOT1) ATTACH((&DIR2))                  **/
       /**   MONMSG     MSGID(TCP5092)                                 **/

       /**   SNDSMTPEMM RCP((TATSUO.OGAWA@IAFI.COM) +                  **/
       /**                (KAZ.WATANABE@IAFI.COM)) SUBJECT(&SUB1) +    **/
       /**                NOTE(&NOT1) ATTACH((&DIR2))                  **/

             SNDSMTPEMM RCP((TATSUO.OGAWA@IAFI.COM) +
                          (KAZ.WATANABE@IAFI.COM) +
                          (MARCO.ARRESE@IAFI.COM)) SUBJECT(&SUB1) +
                          NOTE(&NOT1) ATTACH((&DIR2))

             MONMSG     MSGID(TCP5092)

ENDP:
             ENDPGM
