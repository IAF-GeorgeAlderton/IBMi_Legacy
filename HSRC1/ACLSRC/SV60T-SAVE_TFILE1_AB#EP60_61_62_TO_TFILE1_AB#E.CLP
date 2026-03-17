             PGM
             /** SV60T  *************************************************/
             /*  SAVE TFILE1/AB#EP60/61/62 TO TFILE1/AB#EP60S/61S/62S   */
             /*  J.WATANABE  2023.11.08                                 */
             /***********************************************************/

             CPYF       FROMFILE(TFILE1/AB#EP60) +
                          TOFILE(TFILE1/AB#EP60S) MBROPT(*ADD) +
                          FMTOPT(*MAP *DROP)

             CPYF       FROMFILE(TFILE1/AB#EP61) +
                          TOFILE(TFILE1/AB#EP61S) MBROPT(*ADD) +
                          FMTOPT(*MAP *DROP)

             CPYF       FROMFILE(TFILE1/AB#EP62) +
                          TOFILE(TFILE1/AB#EP62S) MBROPT(*ADD) +
                          FMTOPT(*MAP *DROP)

             ENDPGM
