PGM
/** AAMC9X ***************************************/
/* TEST SAKAKI                                   */
/*    T.SAKAKI          2020.04.28               */
/*************************************************/

/* SAVE AAMWP99 */
             CPYF       FROMFILE(HWFILE1/AAMWP99) +
                          TOFILE(HWFILE1/AAMWP99S) MBROPT(*ADD) +
                          CRTFILE(*NO) FMTOPT(*NOCHK)
/* SAVE AAMPP11 */
             CPYF       FROMFILE(HFILE1/AAMPP11) +
                          TOFILE(HFILE1/AAMPP11S) MBROPT(*REPLACE) +
                          CRTFILE(*NO) FMTOPT(*NOCHK)
/* SAVE GHCPP21 */
             CPYF       FROMFILE(HFILE1/GHCPP21) +
                          TOFILE(HFILE1/GHCPP21S) MBROPT(*REPLACE) +
                          CRTFILE(*NO) FMTOPT(*NOCHK)
/*==============*/

             CALL AAMR9X

             CALL ABMR1X

 END:
             ENDPGM
