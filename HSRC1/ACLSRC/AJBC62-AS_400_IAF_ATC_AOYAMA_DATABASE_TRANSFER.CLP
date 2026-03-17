             PGM
             /** AJBC62 ******************************************/
             /*  ..AS/400 IAF ATC<-->AOYAMA DATABASE TRANSFER..  */
             /*      I-HASADA                      97.12.22      */
             /****************************************** AJBC62 **/
             DCL        VAR(&PSYN) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PIN98) TYPE(*CHAR) LEN(1) VALUE('0')
             RTVNETA    SYSNAME(&PSYN)

             IF         (&PSYN *EQ 'IAFAYM  ') DO
             CHGVAR     VAR(&PIN98) VALUE('1')
             ENDDO

             CALL       PGM(AJBR62) PARM(&PIN98)

             ENDPGM
