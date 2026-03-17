             PGM        PARM(&PRTN &REF# &RCVD &RCVT &BCH# &INT#)
     /** UEXC58H **************************************************/
     /*  GET GENTRAN INFO FROM REFERENCE# (HONDA)                 */
     /*  JW     2025.03.18                                        */
     /*************************************************************/
     /*   IN  $PRTN  30A  PARTNER ID                              */
     /*       $REF#  14A  REFERENCE#                              */
     /*   OUT $RCVD   8A  RECEIVED DATE                           */
     /*       $RCVT   6A  RECEIVED TIME                           */
     /*       $BCH#   7A  BATCH#                                  */
     /*       $INT#  14A  INTERCHANGE#                            */
     /*************************************************************/

             DCL        VAR(&PRTN) TYPE(*CHAR) LEN(30)
             DCL        VAR(&REF#) TYPE(*CHAR) LEN(14)
             DCL        VAR(&RCVD) TYPE(*CHAR) LEN(08)
             DCL        VAR(&RCVT) TYPE(*CHAR) LEN(06)
             DCL        VAR(&BCH#) TYPE(*CHAR) LEN(07)
             DCL        VAR(&INT#) TYPE(*CHAR) LEN(14)

             OVRDBF     FILE(AUDREC) TOFILE(G3X6DTA/AUDREC)

             CALL       PGM(UEXR58H) PARM(&PRTN &REF# &RCVD &RCVT &BCH# &INT#)

             DLTOVR     FILE(*ALL)

             ENDPGM
