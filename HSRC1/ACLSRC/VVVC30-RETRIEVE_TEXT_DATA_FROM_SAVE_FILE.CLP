             PGM
             /** VVVC30 ***********************************************/
             /*  UTILITY - RETRIEVE TEXT DATA FROM SAVE FILE          */
             /*  JW        2023.04.17                                 */
             /*--------------------------------------------           */
             /*  RETRIEVE PMO DATA FROM PMOSV BY RECORD#              */
             /*********************************************************/

/** COPY FROM TWFILE1/PMOSV TO HWFILE1/PMOTST **/

             CPYF       FROMFILE(TWFILE1/PMOSV) +
                          TOFILE(HWFILE1/PMOTST) MBROPT(*REPLACE) +
                          FROMRCD(15781) TORCD(16139)


 ENDP:       ENDPGM
