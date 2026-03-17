             PGM        PARM(&USRID &USRNM)
             /** UTLC58 ****************************************/
             /*  CALL RETRIEVAL PROGRAM                        */
             /*  LEC:                        2018.05.01        */
             /**************************************************/

             DCL        VAR(&USRID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USRNM) TYPE(*CHAR) LEN(30)
             DCL        VAR(&TEXT)  TYPE(*CHAR) LEN(50)

             RTVOBJD    OBJ(&USRID) OBJTYPE(*USRPRF) TEXT(&TEXT)

             CHGVAR     VAR(&USRNM) VALUE(&TEXT)

             ENDPGM
