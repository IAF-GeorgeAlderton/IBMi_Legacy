             PGM
/** AB#CG8 *************************************************/
/*  EDI FORECAST IC CODE EDIT (FORD)                       */
/************************************** AB#CG8 *************/

             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&PD)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&CNT)  TYPE(*DEC) LEN(10 0)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

/******************************************************************************/
/* run program to list all ic codes not found in Ford route master.           */

             OVRPRTF    FILE(QPRINT) OUTQ(EPRINT1) FORMTYPE(K6H1) +
                          HOLD(*YES) SAVE(*YES)

             OVRDBF     FILE(EBAEP10) TOFILE(TWFILE1/EBAEP10)

             CALL       PGM(AB#RG8) PARM(&PD)


             DLTOVR     FILE(*ALL)
@END:

             ENDPGM
