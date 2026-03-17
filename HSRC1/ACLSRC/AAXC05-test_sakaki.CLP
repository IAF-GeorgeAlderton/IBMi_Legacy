             PGM
             /** AAXC05 ****************************************/
             /*   TEST                                         */
             /*        T,SAKAKI                2016.07.15      */
             /**************************************** AAXC05 **/

             CPYFRMIMPF FROMFILE(SAKAKI/TESTS1) TOFILE(AXXPP01) +
                          MBROPT(*REPLACE) FLDDLM(',') +
                          RPLNULLVAL(*FLDDFT)

 END:        ENDPGM
