  PGM
/** AL#C19 ************************************************/
/* TOYOTA DAILY CONT    D/L                               */
/*                                                        */
/*  KIRI 2019/10/25                                       */
/**********************************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)

             DCL        VAR(&AB#WPAV2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&REC     ) TYPE(*DEC ) LEN(10 0)
             DCL        VAR(&FNAM) TYPE(*CHAR) LEN(30) +
                          VALUE('TOYOTA_DAILY_CONT')

             RTVJOBA    JOB(&WSID) USER(&USER)
             /*--------------------------------------------*/
             /*    CHECK ENVIRONMENT                        */
             /*--------------------------------------------*/
               CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

             CHGVAR     VAR(&AB#WPAV2) +
                         VALUE('AB#WPAV' *CAT %SST(&WSID 1 3))

             RTVMBRD    FILE(&WLIB/&AB#WPAV2) NBRCURRCD(&REC)

             IF         COND(&REC *NE 0) THEN(DO)

                 /*転送処理*/
             CALL       PGM(APLC94) PARM('1' &AB#WPAV2 &WLIB +
                          &FNAM 'Y' ' ' 'Y')

             ENDDO

             CLRPFM     FILE(&WLIB/&AB#WPAV2)

             ENDPGM
