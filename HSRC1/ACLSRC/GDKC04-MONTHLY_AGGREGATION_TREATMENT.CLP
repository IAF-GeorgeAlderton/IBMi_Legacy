             PGM
             /**** GDKC04 ****************************************************/
             /*      MONTHLY AGGREGATION TREATMENT                           */
             /*       GBC                               97/07/30             */
             /****************************************************************/
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             RTVJOBA    USER(&USER)
             CALL       PGM(GDKR04) PARM(&USER)
             ENDPGM
