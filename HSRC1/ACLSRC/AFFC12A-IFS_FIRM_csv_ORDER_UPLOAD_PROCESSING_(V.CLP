             PGM        PARM(&SIRE)
             /*** AFFC12 ************************************/
             /*   IFS.FIRM.CSV ORDER UPLOAD PROCESSING      */
             /*   JW (SRA)    2018.06.21                    */
             /***********************************************/
             DCL        VAR(&SIRE)  TYPE(*CHAR) LEN(4)

             DLTF       FILE(QTEMP/AB#WP45)
             MONMSG     MSGID(CPF2105)

             CRTDUPOBJ  OBJ(AB#WP45) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP) NEWOBJ(AB#WP45) DATA(*NO)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(AFFWP11) TOFILE(QTEMP/AFFWP11)
             OVRDBF     FILE(AB#WP45) TOFILE(QTEMP/AB#WP45)

             CALL       PGM(AFFR12) PARM(&SIRE)

             ENDPGM
