             PGM
/** MBEC20 ************************************************/
/*  SHIPPED PALLET SUMMARY REPORT                         */
/*  J.WATANABE  2018.03.02                                */
/**********************************************************/

             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&FNAM)  TYPE(*CHAR) LEN(30)
             DCL        VAR(&REC)   TYPE(*DEC)  LEN(10 0)

             CHGVAR     VAR(&FNAM) VALUE('SHIPPED PALLET SUMMARY')

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CLRPFM     FILE(&WLIB/MBEWP20)
             CLRPFM     FILE(&WLIB/MBEWP21)
             CLRPFM     FILE(&WLIB/MBEWP22)

  /* GET SALES RESULT */
             CALL       PGM(MBER20)

  /* END ? */
             RTVMBRD    FILE(&WLIB/MBEWP20) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(GOTO CMDLBL(PGMEND))

  /* SUMMARIZE */
             CALL       PGM(MBER21)

  /* CREATE OUTPUT DATA */
             CALL       PGM(MBER22)

  /* OUTPUT TO CSV */
             CALL       PGM(APLC94) PARM('2' 'MBEWP22' &WLIB &FNAM 'Y' ' ' 'Y')

PGMEND:      ENDPGM
