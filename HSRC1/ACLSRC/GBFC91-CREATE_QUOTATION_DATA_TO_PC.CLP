             PGM
             /** GBFC91 ************************************/
             /*  CREATE QUOTATION DATA TO P/C                   */
             /*       TCH           2002.09.05             */
             /*                                            */
             /************************************ GBFC91 **/

             CLRPFM     FILE(GBFWP51)
             CLRPFM     FILE(GBFWP52)
             CALL       PGM(GBFR91)

             ENDPGM
