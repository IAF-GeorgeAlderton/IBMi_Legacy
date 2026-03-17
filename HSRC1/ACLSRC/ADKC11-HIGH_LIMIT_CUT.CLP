             PGM        PARM(&HHMM &FIL7)
             /*** ADKC11 ***********************************/
             /*上限カット                                */
             /*     KATOGI.        2015.12.21              */
             /**********************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&FLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&DDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&HHMM) TYPE(*CHAR) LEN(4)
             DCL        VAR(&FIL7) TYPE(*CHAR) LEN(8)
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
             CLRPFM     FILE(ADKWP11)
             OVRDBF     FILE(ADKWP10) TOFILE(&FIL7)
             CALL       PGM(ADKR12) PARM(&HHMM)

       /*    CPYF       FROMFILE(HWFILE1/ADKWP11) +                */
       /*                 TOFILE(KATOGI/ADKWP11) MBROPT(*ADD) +    */
       /*                 CRTFILE(*YES)                            */

          /*便当りの上限箱数*/
             CALL       PGM(ADKR43) PARM(&HHMM)

          /*上限カットした数量を計算する*/
             CLRPFM     FILE(ADKWP12)
             CALL       PGM(ADKR13)

          /*上限カットした数量でＡＧＡＰＰ３１更新*/
             CALL       PGM(ADKR14)

          /*上限カットした数量をＡＵ＃ＰＰ１１へ戻す  */
             CALL       PGM(ADKR17)

          /*生産指示処理実績作成　ＡＤＫＰＰ２１  */
             CALL       PGM(ADKR15)

          /*処理履歴出力する        */
          /*ＡＤＫＰＰ００*/
             CALL       PGM(ADKR10) PARM(&HHMM)
 END:
             ENDPGM
