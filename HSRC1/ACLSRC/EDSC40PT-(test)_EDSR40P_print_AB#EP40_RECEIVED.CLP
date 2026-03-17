             /** EDSC40P************************************/
             /*  TEST EDSR40P                              */
             /**********************************************/

             DCL        VAR(&RTN) TYPE(*CHAR) LEN(1)

             OVRDBF     FILE(AB#EP40) TOFILE(TFILE1/AB#EP40)
             OVRDBF     FILE(EDIPP03) TOFILE(TFILE1/EDIPP03)

             OVRPRTF    FILE(QPRINT) OUTQ(SAVEOUTQ) HOLD(*YES)

             CALL       PGM(EDSR40P ) PARM((&RTN))

ENDP:        ENDPGM
