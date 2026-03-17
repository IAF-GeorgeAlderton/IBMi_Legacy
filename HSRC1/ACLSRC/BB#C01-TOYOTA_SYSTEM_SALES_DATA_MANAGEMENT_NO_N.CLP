             PGM
             /** BB#C01 ************************************/
             /* TOYOTA SYSTEM SALES DATA MANAGEMENT NO. NO DATA LIST */
             /* PROGRAM ID. : BB#C01. <RPG> */
             /* CREATE DATE. : JAN.18,'90.                 */
             /* AUTHOR.         : K.NAKAMURA                */
             /************************************ BB#C01 **/
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             RTVJOBA    JOB(&WS)
             CALL       PGM(KZZR00) PARM(&WS &PRT &TYPE &PRTG)

             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1)
             CALL       PGM(BB#R01)
             DLTOVR     FILE(QPRINT)

             ENDPGM
