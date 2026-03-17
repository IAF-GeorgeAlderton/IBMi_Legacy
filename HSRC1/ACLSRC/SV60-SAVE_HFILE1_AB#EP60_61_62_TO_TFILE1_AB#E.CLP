             PGM
             /** SV60   *********************************************/
             /*  SAVE HFILE1/AB#EP60/61/62 TO TFILE1/AB#EP60/61/62  */
             /*  J.WATANABE  2023.11.08                             */
             /*******************************************************/

             CPYF       FROMFILE(HFILE1/AB#EP60) +
                          TOFILE(TFILE1/AB#EP60) MBROPT(*REPLACE) +
                          FMTOPT(*MAP *DROP)

             CPYF       FROMFILE(HFILE1/AB#EP61) +
                          TOFILE(TFILE1/AB#EP61) MBROPT(*REPLACE) +
                          FMTOPT(*MAP *DROP)

             CPYF       FROMFILE(HFILE1/AB#EP62) +
                          TOFILE(TFILE1/AB#EP62) MBROPT(*REPLACE) +
                          FMTOPT(*MAP *DROP)

             ENDPGM
