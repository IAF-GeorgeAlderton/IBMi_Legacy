             PGM
             /** AB#C0L **********************************************/
             /*  EDI(861)  GENTRAN AS400                             */
             /*  J.WATANABE   2020.11.19                             */
             /********************************************************/

/** JWX SAVE AB#EP80  --> AB#AB#EP80T        **/
             DCL        VAR(&F) TYPE(*CHAR) LEN(10) VALUE('HFILE1')
CPYF FROMFILE(&F/AB#EP80) TOFILE(&F/AB#EP80T) MBROPT(*ADD) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF0000)

    /** #STOP TO RUN B2B   ***********************/
             GOTO       CMDLBL(ENDP)
    /*********************************************/

             CALL       PGM(AB#R0L)

ENDP:        ENDPGM
