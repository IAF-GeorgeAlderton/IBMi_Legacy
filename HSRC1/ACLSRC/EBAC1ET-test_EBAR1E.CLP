             PGM
             /** EBAC1ET *****************************************/
             /*  TEST EBAR1E                                     */
             /*  JW                                              */
             /****************************************************/


             CLRPFM     FILE(TWFILE1/EBAEP11 )
             CLRPFM     FILE(TWFILE1/ABAWP10 )
             CLRPFM     FILE(TFILE1/ABFPP10 )
             CLRPFM     FILE(TFILE1/ABFPP20 )
             CLRPFM     FILE(TFILE1/ABFPP30 )
             CLRPFM     FILE(TFILE1/EBAEP25 )

             CALL       PGM(TOBJ1/EBAR1E)

             ENDPGM
