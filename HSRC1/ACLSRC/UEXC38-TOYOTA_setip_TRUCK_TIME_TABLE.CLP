             /** UEXC36T **********************************************/
             /*  TOYOTA - SETIP TRUCK TIME TABLE                      */
             /*  J.W      2020.11.23                                  */
             /*-------------------------------------------------------*/
             PGM        PARM(&TGDT)

             DCL        VAR(&TGDT) TYPE(*CHAR) LEN(8)
             DCL        VAR(&RTN ) TYPE(*CHAR) LEN(1)

    /*       CRTDUPOBJ  OBJ(UEXWP38) FROMLIB(HWFILE1) OBJTYPE(*FILE) +  */
    /*                    TOLIB(QTEMP)                                  */
    /*       MONMSG     MSGID(CPF0000)                                  */
    /*                                                                  */
    /*       CLRPFM     FILE(QTEMP/UEXWP38)                             */
    /*       CLRPFM     FILE(UEXWP38)                         */
    /*       OVRDBF     FILE(AUEXWP38) TOFILE(QTEMP/UEXWP38)  */

             CALL       PGM(UEXR38) PARM(&TGDT &RTN)

             ENDPGM
