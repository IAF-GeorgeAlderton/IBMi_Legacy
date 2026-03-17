             PGM
             /** AJBC72 ******************************************/
             /*  ..AS/400 IAF ATC<-->AOYAMA DATABASE TRANSFER..  */
             /*  ..SRCMBR.SRCFILE.LIBRARY                        */
             /*      I-HASADA                    2001.04.23      */
             /****************************************** AJBC72 **/
             DCL        VAR(&PSYN) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PIN98) TYPE(*CHAR) LEN(1) VALUE('0')
             RTVNETA    SYSNAME(&PSYN)

             IF         (&PSYN *EQ 'IAFAYM  ') DO
             CHGVAR     VAR(&PIN98) VALUE('1')
             ENDDO

             CALL       PGM(AJBR72) PARM(&PIN98)

             ENDPGM
