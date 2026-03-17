             PGM        PARM(&PRTN &DAT1 &TIM1 &DAT2 &TIM2 &STT)
     /** UEXC58TC ***********************************************/
     /*  GET GENTRAN 856 STATUS FROM ACKNOWLEDGEMENT            */
     /*  JW     2025.03.25                                      */
     /***********************************************************/
     /*   IN  $PRTN  30A  PARTNER ID                            */
     /*       $RCVD1  8A  RECEIVED DATE                         */
     /*       $RCVT1  4A  RECEIVED TIME (4 DIGITS)              */
     /*   OUT $RCVD2  8A  RECEIVED DATE                         */
     /*       $RCVT2  6A  RECEIVED TIME                         */
     /*       $STT    1A  STATUS (A:ACCEPTED, N: NOT ACCEPT)    */
     /***********************************************************/

             DCL        VAR(&PRTN) TYPE(*CHAR) LEN(30)
             DCL        VAR(&DAT1) TYPE(*CHAR) LEN(08)
             DCL        VAR(&TIM1) TYPE(*CHAR) LEN(04)
             DCL        VAR(&DAT2) TYPE(*CHAR) LEN(08)
             DCL        VAR(&TIM2) TYPE(*CHAR) LEN(06)
             DCL        VAR(&STT ) TYPE(*CHAR) LEN(01)

             OVRDBF     FILE(AUDREC98) TOFILE(G3X6DTA/AUDREC98)

             CALL PGM(UEXR58TC) PARM(&PRTN &DAT1 &TIM1 &DAT2 &TIM2 &STT)

             DLTOVR     FILE(*ALL)

             ENDPGM
