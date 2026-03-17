             PGM        PARM(&FROM &TO)
             /** CPYSRC2 *********************************************/
             /*  COPY SOURCE FILE FROM HSRC1 TO HSRC2 (STEP2)        */
             /*  J.WATANABE 2026.01.15                               */
             /********************************************************/

             DCL        VAR(&FROM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TO  ) TYPE(*CHAR) LEN(10)

 /* COPY SOURCE FILE */
             CPYSRCF    FROMFILE(HSRC1/&FROM) TOFILE(HSRC2/&TO) +
                          FROMMBR(*ALL) TOMBRID(*FROMMBR) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2971 CPF2817)

             ENDPGM
