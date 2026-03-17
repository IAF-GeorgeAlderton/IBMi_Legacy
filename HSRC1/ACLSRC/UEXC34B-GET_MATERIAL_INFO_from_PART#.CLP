             PGM        PARM(&SHIN)
             /** UEXC34B **********************************************/
             /*  GET MATERIAL INFO FROM PART#                         */
             /*  J.W   2021.06.30                                     */
             /*-------------------------------------------------------*/

             DCL        VAR(&SHIN) TYPE(*CHAR) LEN(12)
             DCL        VAR(&ZAIS) TYPE(*CHAR) LEN(15)  VALUE(' ')
             DCL        VAR(&ZAIK) TYPE(*DEC ) LEN(5 2) VALUE(0)
             DCL        VAR(&KIKI) TYPE(*DEC ) LEN(3 1) VALUE(0)
             DCL        VAR(&RTN ) TYPE(*CHAR) LEN(1)   VALUE(' ')


             CALL       PGM(UEXR34B) PARM(&SHIN &ZAIS &ZAIK &KIKI &RTN)

             ENDPGM
