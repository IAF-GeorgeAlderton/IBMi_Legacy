             PGM        PARM(&SLIBL &SFILE)
             /** APLC22 ******************************************/
             /*IAF DATA IMPORT PGM                               */
             /*SAVE TO C:/AS400/IMPORT/IMPORT.CSV                */
             /*                                                  */
             /*  PC -----> AS400                                 */
             /*                                                  */
             /*  Y.SAMEJIMA.........           2012.09.20        */
             /****************************************************/
             DCL        VAR(&SYSTM)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&SLIBL)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&SFILE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PCFIL)  TYPE(*CHAR) LEN(52)
             DCL        VAR(&PUTGT)  TYPE(*CHAR) LEN(3)

             CHGVAR     VAR(&SYSTM) VALUE('IAF   ')
             CHGVAR     VAR(&PCFIL) VALUE('C:/AS400/IMPORT/IMPORT.CSV')
             CHGVAR     VAR(&PUTGT) VALUE('PUT')


             CALL       PGM(APLC20) PARM(&SYSTM &SLIBL &SFILE &PCFIL +
                          &PUTGT)
 @END:
             ENDPGM
