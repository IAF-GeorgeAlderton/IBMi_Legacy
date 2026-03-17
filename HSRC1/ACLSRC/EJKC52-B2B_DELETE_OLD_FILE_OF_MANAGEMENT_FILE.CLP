             PGM        PARM(&LIB &FIL)
             /** EJKC52 ***********************************/
             /* B2B   DELETE OLD FILE OF MANAGEMENT FILE  */
             /*********************************** EJKC52 **/
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FIL) TYPE(*CHAR) LEN(10)

             DLTF       FILE(&LIB/&FIL)
             MONMSG     MSGID(CPF3261 CPF2105)

             ENDPGM
