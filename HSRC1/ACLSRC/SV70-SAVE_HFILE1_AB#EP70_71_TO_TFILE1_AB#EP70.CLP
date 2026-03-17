             PGM
             /** SV70   *********************************************/
             /*  SAVE HFILE1/AB#EP70/71 TO TFILE1/AB#EP70/71        */
             /*  J.WATANABE  2023.11.08                             */
             /*******************************************************/

             CPYF       FROMFILE(HFILE1/AB#EP70) +
                          TOFILE(TFILE1/AB#EP70) MBROPT(*REPLACE) +
                          FMTOPT(*MAP *DROP)

             CPYF       FROMFILE(HFILE1/AB#EP71) +
                          TOFILE(TFILE1/AB#EP71) MBROPT(*REPLACE) +
                          FMTOPT(*MAP *DROP)

             ENDPGM
