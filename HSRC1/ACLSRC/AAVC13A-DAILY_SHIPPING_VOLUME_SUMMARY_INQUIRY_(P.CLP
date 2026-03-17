             PGM
             /** AAVC13 ************************************/
             /*  DAILY SHIPPING VOLUME SUMMARY INQ (PROC)  */
             /*  JW    2021.06.04                          */
             /**********************************************/

             DLTF       FILE(QTEMP/FCEWP01)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ OBJ(FCEWP01) FROMLIB(HWFILE1) OBJTYPE(*FILE) TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             DLTF       FILE(QTEMP/AAVWP13A)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(AAVWP13A) FROMLIB(HWFILE1) +
                          OBJTYPE(*FILE) TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             DLTF       FILE(QTEMP/AAVWP14A)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(AAVWP14A) FROMLIB(HWFILE1) +
                          OBJTYPE(*FILE) TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(QTEMP/AAVWP13A)
             CLRPFM     FILE(QTEMP/AAVWP14A)
             CLRPFM     FILE(QTEMP/FCEWP01)

             OVRDBF     FILE(AAVWP13A) TOFILE(QTEMP/AAVWP13A)
             OVRDBF     FILE(AAVWP14A) TOFILE(QTEMP/AAVWP14A)
             OVRDBF     FILE(FCEWP01) TOFILE(QTEMP/FCEWP01)

             CALL       PGM(AAVR13A)

             DLTOVR     FILE(*ALL)
/* TEMP */
     CPYF FROMFILE(QTEMP/AAVWP13A) TOFILE(TWFILE1/AAVWP13A) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF0000)

     CPYF FROMFILE(QTEMP/AAVWP14A) TOFILE(TWFILE1/AAVWP14A) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF0000)

     CPYF FROMFILE(QTEMP/FCEWP01) TOFILE(TWFILE1/FCEWP01) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF0000)

             ENDPGM
