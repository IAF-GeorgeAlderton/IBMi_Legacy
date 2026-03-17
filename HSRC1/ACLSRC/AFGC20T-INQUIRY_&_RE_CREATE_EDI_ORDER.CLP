             PGM
             /** AFGC20T****************************/
             /*  TEMP PROGRAM                      */
             /**************************************/
             DCL        VAR(&SUPP) TYPE(*CHAR) LEN(4)
             DCL        VAR(&ODNO) TYPE(*DEC ) LEN(6 0)

             CHGVAR     VAR(&SUPP) VALUE('2112')
             CHGVAR     VAR(&ODNO) VALUE(180901)

     /* CREATE EDI ORDER SUMAMRY DATA  AFGPP01 */
             CALL       PGM(AFGR20 ) PARM(&SUPP &ODNO)

             ENDPGM
