             PGM
             /**** GDKC08 ****************************************************/
             /*   INPUT OF AGGREGATION TREATMENT                           */
             /*       GBC                               97/07/30             */
             /****************************************************************/
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             RTVJOBA    USER(&USER)
             CALL       PGM(GDKR08) PARM(&USER)
             ENDPGM
