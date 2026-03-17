             PGM        PARM(&POUT)
             /** AAMC8A ***************************************/
             /*かんばん回転日数データ作成（ＣＳＶ送信）     */
             /*    MSK           2012.01.06                   */
             /*************************************************/
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS)    TYPE(*CHAR) LEN(3)
             DCL        VAR(&CMD1) TYPE(*CHAR) LEN(100)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0) VALUE(0)
             DCL        VAR(&POUT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&AAMWP80) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AAMWP81) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AAMWP82) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PMSG) TYPE(*CHAR) LEN(256)
             DCL        VAR(&PKINP) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PKOUT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PIPGMN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PFRMLB) TYPE(*CHAR) LEN(10) +
                          VALUE('HWFILE1   ')
             DCL        VAR(&PTYPE) TYPE(*CHAR) LEN(1) VALUE('1')
             DCL        VAR(&PTODI1) TYPE(*CHAR) LEN(200) +
                          VALUE('C:/AS400/DATA/IAFかんばん回転日数デー+
                          タ番地順.CSV')
             DCL        VAR(&PTODI2) TYPE(*CHAR) LEN(200) +
                          VALUE('C:/AS400/DATA/IAFかんばん回転日数デー+
                          タ品番順.CSV')
             DCL        VAR(&PTODI3) TYPE(*CHAR) LEN(200) +
                          VALUE('C:/AS400/DATA/IAFかんばん回転日数デー+
                          タ合計.CSV')

             DCL        VAR(&PARM3)  TYPE(*CHAR) LEN(8)
             RTVNETA    SYSNAME(&PARM3)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 3))
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&AAMWP80) VALUE('AAMWP80' *CAT &WS)
             CHGVAR     VAR(&AAMWP81) VALUE('AAMWP81' *CAT &WS)
             CHGVAR     VAR(&AAMWP82) VALUE('AAMWP82' *CAT &WS)
STEP00:

       /*出力順の設定*/
             DLTF       FILE(HWFILE1/&AAMWP81)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&AAMWP81) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(AAMWP81) +
                          OPTION(*NOLIST *NOSRC) SIZE(50000 5000 +
                          3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AAMWP80) TOFILE(&AAMWP80)
             OVRDBF     FILE(AAMWP81) TOFILE(&AAMWP81)
             CALL       PGM(AAMR8A) PARM(&POUT)

       /*ＣＳＶの作成*/
             DLTF       FILE(HWFILE1/&AAMWP82)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&AAMWP82) RCDLEN(512) +
                          OPTION(*NOLIST *NOSRC) SIZE(10000 5000 3) +
                          LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AAMWP82) TOFILE(&AAMWP82)
             CALL       PGM(AAMR8B) PARM(&POUT)

       /*ＣＳＶの送信*/
             IF         COND(&POUT *EQ '1') THEN(DO)
             CHGVAR     VAR(&PIPGMN) VALUE('AAMC8A1   ')
             CALL       PGM(APLC98) PARM(&PFRMLB &AAMWP82 &PARM3 +
                          &PTODI1 ' 1')
             ENDDO

             IF         COND(&POUT *EQ '2') THEN(DO)
             CHGVAR     VAR(&PIPGMN) VALUE('AAMC8A2   ')
             CALL       PGM(APLC98) PARM(&PFRMLB &AAMWP82 &PARM3 +
                          &PTODI2 ' 1')
             ENDDO

             IF         COND(&POUT *EQ '3') THEN(DO)
             CHGVAR     VAR(&PIPGMN) VALUE('AAMC8A3   ')
             CALL       PGM(APLC98) PARM(&PFRMLB &AAMWP82 &PARM3 +
                          &PTODI3 ' 1')
             ENDDO

 END:
             ENDPGM
