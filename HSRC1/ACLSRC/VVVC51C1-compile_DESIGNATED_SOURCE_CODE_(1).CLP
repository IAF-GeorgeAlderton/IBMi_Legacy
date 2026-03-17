             PGM        PARM(&SEU &PGM &STT)
             /** VVVC51C1 **********************************************/
             /*  CALL VVVC51C2                                         */
             /*  JW   2026.02.15                                       */
             /**********************************************************/
             DCL        VAR(&SEU ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PGM ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&STT ) TYPE(*CHAR) LEN(1)

             CALL       PGM(VVVC51C2) PARM((&SEU) (&PGM) (&STT))
             MONMSG     MSGID(RPG0202 CPF0001 QRG0008 QRG9001)

             ENDPGM
