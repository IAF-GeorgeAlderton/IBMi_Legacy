             PGM
             /** MYCC97 ****************************/
             /*  PT KANBAN MASTER DOWNLOAD         */
             /*  JW     2021.02.04                 */
             /**************************************/

             CLRPFM     FILE(HWFILE1/MYCWP97)

             CALL       PGM(MYCR97)

 /* DOWNLOAD TO CSV */
             CALL       PGM(APLC93N) PARM('2' 'MYCWP97 ' 'HWFILE1' +
                          'PT KANBAN MASTER DOWNLOAD' 'Y' ' ' 'Y')

             ENDPGM
