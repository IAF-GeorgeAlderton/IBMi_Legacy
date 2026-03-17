             PGM
             /** AIAC04 ****************************************/
             /* || M/F DATA FOR DAILY HANDLING TRANSMISSION || */
             /* I-HASADA                        86.10.16       */
             /**************************************** AIAC04 **/

             CLRPFM     FILE(A0A0111)

             CLRPFM     FILE(AIA0111)

             OVRDBF     FILE(INPUT) TOFILE(AIANP04)
             CALL       PGM(AIAR04)
             CALL       PGM(AIAR05)
             DLTOVR     FILE(INPUT)

             OVRDBF     FILE(OUTPUT1) TOFILE(A0A0111)
             CALL       PGM(AIAR06) PARM(' ')

             CLRPFM     FILE(AIANP04)
             CLRPFM     FILE(AIA0111)

             DLTOVR     FILE(OUTPUT1)

 END:        ENDPGM
