  PGM
/** AKSC01 ************************************************/
/*  INQUIRY PART/COMPONENTS M/F                           */
/*    LINK COMMON PART,UNIT PRICE INQUIRY                 */
/*                                                        */
/* TCHK1 06/01/06 CREATE(COPY FROM AKAC30)                */
/************************************************ AKSC01 **/

          DCL        VAR(&ABBDS3) TYPE(*CHAR) LEN(7)
          DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
          DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
          DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
          DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
          DCL        VAR(&PKYM)   TYPE(*CHAR) LEN(6)

          RTVJOBA    JOB(&WSID)
          RTVDTAARA  DTAARA(ABBDS3) RTNVAR(&ABBDS3)

          CHGVAR     VAR(&PKYM) VALUE(%SST(&ABBDS3 1 6))

          CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

          CHGJOB     OUTQ(&PRTG)

          CALL       PGM(AKSR01) PARM(&PKYM)

          ENDPGM
