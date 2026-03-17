             PGM
             /** SAVC02 *******************************************/
             /*  SAVE EDI OORDER DATA (AB#WP452 --> AB#WP45S)     */
             /*  J.WATANABE  2024.01.16                           */
             /*****************************************************/

             OVRDBF     FILE(AB#WP452) TOFILE(HWFILE1/AB#WP452SV)

             CALL       PGM(SAVR03)

             ENDPGM
