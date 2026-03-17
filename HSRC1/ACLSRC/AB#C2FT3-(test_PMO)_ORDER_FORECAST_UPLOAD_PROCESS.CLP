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
             CHGVAR     VAR(&PRTG) VALUE('LANPRT03  ')
             CALL       PGM(ALBC00) PARM(&USER &WLIB)
             CHGJOB     SWS(00000000)

             CHGVAR     VAR(&WLIB) VALUE('TWFILE1')

             CHGVAR     VAR(&PSIRE) VALUE('0681')

/* PMO ************************************************************/
             IF         COND(&PSIRE *EQ '0681') THEN(DO)
             CHGVAR     VAR(&SR) VALUE('PM')

             OVRDBF     FILE(AB#WPMO) TOFILE(&WLIB/AB#WPMO)
             CLRPFM     FILE(AB#WPMO)
             OVRDBF     FILE(PMO)     TOFILE(TWFILE1/PMO)
             CALL       PGM(A#R0681O) PARM(&PID)


             OVRDBF     FILE(ABAWPMF) TOFILE(&WLIB/ABAWPMF)
             CLRPFM     FILE(ABAWPMF)
             CALL       PGM(A#R0681F) PARM(&ID)

      /****  DLTF       FILE(PMO)  ****/

        /**  IF         COND(&ID *NE ' ') THEN(DO)                    **/
        /**             OVRPRTF    FILE(QPRINT2) LPI(6) +             **/
        /**                          RPLUNPRT(*YES) OUTQ(EPRINT1 ) +  **/
        /**                          FORMTYPE(K6H1) HOLD(*YES)        **/
        /**             CALL       PGM(ABAR1K)                        **/
        /**             DLTOVR     FILE(QPRINT2)                      **/
        /**             CALL       PGM(ABACP6) PARM(&PSIRE)           **/
        /**  ENDDO                                                    **/

             ENDDO

  /*=================================================================*/
  ENDP:
             DLTOVR     FILE(*ALL)
             ENDPGM
