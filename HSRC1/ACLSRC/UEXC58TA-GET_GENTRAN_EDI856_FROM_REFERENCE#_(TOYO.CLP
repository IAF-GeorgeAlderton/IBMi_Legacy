             PGM        PARM(&PRTN &DAT1 &TIM1 &DAT2 &TIM2 &BCH# &INT#)
     /** UEXC58TA ***********************************************/
     /*  GET GENTRAN INFO FROM REFERENCE# (TOYOTA)              */
     /*  JW     2025.03.25                                      */
     /***********************************************************/
     /*   IN  $PRTN  30A  PARTNER ID                            */
     /*       $RCVD1  8A  RECEIVED DATE                         */
     /*       $RCVT1  4A  RECEIVED TIME (4 DIGITS)              */
     /*   OUT $RCVD2  8A  RECEIVED DATE                         */
     /*       $RCVT2  6A  RECEIVED TIME                         */
     /*       $BCH#   7A  BATCH#                                */
     /*       $INT#  14A  INTERCHANGE#                          */
     /***********************************************************/

             DCL        VAR(&PRTN) TYPE(*CHAR) LEN(30)
             DCL        VAR(&DAT1) TYPE(*CHAR) LEN(08)
             DCL        VAR(&TIM1) TYPE(*CHAR) LEN(04)
             DCL        VAR(&DAT2) TYPE(*CHAR) LEN(08)
             DCL        VAR(&TIM2) TYPE(*CHAR) LEN(06)
             DCL        VAR(&BCH#) TYPE(*CHAR) LEN(07)
             DCL        VAR(&INT#) TYPE(*CHAR) LEN(14)

             OVRDBF     FILE(AUDREC98) TOFILE(G3X6DTA/AUDREC98)

    CALL PGM(UEXR58TA) PARM(&PRTN &DAT1 &TIM1 &DAT2 &TIM2 &BCH# &INT#)

             DLTOVR     FILE(*ALL)

             ENDPGM
