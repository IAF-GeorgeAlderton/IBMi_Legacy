             PGM
             /** AB#C2C9 **********************************************/
             /*  REWRITE AB#WP2O(MASTER LABEL) FOR TTAI(3556)         */
             /*  JW      2020.11.01                                   */
             /*********************************************************/
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3 )  TYPE(*CHAR) LEN(3)

             RTVJOBA    JOB(&WSID)
             CHGVAR     VAR(&WS3 ) VALUE(%SUBSTRING(&WSID 1 3))

             OVRDBF     FILE(AB#WP2O) TOFILE(AB#WP2O) MBR(&WS3)

             CALL       PGM(AB#R2C9)

             DLTOVR     FILE(*ALL)

             ENDPGM
