             PGM
             /*** MCEC15 *****************************/
             /*   INQUIRY OF ACTUAL COMPONENT USED   */
             /*        G.B.C         89.05.24        */
             /*        K.YASUDA    2005.01.24        */
             /******************* COPY FROM MCEC13 ***/
             DCL        VAR(&YYMM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             RTVDTAARA  DTAARA(MCEDS1) RTNVAR(&YYMM)
             RTVJOBA    JOB(&WSNO) USER(&USER)
             CHGJOB     SWS(00000000)

             CALL       PGM(AGAR00) PARM(&WSNO &PRT &TYPE &PRTG)

 STEP02:     CHGJOB     OUTQ(&PRTG)

             CALL       PGM(MCER13) PARM(&YYMM)

             ENDPASTHR
 END:        ENDPGM
