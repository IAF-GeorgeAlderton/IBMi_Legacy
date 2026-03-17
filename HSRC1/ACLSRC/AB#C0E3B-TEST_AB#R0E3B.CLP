             PGM
             /*** AB#C0E3B *********************************************/
             /*  TEST AB#R0E3B                                         */
             /**********************************************************/

             DCL        VAR(&NOHZ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&SDAT) TYPE(*CHAR) LEN(8)
             DCL        VAR(&ADD ) TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&NOHZ) VALUE('20250315')
             CHGVAR     VAR(&SDAT) VALUE('20250310')
             CHGVAR     VAR(&ADD ) VALUE('Y')

             OVRPRTF    FILE(QPRINT) PAGESIZE(66 198) LPI(6) +
                          OVRFLW(62) OUTQ(LANPRT03) HOLD(*YES) +
                          SAVE(*YES) USRDTA('FORD-ADD')

             CALL       PGM(AB#R0E3BJ) PARM(&NOHZ &SDAT &ADD)

             ENDPGM
