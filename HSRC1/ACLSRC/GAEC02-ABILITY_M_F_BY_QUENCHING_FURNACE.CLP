             PGM
             /******************************************/
             /* PROGRAM NAME : ABILITY M/F BY QUENCHING FURNACE*/
             /*               LIST                   */
             /* PROGRAM ID : GAEC02 <CL>               */
             /* CREATE DATE : 87.04.29                 */
             /* AUTHOR : G.TANAKA                      */
             /******************************************/
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             RTVJOBA    JOB(&WS)
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)
 STP1:
             OVRPRTF    FILE(GAEPR02) DEVTYPE(*AFPDS) LPI(6) +
                          OVRFLW(60) RPLUNPRT(*YES) OUTQ(QPRINTA) +
                          FORMTYPE(K6H1)
             CALL       PGM(GAER02)
             DLTOVR     FILE(GAEPR02)
 END:        ENDPGM
