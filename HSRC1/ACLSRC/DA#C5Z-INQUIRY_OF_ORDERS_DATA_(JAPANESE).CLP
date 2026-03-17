             PGM
             /** DA#C5Z *********************************/
             /*     ...ﾆﾞﾏkﾏcmﾞ-j ﾆﾑcfb  &  ﾃcﾆ]...     */
             /*     MSK 2004.07.28                      */
             /*************************** COPY DA#C50 ***/
             DCLF       FILE(DA#PW5Z)
             DCL        VAR(&PC) TYPE(*CHAR) LEN(1)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USS) TYPE(*CHAR) LEN(2)
             DCL        VAR(&US5) TYPE(*CHAR) LEN(5)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&FILE04) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILEB4) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILEC4) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE05) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE06) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE08) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE09) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE10) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE11) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILEG) TYPE(*CHAR) LEN(9)
             DCL        VAR(&PBRNK) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PSYS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&TANT) TYPE(*CHAR) LEN(4)

      /* 2002.11.27 MSK */
             DCL        VAR(&FILEH5) TYPE(*CHAR) LEN(9)
             DCL        VAR(&KBN)    TYPE(*CHAR) LEN(1)
      /* 2002.12.11 MSK */
             DCL        VAR(&FILE12) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE13) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE14) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE15) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE16) TYPE(*CHAR) LEN(9)
             DCL        VAR(&LSTSW) TYPE(*CHAR) LEN(1)

             RTVNETA    SYSNAME(&PSYS)
             RTVJOBA    JOB(&WS) USER(&US)
             CHGVAR     VAR(&WT) VALUE(%SST(&WS 1 2))
             CHGVAR     VAR(&USS) VALUE(%SST(&US 1 2))
             CHGVAR     VAR(&US5) VALUE(%SST(&US 1 5))

          /*--------------------------------------------------*/
          /*    メニュー選択                                */
          /*--------------------------------------------------*/
  SCR:
             SNDRCVF    DEV(&WS)   RCDFMT(DA#PW5Z1)

             IF         (&IN01 *EQ '1') DO
             CHGVAR     VAR(&PC)   VALUE('1')
             GOTO END
             ENDDO

             CHGVAR     VAR(&@ERR) +
                          VALUE('　　　　　　　　　　　　　　　　　+
                          　')
             CHGVAR     VAR(&IN11) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&@NO   *EQ '1') GOTO SHR1
             IF         (&@NO   *EQ '2') GOTO SHR1

             CHGVAR     VAR(&IN11) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&@ERR) +
                          VALUE('メニュー選択番号が正しくありません+
                          。')
             GOTO SCR
 SHR1:
      /* 2002.11.27 MSK */

             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)

  /*      受注データ変更                                          */
         /*--------------------------------------------------------*/
         /*  各照会ＰＧＭ実行                                    */
         /*--------------------------------------------------------*/
             CHGVAR     VAR(&PC)   VALUE(' ')
             IF         (&@NO   *EQ '1') DO
             CALL       PGM(DA#R5A) PARM(&PC &LSTSW)
             ENDDO
             IF         (&@NO   *EQ '2') DO
             CALL       PGM(DA#R5B) PARM(&PC &LSTSW)
             ENDDO

END:
             DLTOVR     FILE(*ALL)
             CHGVAR     VAR(&@NO) VALUE(' ')
             IF (&PC  *EQ '3') GOTO SCR
             ENDPGM
