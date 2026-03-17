             PGM        PARM(&SUPP &ODNO &GPPO &SHN1 &SHN2 &SHN3 &OKNG)
             /** AFGC02 **********************************/
             /* GET ORDER DATA FROM GREAT PLAINS         */
             /*   T.SAKAKI            2016.11.15         */
             /*****************************+**** AFGC02 **/
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS)    TYPE(*CHAR) LEN(3)
             DCL        VAR(&SUPP) TYPE(*CHAR) LEN(4)
             DCL        VAR(&ODNO) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&GPPO) TYPE(*CHAR) LEN(17)
             DCL        VAR(&SHN1) TYPE(*CHAR) LEN(5)
             DCL        VAR(&SHN2) TYPE(*CHAR) LEN(5)
             DCL        VAR(&SHN3) TYPE(*CHAR) LEN(2)
             DCL        VAR(&OKNG) TYPE(*CHAR) LEN(2)
             DCL        VAR(&AFGWP02) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID)
             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 3))
             CHGVAR     VAR(&AFGWP02) VALUE('AFGWP02' *CAT &WS)

             CHGVAR     VAR(&OKNG) VALUE('  ')


    /*---------------------------*/
    /* PULL INFORMATION FROM GPS */
    /*---------------------------*/
             CALL       PGM(EDIC60) PARM(&GPPO)

    /*---------------------------*/
    /* UPDATE AFGWP02 BY EDIPP60 */
    /*---------------------------*/
             OVRDBF     FILE(EDIPP60) TOFILE(QTEMP/EDIPP60)
             OVRDBF     FILE(AFGWP02) TOFILE(&AFGWP02)
             CALL       PGM(AFGR04) PARM(&SUPP &ODNO &GPPO &SHN1 +
                          &SHN2 &SHN3 &OKNG)

             DLTOVR     FILE(*ALL)

 @END:
             ENDPGM
