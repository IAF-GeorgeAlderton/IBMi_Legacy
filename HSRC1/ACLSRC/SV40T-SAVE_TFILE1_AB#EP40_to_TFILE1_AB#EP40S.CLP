             PGM
             /** SV40T  *****************************************/
             /*  SAVE TFILE1/AB#EP40 TO TFILE1/AB#EP40S         */
             /*  J.WATANABE  2023.11.08                         */
             /***************************************************/

             CPYF       FROMFILE(TFILE1/AB#EP40) +
                          TOFILE(TFILE1/AB#EP40S) MBROPT(*ADD) +
                          FMTOPT(*MAP *DROP)

             ENDPGM
