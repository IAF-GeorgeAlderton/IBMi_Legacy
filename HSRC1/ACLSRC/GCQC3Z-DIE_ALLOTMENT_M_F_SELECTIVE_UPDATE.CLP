             PGM
             /********************************************/
             /* DIE ALLOTMENT M/F SELECTIVE UPDATE       */
             /*     GCQC3Z.      <CLP>                   */
             /*     2020/05/20                           */
             /********************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)

             DCL        VAR(&KBN ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SHN1) TYPE(*CHAR) LEN(5)
             DCL        VAR(&SHN2) TYPE(*CHAR) LEN(5)
             DCL        VAR(&SHN3) TYPE(*CHAR) LEN(2)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGJOB     OUTQ(&PRTG)

 STP01:
             CALL       PGM(GCQR3Y) PARM(&KBN &SHN1 &SHN2 &SHN3)

             IF         COND(&KBN *EQ ' ') THEN(GOTO CMDLBL(@END))
 STP02:

             CALL       PGM(GCQR3Z) PARM(&SHN1 &SHN2 &SHN3)

             GOTO       STP01
 @END:
             ENDPGM
