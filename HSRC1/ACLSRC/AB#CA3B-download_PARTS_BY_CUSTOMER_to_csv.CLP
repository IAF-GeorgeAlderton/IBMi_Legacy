             PGM
             /** AB#CA3B ***********************************/
             /*  DOWNLOAD PARTS BY CUSTOMER TO CSV DATA    */
             /*  JW       2024.07.31                     */
             /**********************************************/
             DCL        VAR(&SUB)     TYPE(*CHAR) LEN(30)
             DCL        VAR(&SUB) TYPE(*CHAR) LEN(30)
             DCL        VAR(&REC) TYPE(*DEC)  LEN(10 0)

             CHGVAR     VAR(&SUB) VALUE('PART BY CUSTOMER')

             /*==================================================*/
             /*         GENERATE CSV DATA                        */
             /*==================================================*/
             CRTDUPOBJ  OBJ(AB#WPA2B) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     QTEMP/AB#WPA2B

             OVRDBF     FILE(AB#WPA2 ) TOFILE(QTEMP/AB#WPA2 )
             OVRDBF     FILE(AB#WPA2B) TOFILE(QTEMP/AB#WPA2B)

             CALL       PGM(AB#RA3B)

             RTVMBRD    FILE(QTEMP/AB#WPA2B) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(GOTO CMDLBL(#STEP99))

             /*==================================================*/
             /*         TRANSFER CSV TO DIRECTORY                */
             /*==================================================*/
             CALL       PGM(APLC94) PARM(('2') ('AB#WPA2B') +
                          ('QTEMP') (&SUB) ('Y') ('N') ('Y'))

 #STEP99:
             ENDPGM
