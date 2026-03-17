/** AB#C2F ************************************************/
/*  TAKUMI ORDER PROCESSING                               */
/**********************************************************/
 PGM
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&SR)     TYPE(*CHAR) LEN(2)
             DCL        VAR(&MBAN)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PFLG)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&FILE1)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE2)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE3)  TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE4)  TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE5)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE6)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&PSIRE)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&SIREF)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&PID)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&ID)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&PFG)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&PTN)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&PYM)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&ABADS1) TYPE(*CHAR) LEN(48)
             DCL        VAR(&REC)    TYPE(*DEC)  LEN(10 0)
             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&PRTG) VALUE('LANPRT50  ')
             CALL       PGM(ALBC00) PARM(&USER &WLIB)
             CHGJOB     SWS(00000000)

  /*=================================================================*/
             CHGVAR     VAR(&PSIRE) VALUE('0777')
  /* ADI */
             IF         COND(&PSIRE *EQ '0777') THEN(DO)
             CHGVAR     VAR(&SR) VALUE('AX')
             CHKOBJ     OBJ(AISINX) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(@SKP1))

             CLRPFM     FILE(AB#WAI4)
             CALL       PGM(A#R0777O) PARM(&PID)

             ENDDO
  /*=================================================================*/
  @SKP1:

  @END:
             DLTOVR     FILE(*ALL)
             ENDPGM
