             PGM
             /*** GDGC14 *****************************/
             /*  TEST GDGR14                         */
             /*  JW   2026.01.21                     */
             /****************************************/
             DCL        VAR(&WFILE1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPGM)   TYPE(*CHAR) LEN(6)

             CHGVAR     VAR(&WFILE1) VALUE('GDGWP13IAF')
             CHGVAR     VAR(&PPGM)   VALUE('GSTC80')

             CALL       PGM(GDGR14) PARM(&WFILE1 &PPGM)

             ENDPGM
