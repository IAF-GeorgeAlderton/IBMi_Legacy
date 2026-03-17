             PGM        PARM(&SDAT &PDAT)
/** ABFCE0 ************************************************/
/*  CREATE REPORT "UPLOAD ORDER STATUS" AND "5DAYS"       */
/*  JW    2022.07.25                                      */
/**********************************************************/
             DCL        VAR(&SDAT) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PDAT) TYPE(*CHAR) LEN(8)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

/* UPLOAD ORDER STATUS REPORT */
             CALL       PGM(ABFCE1 ) PARM(&SDAT &PDAT)

       /* 5 DAYS                                       **/
       /**   CALL       PGM(ABFCE3 ) PARM(&SDAT &PDAT) **/

             ENDPGM
