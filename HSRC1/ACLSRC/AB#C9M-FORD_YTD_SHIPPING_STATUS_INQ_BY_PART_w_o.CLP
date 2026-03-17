             PGM
             /** AB#C9M2 ********************************/
             /*  FORD YTD SHIPPING STATUS INQ BY PART   */
             /*  JW       2022.02.02                    */
             /*******************************************/
             DCL        VAR(&NONY)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&KEY )  TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSG )  TYPE(*CHAR) LEN(30)

/* JW SAVE LOG */
             CHGVAR     VAR(&KEY ) VALUE('AB#R9M    ')
             CHGVAR     VAR(&MSG ) VALUE('FORD YTD SHIP STATUS (START)  ')
             CALL       PGM(UTLR07D) PARM(&KEY &MSG)

             CHGVAR     VAR(&NONY) VALUE('    ')

             DLTF       FILE(QTEMP/AB#WP9M)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(AB#WP9M) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(QTEMP/AB#WP9M)

             OVRDBF     FILE(AB#WP9M) TOFILE(QTEMP/AB#WP9M)
             CALL       PGM(AB#R9M ) PARM(&NONY)

/* JW SAVE LOG */
             CHGVAR     VAR(&MSG ) VALUE('FORD YTD SHIP STATUS (END  )  ')
             CALL       PGM(UTLR07D) PARM(&KEY &MSG)

             ENDPGM
