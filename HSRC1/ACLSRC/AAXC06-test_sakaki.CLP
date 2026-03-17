             PGM
             /** AAXC05 ****************************************/
             /*   TEST                                         */
             /*        T,SAKAKI                2016.07.15      */
             /**************************************** AAXC05 **/

             CPYFRMIMPF FROMFILE(SAKAKI/SSS1) TOFILE(AXXPP03) +
                          MBROPT(*REPLACE) FLDDLM(',') +
                          RPLNULLVAL(*FLDDFT)

 END:        ENDPGM
