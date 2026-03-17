             PGM
/** AB#C2Z ************************************************/
/*  ..EDI(830) FRS ORDER PROCESSING..                     */
/*                                                        */
/* TCHK1 06/12/09 ADD TEMPORARY CHANGE CALENDAR M/F       */
/* T.SAKAKI  05/13/15 CHANGE OUTQ FOR AB#R2G    %0001     */
/********************************************** AB#C20 ****/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USR)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PSIRE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KEN) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&END)  TYPE(*CHAR) LEN(1)

/* TCHK4 */  OVRDBF     FILE(AGDPP11) TOFILE(TFILE1/A@DPP11)
/* TCHK4 */  OVRDBF     FILE(AGDPL11) TOFILE(TFILE1/A@DPL11)
/* TCHK4 */  OVRDBF     FILE(AGDPL12) TOFILE(TFILE1/A@DPL12)

             RTVJOBA    JOB(&WSID) USER(&USR)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USR &WLIB)

             DLTF       FILE(QTEMP/AB#WP2A)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP2A) RCDLEN(100) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AB#WP2A) TOFILE(QTEMP/AB#WP2A)
             DLTOVR     FILE(QPRINT)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(AB#R2Z) PARM(&END)

             IF         COND(&END *EQ '1') THEN(GOTO CMDLBL(@END))


             RTVMBRD    FILE(QTEMP/AB#WP2A) NBRCURRCD(&KEN)
             IF         (&KEN *GT 0) THEN(DO)
          /* %0001 */
          /* OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1) IGCDTA(&PIGCD) */
             OVRPRTF    FILE(QPRINT) PAGESIZE(66 132) OVRFLW(60) +
                          RPLUNPRT(*YES) OUTQ(LANPRT09) FORMTYPE(K6H1)
             CALL       PGM(AB#R2G) PARM(&PSIRE)
             DLTF       FILE(QTEMP/AB#WP2A)
             ENDDO


 @END:        ENDPGM
