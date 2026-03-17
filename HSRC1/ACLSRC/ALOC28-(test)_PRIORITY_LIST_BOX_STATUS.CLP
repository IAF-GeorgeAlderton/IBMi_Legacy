/** ALOC28 ************************************************/
/*  PRIORITY LIST BOX STATUS                              */
/**********************************************************/
             PGM        PARM(&P01 &P02 &P03)
             DCL        VAR(&P01) TYPE(*CHAR) LEN(5)
             DCL        VAR(&P02) TYPE(*CHAR) LEN(5)
             DCL        VAR(&P03) TYPE(*CHAR) LEN(2)
             DCL        VAR(&P04) TYPE(*DEC)  LEN(04 0) VALUE(0)
             DCL        VAR(&P05) TYPE(*DEC ) LEN(04 0) VALUE(0)
             DCL        VAR(&P06) TYPE(*DEC ) LEN(04 0) VALUE(0)
             DCL        VAR(&P07) TYPE(*DEC ) LEN(04 0) VALUE(0)
             DCL        VAR(&P08) TYPE(*DEC ) LEN(04 0) VALUE(0)
             DCL        VAR(&P09) TYPE(*DEC ) LEN(04 0) VALUE(0)
             DCL        VAR(&P10) TYPE(*DEC ) LEN(04 0) VALUE(0)
             DCL        VAR(&P11) TYPE(*DEC ) LEN(04 0) VALUE(0)
             DCL        VAR(&P12) TYPE(*DEC ) LEN(04 0) VALUE(0)
             DCL        VAR(&P13) TYPE(*DEC ) LEN(04 0) VALUE(0)
             DCL        VAR(&P14) TYPE(*DEC ) LEN(04 0) VALUE(0)
             DCL        VAR(&P15) TYPE(*DEC ) LEN(04 0) VALUE(0)
             DCL        VAR(&P16) TYPE(*DEC ) LEN(04 0) VALUE(0)
             DCL        VAR(&P17) TYPE(*DEC ) LEN(04 0) VALUE(0)
             DCL        VAR(&P18) TYPE(*DEC ) LEN(04 0) VALUE(0)
             DCL        VAR(&P19) TYPE(*DEC ) LEN(04 0) VALUE(0)
             DCL        VAR(&P20) TYPE(*DEC ) LEN(04 0) VALUE(0)
             DCL        VAR(&P21) TYPE(*DEC ) LEN(04 0) VALUE(0)
             DCL        VAR(&P22) TYPE(*DEC ) LEN(04 0) VALUE(0)
             DCL        VAR(&P23) TYPE(*DEC ) LEN(04 0) VALUE(0)
             DCL        VAR(&P24) TYPE(*DEC ) LEN(04 0) VALUE(0)
             DCL        VAR(&P25) TYPE(*DEC ) LEN(04 0) VALUE(0)
             DCL        VAR(&P26) TYPE(*DEC ) LEN(04 0) VALUE(0)
             DCL        VAR(&P27) TYPE(*DEC ) LEN(04 0) VALUE(0)
             DCL        VAR(&P28) TYPE(*DEC ) LEN(04 0) VALUE(0)
             DCL        VAR(&P29) TYPE(*DEC ) LEN(08 0) VALUE(0)
             DCL        VAR(&P30) TYPE(*DEC ) LEN(04 0) VALUE(0)

             DCL        VAR(&P31) TYPE(*DEC ) LEN(08 0) VALUE(0)
             DCL        VAR(&P32) TYPE(*DEC ) LEN(04 0) VALUE(0)

             CALL       PGM(ALOR28T) PARM(&P01 &P02 &P03 &P04 &P05 +
                          &P06 &P07 &P08 &P09 &P10 &P11 &P12 &P13 +
                          &P14 &P15 &P16 &P17 &P18 &P19 &P20 &P21 +
                          &P22 &P23 &P24 &P25 &P26 &P27 &P28 &P29 +
                          &P30 &P31 &P32)

  /* SRT=P07  JC,B=P16  JC,A=P10 + P14  BZ,B=P17  BZ,A=P09 + P13  */
  /*                                    DS,B=P18  DS,A=P11 + P15  */

 ENDPGM
