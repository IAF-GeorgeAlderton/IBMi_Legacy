     /****************************************************************/
     /*     PROGRAM NAME.    :  DIE COMPONENT M/F INQUIRY            */
     /*     PROGRAM ID.      :  WK303C       <CLP>                   */
     /*     CREATE DATE.     :  2020.10.28                           */
     /*     AUTHOR.          :                                       */
     /****************************************************************/
             PGM        PARM(&P1HIN1 &P1HIN2 &P1HIN3 &P1KAT1 &P1KAT2 +
                          &P1KOJO)

             DCL        VAR(&P1HIN1) TYPE(*CHAR) LEN(5)
             DCL        VAR(&P1HIN2) TYPE(*CHAR) LEN(5)
             DCL        VAR(&P1HIN3) TYPE(*CHAR) LEN(2)
             DCL        VAR(&P1KAT1) TYPE(*CHAR) LEN(2)
             DCL        VAR(&P1KAT2) TYPE(*CHAR) LEN(4)
             DCL        VAR(&P1KOJO) TYPE(*CHAR) LEN(1)

 STP1:    /* DIE COMPONENT M/F INQUIRY */
             CALL       PGM(WK303R) PARM(&P1HIN1 &P1HIN2 &P1HIN3 +
                          &P1KAT1 &P1KAT2 &P1KOJO)

 END:        ENDPGM
