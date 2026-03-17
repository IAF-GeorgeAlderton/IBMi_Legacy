             PGM
             /** AB#C45T ***********************/
             /*  TEST AB#R45                   */
             /*  J.W  2021.10.14               */
             /************************ AB#C40 **/

             CPYF       FROMFILE(TWFILE1/AB#WP451) +
                          TOFILE(TWFILE1/AB#WP453) MBROPT(*REPLACE) +
                          FMTOPT(*NOCHK)

             CLRPFM     FILE(TWFILE1/AB#WP454)

             OVRDBF     FILE(AB#WP453) TOFILE(TWFILE1/AB#WP453)
             OVRDBF     FILE(AB#WP454) TOFILE(TWFILE1/AB#WP454)

             CALL       PGM(AB#R452)
/**/

             CLRPFM     FILE(TWFILE1/AB#WP455)

             OVRDBF     FILE(AB#WP454) TOFILE(TWFILE1/AB#WP454)
             OVRDBF     FILE(AB#WP455) TOFILE(TWFILE1/AB#WP455)

             CALL       PGM(AB#R453)
/**/

             CLRPFM     FILE(TWFILE1/AB#WP456)

             OVRDBF     FILE(AB#WP455) TOFILE(TWFILE1/AB#WP455)
             OVRDBF     FILE(AB#WP456) TOFILE(TWFILE1/AB#WP456)

             CALL       PGM(AB#R455)

ENDP:
             DLTOVR     FILE(*ALL)
             ENDPGM
