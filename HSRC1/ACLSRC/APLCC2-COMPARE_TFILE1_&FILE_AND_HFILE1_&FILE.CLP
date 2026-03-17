             PGM        PARM(&LIBL &FILE)
             /**** APLCC2 *****************************************/
             /* COMPARE TFILE1/&FILE AND HFILE1/&FILE             */
             /*         TWFILE1/&FILE AND HWFILE1/&FILE           */
             /* T.SAKASHITA 2020.10.05                            */
             /*****************************************************/
             DCL        VAR(&LIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)

             DCL        VAR(&LIBL2) TYPE(*CHAR) LEN(10)

             IF         COND(&LIBL *EQ 'TFILE1') THEN(DO)
             CHGVAR     VAR(&LIBL2) VALUE('HFILE1')
             ENDDO
             IF         COND(&LIBL *EQ 'TWFILE1') THEN(DO)
             CHGVAR     VAR(&LIBL2) VALUE('HWFILE1')
             ENDDO

             CMPPFM     NEWFILE(&LIBL/&FILE) OLDFILE(&LIBL2/&FILE)

             ENDPGM
