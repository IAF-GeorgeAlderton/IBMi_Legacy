             PGM
             /** AFFC32 ************************************/
             /*  READ AFFWP31, UPDATE AB#PP01 (AB#PP02)    */
             /*  JW (SRA)    2022.02.18                    */
             /**********************************************/

             CLRPFM     FILE(HWFILE1/AFFWP32)

             CALL       PGM(AFFR32)

             ENDPGM
