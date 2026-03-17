             PGM        PARM(&PKINO)
             /** AJEC06 ****************************/
             /*  ..SELECT AS/400   ..              */
             /*      I-HASADA        91.05.23      */
             /**************************** AJEC06 **/
             DCL        VAR(&PKINO) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PSYS) TYPE(*CHAR) LEN(8)
             RTVNETA    SYSNAME(&PSYS)

             IF         COND((&PSYS *EQ 'IAF     ') *OR (&PSYS *EQ +
                          'IAFAYM  ')) THEN(DO)
             CHGVAR     VAR(&PKINO) VALUE('1')
             ENDDO

             ENDPGM
