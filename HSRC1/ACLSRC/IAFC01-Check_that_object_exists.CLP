             /** IAFC01   ******************************/
             /*   CHECK THAT OBJECT EXISTS             */
             /*                                        */
             /*   LEC CREATE               2024.01.25  */
             /*                                        */
             /******************************************/

             PGM        PARM(&OBJNAM &OBJTYP &YN)

             DCL        VAR(&OBJNAM)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&OBJTYP)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&YN)   TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&YN) VALUE('Y')

        /*--------------------------------------------*/
        /*  CHECK IF OBJECT EXISTS                    */
        /*--------------------------------------------*/
             CHKOBJ     OBJ(&OBJNAM) OBJTYPE(&OBJTYP)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&YN) VALUE('N'))

             ENDPGM
