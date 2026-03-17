             PGM
             /*** ODRC01 *****************************************/
             /*   ORDER ENTRY ANALYSIS REPORT                    */
             /*   JW    2019.08.06                               */
             /****************************************************/
             DCL        VAR(&YYMM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&RTN ) TYPE(*CHAR) LEN(1)

             CALL       PGM(ODRC01) PARM(&YYMM &RTN)

  END:       ENDPGM
