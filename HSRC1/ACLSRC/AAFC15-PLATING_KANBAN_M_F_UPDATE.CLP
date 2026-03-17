             PGM
             /***AAFC15 ****************************************/
             /* CHECK THE SOME KANBAN M/F                      */
             /* Y.SAMEJIMA......             2011.06.29        */
             /*************************************** AAFC15 ***/

             /*QUENCHING KANBAN  */
             RUNQRY     QRY(HWFILE1/QRYADHPP01)

             /*INTRA-PROCESS KANBAN */
             RUNQRY     QRY(HWFILE1/QRYABHPP01)

             /*PLATING  KANBAN */
             RUNQRY     QRY(HWFILE1/QRYAAFPP01)

             /*PART WITHDRAWAL KANBAN */
             RUNQRY     QRY(HWFILE1/QRYAAHPP01)

             ENDPGM
