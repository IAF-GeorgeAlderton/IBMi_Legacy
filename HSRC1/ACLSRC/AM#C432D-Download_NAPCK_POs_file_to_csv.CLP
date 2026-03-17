             PGM
             /* AM#C432D ******************************************/
             /* DOWNLOAD NAPCK POS FILE TO CSV                    */
             /* LEC      2022.05.12                               */
             /*****************************************************/
             DCL        VAR(&FNAM)   TYPE(*CHAR) LEN(30)

             CLRPFM     FILE(AM#WP432)
             MONMSG     MSGID(CPF0000)

             CPYF       FROMFILE(AM#PP432) TOFILE(AM#WP432) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)

             CHGVAR     VAR(&FNAM) VALUE('_VIEW_NAPCK_PO')
             CALL       PGM(APLC94N) PARM('2' 'AM#WP432' 'HWFILE1' &FNAM +
                          'Y' 'Y' 'N')
             ENDPGM
