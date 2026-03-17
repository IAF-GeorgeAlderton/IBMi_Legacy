             PGM
             /** AAVC12 ************************************/
             /*  DAILY SHIPPING VOLUME SUMMARY INQ (PROC)  */
             /*  JW    2020.07.31                          */
             /**********************************************/

             DLTF       FILE(QTEMP/FCEWP01)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ OBJ(FCEWP01) FROMLIB(HWFILE1) OBJTYPE(*FILE) TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             DLTF       FILE(QTEMP/AAVWP13)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ OBJ(AAVWP13) FROMLIB(HWFILE1) OBJTYPE(*FILE) TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             DLTF       FILE(QTEMP/AAVWP14)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ OBJ(AAVWP14) FROMLIB(HWFILE1) OBJTYPE(*FILE) TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(QTEMP/AAVWP13)
             CLRPFM     FILE(QTEMP/AAVWP14)
             CLRPFM     FILE(QTEMP/FCEWP01)

             OVRDBF     FILE(AAVWP13) TOFILE(QTEMP/AAVWP13)
             OVRDBF     FILE(AAVWP14) TOFILE(QTEMP/AAVWP14)
             OVRDBF     FILE(FCEWP01) TOFILE(QTEMP/FCEWP01)

             CALL       PGM(AAVR12)

             DLTOVR     FILE(*ALL)
/* TEMP */
     CPYF FROMFILE(QTEMP/AAVWP13) TOFILE(TWFILE1/AAVWP13) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF0000)

     CPYF FROMFILE(QTEMP/AAVWP14) TOFILE(TWFILE1/AAVWP14) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF0000)

     CPYF FROMFILE(QTEMP/FCEWP01) TOFILE(TWFILE1/FCEWP01) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF0000)

             ENDPGM
