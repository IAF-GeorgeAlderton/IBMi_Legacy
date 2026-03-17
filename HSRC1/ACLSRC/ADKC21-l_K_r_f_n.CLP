             PGM        PARM(&HHMM &FIL7)
             /*** ADKC21 ***********************************/
             /*つるべ生産指示   上限カット　　　　     */
             /*   2020.07.14                               */
             /**********************************************/
             DCL        VAR(&HHMM)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&FIL7)   TYPE(*CHAR) LEN(8)

             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DDATE)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3)    TYPE(*CHAR) LEN(3)
             DCL        VAR(&FLIB)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)   TYPE(*CHAR) LEN(8)


             RTVJOBA    JOB(&WSID) USER(&PPUSER) DATE(&DDATE)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO

             CHGJOB     OUTQ(&PRTG)
 #STP10:

        /*------------------------------*/
        /*上限カット処理              */
        /*------------------------------*/
          /*今回数量に端数を加える*/
             CLRPFM     FILE(ADKWP21)
             OVRDBF     FILE(ADKWP20) TOFILE(&FIL7)
             CALL       PGM(ADKR22) PARM(&HHMM)


          /*便当りの上限箱数*/
             CALL       PGM(ADKR4A) PARM(&HHMM)

          /*上限カットした数量を計算する*/
             CLRPFM     FILE(ADKWP22)
             CALL       PGM(ADKR23)

          /*上限カットした数量でＡＧＡＰＰ４１更新*/
             CALL       PGM(ADKR24)

          /*上限カットした数量をＡＵ＃ＰＰ９１へ戻す  */
             CALL       PGM(ADKR27)

          /*生産指示処理実績作成　ＡＤＫＰＰ２５  */
             CALL       PGM(ADKR25)

          /*処理履歴出力する        */
          /*ＡＤＫＰＰ０５*/
             CALL       PGM(ADKR20) PARM(&HHMM)
 END:
             ENDPGM
