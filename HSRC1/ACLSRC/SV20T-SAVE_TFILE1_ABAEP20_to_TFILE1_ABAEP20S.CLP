             PGM
             /** SV20T  *****************************************/
             /*  SAVE TFILE1/ABAEP40 TO TFILE1/ABAEP20S         */
             /*  J.WATANABE  2023.11.08                         */
             /***************************************************/

             CPYF       FROMFILE(TFILE1/ABAEP20) +
                          TOFILE(TFILE1/ABAEP20S) MBROPT(*ADD) +
                          FMTOPT(*MAP *DROP)

             ENDPGM
