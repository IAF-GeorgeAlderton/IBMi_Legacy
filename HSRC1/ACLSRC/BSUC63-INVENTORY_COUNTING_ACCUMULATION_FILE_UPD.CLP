             PGM
             /** BSUC63 *********************************/
             /*  INVENTORY COUNTING ACCUMULATION FILE UPDATE */
             /* A.IDOTA                   88.06.21      */
             /********************************* BSUC63 **/
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
      /*     DCL        VAR(&HTNK) TYPE(*DEC) LEN(3 2)    HEAD OFFICE */
             DCL        VAR(&ETNK) TYPE(*DEC) LEN(3 2) /* ENA */
      /*     DCL        VAR(&GTNK) TYPE(*DEC) LEN(3 2)    GIFU */
      /*     DCL        VAR(&MTNK) TYPE(*DEC) LEN(3 2)    KUMAMOTO */
      /*     DCL        VAR(&ATNK) TYPE(*DEC) LEN(3 2)    A / C */

     /*      RTVDTAARA  DTAARA(HTNK) RTNVAR(&HTNK)   */
             RTVDTAARA  DTAARA(ETNK) RTNVAR(&ETNK)
     /*      RTVDTAARA  DTAARA(GTNK) RTNVAR(&GTNK)   */
     /*      RTVDTAARA  DTAARA(MTNK) RTNVAR(&MTNK)   */
     /*      RTVDTAARA  DTAARA(ATNK) RTNVAR(&ATNK)   */
             RTVJOBA    JOB(&WSID)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

      /* INVENTORY COUNTING ACCUMULATION FILE UPDATE */

      /*     CALL     PGM(BSUR63) PARM(&HTNK &ETNK &GTNK &MTNK &ATNK)*/
             CALL       PGM(BSUR63) PARM(&ETNK)

 END:        ENDPGM
