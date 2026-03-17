             PGM        PARM(&SIRE)
             /*** AFFC12 ************************************/
             /*   IFS.FIRM.CSV ORDER UPLOAD PROCESSING      */
             /*   JW (SRA)    2018.06.21                    */
             /***********************************************/
             DCL        VAR(&SIRE)  TYPE(*CHAR) LEN(4)

             DLTF       FILE(TWFILE1/AB#WP45)
             MONMSG     MSGID(CPF2105)

             CRTDUPOBJ  OBJ(AB#WP45) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(TWFILE1) NEWOBJ(AB#WP45) DATA(*NO)

             OVRDBF     FILE(AFFWP11) TOFILE(TWFILE1/AFFWP11)
             OVRDBF     FILE(AB#WP45) TOFILE(TWFILE1/AB#WP45)

             CALL       PGM(AFFR12) PARM(&SIRE)

             ENDPGM
