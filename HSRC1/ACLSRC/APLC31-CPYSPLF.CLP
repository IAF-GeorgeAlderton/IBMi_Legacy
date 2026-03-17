             PGM        PARM(&SPL &LIB &FILE)
             /** APLC31 ******************************************/
             /*CPYSPLF                                           */
             /*                                                  */
             /*  Y.SAMEJIMA.........           2012.09.20        */
             /****************************************************/
             DCL        VAR(&SPL)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBNBR)  TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&JOBNBR)

             CPYSPLF    FILE(&SPL) TOFILE(&LIB/&FILE) +
                          JOB(&JOBNBR/&USER/&WSID) SPLNBR(*LAST) +
                          MBROPT(*REPLACE) CTLCHAR(*FCFC)
 @END:
             ENDPGM
