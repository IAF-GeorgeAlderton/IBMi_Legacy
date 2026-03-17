             PGM
/** AB#CAAQI***********************************************/
/*  LABEL SCAN STATUS INQ  DATA)                          */
/*  JW     2023.07.26                                     */
/**********************************************************/
             DCL        VAR(&NONY) TYPE(*CHAR) LEN(4) VALUE('0000')
             DCL        VAR(&NOHZ) TYPE(*CHAR) LEN(8) VALUE('00000000')
             DCL        VAR(&NOBN) TYPE(*CHAR) LEN(2) VALUE('00')
             DCL        VAR(&NKOJ) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&NUKE) TYPE(*CHAR) LEN(4) VALUE('    ')

             CALL       PGM(AB#RAQI) PARM(&NONY &NOHZ &NOBN &NKOJ &NUKE)

             ENDPGM
