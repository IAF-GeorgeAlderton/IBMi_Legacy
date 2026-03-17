             PGM        PARM(&TDATE)
             /** CHKC61A *********************************************/
             /*  CHECK FORD SHIP SCHEDULE                            */
             /*  J.WATANABE 2020.12.16                               */
             /********************************************************/
             DCL        VAR(&TDATE) TYPE(*CHAR) LEN(8)

             CLRPFM     FILE(*LIBL/ABFWP20)

             CALL       PGM(CHKR61A) PARM(&TDATE)

             ENDPGM
