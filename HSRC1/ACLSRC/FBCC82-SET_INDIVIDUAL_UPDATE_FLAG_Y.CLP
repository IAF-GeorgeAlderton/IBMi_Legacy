             PGM
             /*** FBCC82 ************************************/
             /* SET INDIVIDUAL UPDATE FLAG Y  (FORD)        */
             /* JW (SRA)    2016.07.25                      */
             /***********************************************/

             CALL       PGM(FBCR82)

             CPYF       FROMFILE(HWFILE1/FBCWP81) +
                          TOFILE(HWFILE1/FBCWP81S) MBROPT(*ADD) +
                          CRTFILE(*NO) FMTOPT(*NOCHK)

             ENDPGM
