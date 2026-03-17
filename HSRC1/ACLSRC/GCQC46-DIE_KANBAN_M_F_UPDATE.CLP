             PGM
             /********************************************/
             /*     DIE KANBAN M/F UPDAT                 */
             /*     GCQC46.      <CLP>                   */
             /*     98.06.29                             */
             /*     MSK KUNIEDA                          */
             /********************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

       /*    CHGJOB     OUTQ(QPRINTB)  */
             CHGJOB     OUTQ(QPRINTD)
             CALL       PGM(GCQR46) PARM(&USER)

             ENDPGM
