  PGM
/** AB#C1G *************************************************/
/*  TOYOTA REVISION/COUNTRY MAINTENANCE                    */
/*                                                         */
/************************************** AB#CHN *************/
             DCL        VAR(&MHN1) TYPE(*CHAR) LEN(5)
             DCL        VAR(&MHN2) TYPE(*CHAR) LEN(5)
             DCL        VAR(&MHN3) TYPE(*CHAR) LEN(5)
             DCL        VAR(&MHN4) TYPE(*CHAR) LEN(5)
             DCL        VAR(&NONY) TYPE(*DEC) LEN(4 0)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USR)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USR)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USR &WLIB)

  /* CONTRY OF ORIGIN CHANGE */
       /**   CALL       PGM(AB#R1G) PARM(&MHN1 &MHN2 &MHN3 &MHN4 &NONY)  **/
             CALL       PGM(AB#R1G1) PARM(&MHN1 &MHN2 &MHN3 &MHN4 &NONY)

 END:
             ENDPGM
