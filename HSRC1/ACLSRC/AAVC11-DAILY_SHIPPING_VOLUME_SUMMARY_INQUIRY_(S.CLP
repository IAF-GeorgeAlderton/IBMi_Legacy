             PGM
             /** AAVC11 ************************************/
             /*  DAILY SHIPPING VOLUME SUMMARY INQUIRY     */
             /*  JW    2020.07.20                          */
             /**********************************************/

             DLTF       FILE(QTEMP/FCEWP01)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ OBJ(FCEWP01) FROMLIB(HWFILE1) OBJTYPE(*FILE) TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             DLTF       FILE(QTEMP/AAVWP11)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ OBJ(AAVWP11) FROMLIB(HWFILE1) OBJTYPE(*FILE) TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             DLTF       FILE(QTEMP/AAVWP12)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ OBJ(AAVWP12) FROMLIB(HWFILE1) OBJTYPE(*FILE) TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(QTEMP/AAVWP11)
             CLRPFM     FILE(QTEMP/AAVWP12)
             CLRPFM     FILE(QTEMP/FCEWP01)

             OVRDBF     FILE(AAVWP11) TOFILE(QTEMP/AAVWP11)
             OVRDBF     FILE(AAVWP12) TOFILE(QTEMP/AAVWP12)
             OVRDBF     FILE(FCEWP01) TOFILE(QTEMP/FCEWP01)

             CALL       PGM(AAVR11)

             DLTOVR     FILE(*ALL)

             ENDPGM
