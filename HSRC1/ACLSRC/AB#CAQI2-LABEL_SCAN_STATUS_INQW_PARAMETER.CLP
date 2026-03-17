             PGM        PARM(&NONY &NOHZ &NOBN &NKOJ &NUKE)
/** AB#CAAQI***********************************************/
/*  LABEL SCAN STATUS INQ  DATA)                          */
/*  JW     2023.07.26                                     */
/**********************************************************/
             DCL        VAR(&NONY) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NOHZ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&NOBN) TYPE(*CHAR) LEN(2)
             DCL        VAR(&NKOJ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NUKE) TYPE(*CHAR) LEN(4)

             CALL       PGM(AB#RAQI) PARM(&NONY &NOHZ &NOBN &NKOJ &NUKE)

             ENDPGM
