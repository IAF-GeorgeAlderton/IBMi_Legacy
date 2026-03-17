             PGM        PARM(&PGM &USEDATE)
             /** APLC78 ************************************/
             /*  RETRIEVE LAST USED DATE OF THE PROGRAM  */
             /*  T.SAKASHITA   2019.07.31                  */
             /**********************************************/

             DCL        VAR(&PGM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USEDATE) TYPE(*CHAR) LEN(7)

             CHGVAR     VAR(&USEDATE) VALUE(' ')

             RTVOBJD    OBJ(&PGM) OBJTYPE(*PGM) USEDATE(&USEDATE)
             MONMSG     MSGID(CPF0000)
@RUN:
             ENDPGM
