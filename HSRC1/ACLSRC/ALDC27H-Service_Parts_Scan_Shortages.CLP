             PGM        PARM(&PART# &NONY &SHID &ODRN &NUKE &QPC &WKCD)

             /** ALDC27H ***********************/
             /* SERVICE PARTS - SHORTAGES      */
             /*   LEC              2021.05.24  */
             /**********************************/
             DCL        VAR(&PART#) TYPE(*CHAR) LEN(12)
             DCL        VAR(&NONY ) TYPE(*DEC)  LEN(04 0)
             DCL        VAR(&SHID ) TYPE(*CHAR) LEN(08)
             DCL        VAR(&ODRN ) TYPE(*CHAR) LEN(12)
             DCL        VAR(&NUKE ) TYPE(*CHAR) LEN(04)
             DCL        VAR(&QPC  ) TYPE(*DEC ) LEN(05 0)
             DCL        VAR(&WKCD) TYPE(*CHAR) LEN(6)

     /* Reduce Order Qty in Order File due to Part "Short"         */

             CALL       PGM(ALDR27H) PARM(&PART# &NONY &SHID &ODRN +
                          &NUKE &QPC &WKCD)

             ENDPGM
