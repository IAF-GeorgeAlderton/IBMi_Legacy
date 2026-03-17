             PGM        PARM(&NOHZ &TDATE &ADON)
             /** AB#C0E3 *********************************/
             /*  FORD EDI862 PRE ORDER                   */
             /*  JW      2021.12.20                      */
             /********************************************/

             DCL        VAR(&NOHZ)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&TDATE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&ADON)  TYPE(*CHAR) LEN(1)

    /**      CLRPFM     FILE(HFILE1/AB#PPF2)                  **/
    /**      OVRDBF     FILE(AB#PPF2) TOFILE(HFILE1/AB#PPF2)  **/

             CALL       PGM(HOBJ1/AB#R0E3) PARM(&NOHZ &TDATE &ADON)

             ENDPGM
