             PGM
             /** AAMC80 ***************************************/
             /*かんばん回転日数データ作成                   */
             /*    MSK           2012.01.06                   */
             /*************************************************/
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WS)    TYPE(*CHAR) LEN(3)
             DCL        VAR(&CMD1) TYPE(*CHAR) LEN(100)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0) VALUE(0)
             DCL        VAR(&PBMON) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PKOTE) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PK1F) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PK1T) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PT1F) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PT1T) TYPE(*CHAR) LEN(2)
             DCL        VAR(&POUT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&AAMWP80) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AAMWP81) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGTXT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&PKINP) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PKOUT) TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 3))
             CHGVAR     VAR(&AAMWP80) VALUE('AAMWP80' *CAT &WS)
             CHGVAR     VAR(&AAMWP81) VALUE('AAMWP81' *CAT &WS)
STEP00:
         /*----------*/
         /*条件指定*/
         /*----------*/
             CALL       PGM(AAMR80) PARM(&PBMON &PKOTE &PK1F &PK1T +
                          &PT1F &PT1T &POUT &PCMD)
             IF         COND(&PCMD *EQ '01') THEN(GOTO CMDLBL(END))

             DLTF       FILE(HWFILE1/&AAMWP80)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&AAMWP80) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(AAMWP80) +
                          OPTION(*NOLIST *NOSRC) SIZE(50000 5000 +
                          3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AAMWP80) TOFILE(&AAMWP80)
STEP10:
         /* ABHPP01 */
             CALL       PGM(AAMR81) PARM(&PBMON &PKOTE &PK1F &PK1T +
                          &PT1F &PT1T &POUT &PCMD)

         /* ADHPP01 */
             CALL       PGM(AAMR82) PARM(&PBMON &PKOTE &PK1F &PK1T +
                          &PT1F &PT1T &POUT &PCMD)

         /* AAFPP01 */
             CALL       PGM(AAMR83) PARM(&PBMON &PKOTE &PK1F &PK1T +
                          &PT1F &PT1T &POUT &PCMD)

         /* AAGPP01 */
             CALL       PGM(AAMR84) PARM(&PBMON &PKOTE &PK1F &PK1T +
                          &PT1F &PT1T &POUT &PCMD)

         /* AAHPP01 */
             CALL       PGM(AAMR85) PARM(&PBMON &PKOTE &PK1F &PK1T +
                          &PT1F &PT1T &POUT &PCMD)

         /* CADPP01 */
             CALL       PGM(AAMR86) PARM(&PBMON &PKOTE &PK1F &PK1T +
                          &PT1F &PT1T &POUT &PCMD)

         /* AAOPP01 */
             CALL       PGM(AAMR87) PARM(&PBMON &PKOTE &PK1F &PK1T +
                          &PT1F &PT1T &POUT &PCMD)

         /* AAYPP01 */
             CALL       PGM(AAMR88) PARM(&PBMON &PKOTE &PK1F &PK1T +
                          &PT1F &PT1T &POUT &PCMD)

         /* AANPP01 */
             CALL       PGM(AAMR89) PARM(&PBMON &PKOTE &PK1F &PK1T +
                          &PT1F &PT1T &POUT &PCMD)

STEP20:
             RTVMBRD    FILE(HWFILE1/&AAMWP80) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(DO)
             CHGVAR     VAR(&MSGTXT) VALUE('THERE ARE NO DATA (G)')
             CHGVAR     VAR(&PKINP) VALUE('G    ')
             CHGVAR     VAR(&PKOUT) VALUE(' ')
             CALL       PGM(APLR90) PARM(&MSGTXT &PKINP &WSID &PKOUT)
             IF         COND(&PKOUT *EQ 'G') THEN(GOTO CMDLBL(END))
             ENDDO
STEP30:
         /*履歴作成*/
             CALL       PGM(AAMR8C) PARM(&PBMON &PKOTE &PK1F &PK1T +
                          &PT1F &PT1T &POUT &PCMD)
STEP40:
         /*ＣＳＶ作成*/
             OVRDBF     FILE(AAMWP80) TOFILE(&AAMWP80)
             OVRDBF     FILE(AAMWP81) TOFILE(&AAMWP81)
             CALL       PGM(AAMC8A) PARM(&POUT)

 END:
             ENDPGM
