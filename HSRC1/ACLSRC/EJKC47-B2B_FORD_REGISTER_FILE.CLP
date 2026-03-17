             PGM        PARM(&JYKB &DKBN &SFILE &SLIBL &FILE)
             /** EJKC47 ***********************************/
             /* B2B_FORD   REGISTER FILE                  */
             /*  T.SAKAKI            2016.10.20           */
             /*********************************** EJKC47 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JYKB) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DKBN) TYPE(*CHAR) LEN(3)
             DCL        VAR(&SFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SLIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&B2BLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)

             RTVJOBA    USER(&USER)

             CHGVAR     VAR(&B2BLIB) VALUE('B2B_S')

             IF         COND(&USER *EQ 'TEST') THEN(DO)
             CHGVAR     VAR(&B2BLIB) VALUE('B2B_ST')
                        ENDDO

          /* COPY RECEPTION FILE */
             CPYF       FROMFILE(&SLIBL/&SFILE) +
                          TOFILE(&B2BLIB/&FILE) MBROPT(*REPLACE) +
                          CRTFILE(*YES) FMTOPT(*NOCHK)

       /*----------------------------------*/
       /* REGISTER RECEPTION FILE FOR FORD */
       /*----------------------------------*/
             CALL       PGM(EJKR48) PARM(&SFILE &B2BLIB &FILE &JYKB &DKBN)
                                    /* &FILE PUT */

             ENDPGM
