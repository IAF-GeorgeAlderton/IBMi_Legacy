             PGM
             /***ALDC6C2 ******************************************/
             /* SHORTAGE SUMMARY DATA DOWNLOAD TO CSV             */
             /* JW    2023.06.07                                  */
             /*****************************************************/
             DCL        VAR(&FNAM)  TYPE(*CHAR) LEN(30)

 /* SET AB#WP1J */
             DLTF       FILE(QTEMP/ALDWP6C2)
             MONMSG     MSGID(CPF0000)

            CRTDUPOBJ OBJ(ALDWP6C2) FROMLIB(HWFILE1) OBJTYPE(*FILE) TOLIB(QTEMP)
            CLRPFM     QTEMP/ALDWP6C2

            OVRDBF     FILE(ALDWL6C ) TOFILE(QTEMP/ALDWL6C  )
            OVRDBF     FILE(ALDWP6C2) TOFILE(QTEMP/ALDWP6C2 )

 /* CONVERT ALDWP6C TO ALDWP6C2 */
            CALL       PGM(ALDR6C2)

 /* TRANSFER TO CSV */
           CHGVAR   VAR(&FNAM) VALUE('SHORTAGE SUMMARY')
           CALL  PGM(APLC94) PARM('2' 'ALDWP6C2' 'HWFILE1' &FNAM 'Y' '' 'Y')

             ENDPGM
