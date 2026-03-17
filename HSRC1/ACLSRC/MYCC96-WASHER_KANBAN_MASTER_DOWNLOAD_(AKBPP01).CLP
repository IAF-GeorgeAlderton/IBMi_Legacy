             PGM
             /** MYCC96 ****************************/
             /*  WASHER KANBAN MASTER DOWNLOAD     */
             /*  JW     2021.01.25                 */
             /**************************************/

             CLRPFM     FILE(HWFILE1/MYCWP96)

             CALL       PGM(MYCR96)

 /* DOWNLOAD TO CSV */
             CALL       PGM(APLC93N) PARM('2' 'MYCWP96 ' 'HWFILE1' +
                          'WASHER KANBAN MASTER DOWNLOAD' 'Y' ' ' 'Y')

             ENDPGM
