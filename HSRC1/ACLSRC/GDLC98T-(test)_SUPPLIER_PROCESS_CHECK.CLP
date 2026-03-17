             PGM
             /** GDLC98 *************************/
             /*  SUPPLIER PROCESS CHECK         */
             /*  JW      2020.09.09             */
             /***********************************/
             DCL        VAR(&PROC) TYPE(*CHAR) LEN(1) VALUE('1')
             DCL        VAR(&SUPP) TYPE(*CHAR) LEN(4) VALUE(' ')
             DCL        VAR(&RTNC) TYPE(*CHAR) LEN(1) VALUE(' ')

             CALL       PGM(GDLR98) PARM(&PROC &SUPP &RTNC)

             ENDPGM
