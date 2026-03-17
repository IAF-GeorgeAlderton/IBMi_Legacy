             PGM
             /* AL#CC8 *************************************/
             /* TRUCK BIN M/F INQUIRY                      */
             /* JW    2025.06.02                           */
             /**********************************************/
             DCL        VAR(&SRC) TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&TRUE) TYPE(*CHAR) LEN(8) VALUE(' ')
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&DATE) TYPE(*DEC)  LEN(8 0)
             DCL        VAR(&SUBR) TYPE(*CHAR) LEN(9)

/** GET TODAY **/
             CALL       PGM(UTLR01) PARM(&SRC  &TRUE &RTN)

             CHGVAR     VAR(&DATE) VALUE(&TRUE)

             CALL       PGM(AL#RC8) PARM(&DATE &SUBR)

             ENDPGM
