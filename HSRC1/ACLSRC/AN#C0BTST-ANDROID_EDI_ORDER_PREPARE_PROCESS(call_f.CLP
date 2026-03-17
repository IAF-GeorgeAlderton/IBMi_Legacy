  PGM
/** AN#C0B ************************************************/
/*  ANDROID EDI ORDER PREPARE PROCESS                     */
/*                                                        */
/* TCHK1 07/10/06 CREATE(COPY FROM AB#C0B)                */
/**********************************************************/

             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CNT) TYPE(*DEC) LEN(10 0)

             RTVMBRD    FILE(AB#EP51@) NBRCURRCD(&CNT)
             IF         COND(&CNT *EQ 0) THEN(GOTO CMDLBL(@END))


/* CLEAR 1PROCESS FILE */
             CLRPFM     FILE(ABR1P01)
             MONMSG     MSGID(CPF0000)

/* CREATE 1PROCESS FILE */
             OVRDBF     FILE(AB#EP51) TOFILE(HFILE1/AB#EP51@)
             CALL       PGM(AN#R0E)

/* PRINT DATA LIST */
             OVRPRTF    FILE(QPRINT) OUTQ(QDKT)
             CALL       PGM(AN#RF2)
             DLTOVR     FILE(QPRINT)

/*                 */
             CPYF       FROMFILE(ABR1P01) TOFILE(ABRHP01) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(AN#RF7F4)

          /* CLRPFM     FILE(AB#EP51) */

             DLTOVR     FILE(*ALL)
@END:

             ENDPGM
