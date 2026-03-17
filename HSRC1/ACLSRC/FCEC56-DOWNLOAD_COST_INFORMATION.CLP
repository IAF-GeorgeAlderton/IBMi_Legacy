             PGM
             /** FCEC56 ***************************************/
             /*  DOWNLOAD COST INFORMATION                    */
             /*    TCH                            02.09.05    */
             /*************************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
            /*-------------------------------------------------------*/
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CRTDUPOBJ  OBJ(GBFWP99) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/GBFWP99

             OVRDBF     FILE(GBFWP99) TOFILE(QTEMP/GBFWP99)

             CLRPFM     FILE(FCEWP55)
             CALL       PGM(FCER56)

             DLTOVR     FILE(*ALL)

              ENDPGM
