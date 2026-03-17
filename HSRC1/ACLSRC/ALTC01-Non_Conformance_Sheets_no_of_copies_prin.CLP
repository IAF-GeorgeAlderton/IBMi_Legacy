             PGM        PARM(&COPIES &PRINTER)
             /** ALTC01 **********************************/
             /* NUMBER OF COPIES / PRINTER               */
             /*     LEC.           10/17/2022            */
             /********************************************/
             DCL        VAR(&COPIES) TYPE(*DEC) LEN(1 0)
             DCL        VAR(&PRINTER) TYPE(*CHAR) LEN(10)

 /*******************************************************************/
 /*  NON-CONFORMANCE SHEET PRINT                                    */
             OVRPRTF    FILE(ALGPR30) FORMTYPE(&PRINTER) +
                          COPIES(&COPIES)

 /*******************************************************************/

             ENDPGM
