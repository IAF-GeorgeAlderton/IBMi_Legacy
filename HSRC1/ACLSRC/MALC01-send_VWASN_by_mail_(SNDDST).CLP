             PGM        PARM(&FILE &LIB &USER)
             /** MALC01 **********************************************/
             /*  SEND DATA BY MAIL                                   */
             /*  J.WATANABE 2021.06.28                               */
             /********************************************************/
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIB ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ADDR) TYPE(*CHAR) LEN(30)
             DCL        VAR(&RTN ) TYPE(*CHAR) LEN(01)

             CALL       UTLR81 PARM(&USER &ADDR &RTN)
 /* NORMAL */
             IF         COND($RTN = ' ') THEN(DO)
             OVRDBF     FILE(&FILE ) TOFILE(&LIB/&FILE )
             SNDDST     TYPE(*FILE) TOINTNET((&ADDR)) DSTD('** SEND +
                          DATA **') MSG('** SEND DATA **  . +
                          (MALC01).') DOCFILE(&LIB/&FILE) +
                          DOCTYPE(*FFT) SNDFMT(*NOCHG) DOCD('** +
                          SEND DATA **')
             DLTOVR *ALL
             ENDDO
 /* ERROR */
             IF         COND($RTN = '*') THEN(DO)
             SNDDST     TYPE(*FILE) TOINTNET((&ADDR)) DSTD('** SEND +
                          DATA **') MSG('** SEND DATA **  . +
                          (MALC01).') DOCFILE(&LIB/&FILE) +
                          DOCTYPE(*FFT) SNDFMT(*NOCHG) DOCD('** +
                          SEND DATA **')
             DLTOVR *ALL
             ENDDO

             ENDPGM
