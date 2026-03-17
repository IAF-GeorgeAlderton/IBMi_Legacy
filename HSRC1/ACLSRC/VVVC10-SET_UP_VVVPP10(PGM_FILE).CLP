             PGM
             /*** VVVC10 *******************/
             /*  SET UP VVVPP10(PGM-FILE)  */
             /*  J.WATANABE 2016.04.28     */
             /******************************/

             CPYF       FROMFILE(HWFILE1/VVVWPA0) +
                          TOFILE(HFILE1/VVVPP10) MBROPT(*REPLACE) +
                          FMTOPT(*MAP *DROP)
 /* CRT VVVPP10 */
             CALL       PGM(VVVR10)

 /* SET TYPE    */
             CALL       PGM(VVVC92)
             CALL       PGM(VVVR11)

             ENDPGM
