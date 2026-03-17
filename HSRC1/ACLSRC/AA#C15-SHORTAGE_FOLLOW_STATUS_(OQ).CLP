             PGM
             /** AA#C14 **********************************************/
             /* SHORTAGE FOLLOW STATUS (OQ)                          */
             /*    OSHIMA.         2021.04.15                        */
             /********************************************************/

             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&DDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&US3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&P1PG) TYPE(*DEC) LEN(05 0) VALUE(1)
             DCL        VAR(&P1CMD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&OBJL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&P1DATE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&P1TIME) TYPE(*CHAR) LEN(6)
             DCL        VAR(&DAT14) TYPE(*CHAR) LEN(14)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CHGVAR     VAR(&OBJL) VALUE('HOBJ1     ')
             IF         (&USER *EQ 'TEST      ') DO
             CHGVAR     VAR(&OBJL) VALUE('TOBJ1     ')
             ENDDO

             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))
             CHGVAR     VAR(&US3) VALUE(%SST(&USER 1 3))

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

 STP00:

      /*     IF         COND(&WS3 *EQ 'OQ1' *OR +     */
             IF         COND(&US3 *EQ 'OQ#' *OR +
                             &US3 *EQ 'OQ2' *OR +
                             &US3 *EQ 'OQ3' *OR +
                             &US3 *EQ 'OQ4' *OR +
                             &US3 *EQ 'OQ5' *OR +
                             &US3 *EQ 'OQ6' *OR +
                             &US3 *EQ 'OQ7' *OR +
                             &US3 *EQ 'OQ8' *OR +
                             &US3 *EQ 'OQ9') +
             THEN(DO)
             CPYF       FROMFILE(&WLIB/AA#WP14) +
                          TOFILE(QTEMP/AA#WP14) MBROPT(*REPLACE) +
                          INCREL((*IF W3RONO *EQ &US3)) FMTOPT(*MAP +
                          *DROP)
             ENDDO
             ELSE DO
             CPYF       FROMFILE(&WLIB/AA#WP14) +
                          TOFILE(QTEMP/AA#WP14) MBROPT(*REPLACE) +
                          FMTOPT(*MAP *DROP)
             ENDDO

 #END:       ENDPGM
