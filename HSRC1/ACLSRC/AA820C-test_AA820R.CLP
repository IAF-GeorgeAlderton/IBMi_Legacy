             PGM        PARM(&YY &MM)
             /** AA820C ****************************************/
             /*  TEST AA820R                                   */
             /*  JW   2022.02.10                               */
             /**************************************************/

             DCL        VAR(&YY) TYPE(*CHAR) LEN(4)
             DCL        VAR(&MM) TYPE(*CHAR) LEN(2)
             DCL        VAR(&BI) TYPE(*DEC ) LEN(3 1)
             DCL        VAR(&HZ) TYPE(*DEC ) LEN(2 0)

             CALL       PGM(AA820R) PARM(&YY &MM &BI &HZ)

             ENDPGM
