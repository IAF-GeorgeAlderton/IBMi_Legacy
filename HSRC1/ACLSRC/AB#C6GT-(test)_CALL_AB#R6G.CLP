             PGM
             /** AB#C6G ************************/
             /*  ..TMMNA ACCOUNT PAYBALE LIST  */
             /*                                */
             /* TCHK1 06/17/09 CHG LANPRT04 --> LANPRT03 */
             /************************ AB#C6G **/

             OVRDBF     FILE(AB#PP6D) TOFILE(TFILE1/AB#PP6D)
             OVRDBF     FILE(AB#PP6A) TOFILE(HFILE1/AB#PP6A)

             CALL       PGM(AB#R6G) PARM(' ')


 @END:       ENDPGM
