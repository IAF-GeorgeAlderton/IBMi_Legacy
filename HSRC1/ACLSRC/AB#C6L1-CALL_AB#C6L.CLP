             PGM
/** AB#C6L1************************************************/
/*  FORD ACCOUNT PAYABLE LIST                             */
/*  (THIS CL IS IN GENEDI)                                */
/*  JW   2020.11.19                                       */
/* ---------------------------------------                */
/*  JWX  2025.09.29 ADD SAVE FILES (AB#PP6JT/6KT/6LT)     */
/**********************************************************/

/** JWX SAVE AB#PP6J/K/L --> AB#PP6JT/KT/LT     **/
             DCL        VAR(&F) TYPE(*CHAR) LEN(10) VALUE('HFILE1')
CPYF FROMFILE(&F/AB#PP6J) TOFILE(&F/AB#PP6JT) MBROPT(*ADD) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF0000)
CPYF FROMFILE(&F/AB#PP6K) TOFILE(&F/AB#PP6KT) MBROPT(*ADD) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF0000)
CPYF FROMFILE(&F/AB#PP6L) TOFILE(&F/AB#PP6LT) MBROPT(*ADD) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF0000)

    /** #STOP TO RUN B2B *************************/
             GOTO       CMDLBL(ENDP)
    /*********************************************/

             CALL       PGM(AB#C6L)

ENDP:        ENDPGM
