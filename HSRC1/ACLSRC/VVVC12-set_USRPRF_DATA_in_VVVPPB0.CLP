             PGM
             /*** VVVC10 *******************/
             /*  SET UP VVVPP10(PGM-FILE)  */
             /*  J.WATANABE 2016.04.28     */
             /******************************/

             DSPUSRPRF  USRPRF(*ALL) OUTPUT(*OUTFILE) +
                          OUTFILE(HWFILE1/USRPRF)

             CPYF       FROMFILE(HWFILE1/USRPRF) +
                          TOFILE(HWFILE1/USRWP10) MBROPT(*REPLACE) +
                          FMTOPT(*MAP *DROP)

             OVRDBF     FILE(USRPRF) TOFILE(HWFILE1/USRPRF)

             CALL       PGM(VVVR12)

             ENDPGM
