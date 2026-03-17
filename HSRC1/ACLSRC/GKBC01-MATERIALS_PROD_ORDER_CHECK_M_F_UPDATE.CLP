             PGM
             /*** GKBC01 *************************************/
             /* MATERIALS PROD.    ORDER CHECK M/F UPDATE */
             /*            H.ITO          88.08.26           */
             /*                                              */
             /* TCHK1 08/11/08 CHG PRINT(QPRINT) HOLD        */
             /* TCHK2 11/10/08 BUG FIX                       */
             /************************************* GKBC01 ***/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SW) TYPE(*CHAR) LEN(8)
             RTVJOBA    JOB(&WSNO) USER(&USER)
             CHGJOB     SWS(00000000)
             CALL       PGM(AGAR00) PARM(&WSNO &PRT &TYPE &PRTG)

 STEP02:
             CHGJOB     OUTQ(&PRTG)

             DLTF       FILE(GKBWP01)
             MONMSG     MSGID(CPF3261 CPF2105)
/* TCHK2     CRTPF      FILE(HWFILE/GKBWP01) RCDLEN(128) + */
/* TCHK2 */  CRTPF      FILE(HWFILE1/GKBWP01) RCDLEN(128) +
                          OPTION(*NOLIST) SIZE(100 100) LVLCHK(*NO)
/* TCHK1     OVRPRTF    FILE(QPRINT) RPLUNPRT(*YES) OUTQ(&PRTG) +
                          IGCDTA(*YES) */
/* TCHK1 */  OVRPRTF    FILE(QPRINT) RPLUNPRT(*YES) OUTQ(&PRTG) +
                          IGCDTA(*YES) HOLD(*YES)
             CALL       PGM(GKBR01) PARM(&USER)
             DLTOVR     FILE(QPRINT)
             IF         (%SST(&SW 1 1) *EQ '1') GOTO END
             CALL       PGM(GKBRA1)
             DLTF       FILE(GKBWP01)

 END:
             MONMSG     MSGID(CPF2128)
             ENDPGM
