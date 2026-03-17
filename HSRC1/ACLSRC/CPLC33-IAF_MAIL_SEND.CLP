             PGM        PARM(&TO1 &SUB &LIB &FILE &FNAME)
             /** APLC30 ******************************************/
             /*IAF MAIL SEND                                     */
             /*                                                  */
             /*  Y.SAMEJIMA.........           2012.09.20        */
             /****************************************************/
             DCL        VAR(&TO1)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&SUB)  TYPE(*CHAR) LEN(30)
             DCL        VAR(&LIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&FNAME)  TYPE(*CHAR) LEN(30)

             IF         COND(&TO1 *EQ *BLNAK) THEN(GOTO CMDLBL(@END))
             IF         COND(&SUB *EQ *BLNAK) THEN(GOTO CMDLBL(@END))
             IF         COND(&LIB *EQ *BLNAK) THEN(GOTO CMDLBL(@END))
             IF         COND(&FILE *EQ *BLNAK) THEN(GOTO CMDLBL(@END))
             IF         COND(&FNAME *EQ *BLNAK) THEN(GOTO CMDLBL(@END))


             SNDDST     TYPE(*FILE) TOINTNET((&TO1)) DSTD(&SUB) +
                          MSG(&SUB) DOCFILE(&LIB/&FILE) +
                          DOCTYPE(*FFT) SNDFMT(*NOTE) DOCD(&SUB) +
                          AUTUSR(I0023 SYSTEM6)







 @END:
             ENDPGM
