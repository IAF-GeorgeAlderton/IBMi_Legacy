             PGM
             /*** AFFC60 ************************************/
             /*   RE-CREATE INVOICE USING TMQTY.CSV         */
             /*   JW (SRA)    2024.03.15                    */
             /***********************************************/
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PFLG ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&KEN )  TYPE(*DEC ) LEN(10 0)
             DCL        VAR(&NBR )  TYPE(*CHAR) LEN(6)
             DCL        VAR(&RTN1)  TYPE(*CHAR) LEN(1)

/* CHECK OTHER USER IS USING  =============================================*/
             CALL   PGM(CHKC45) PARM('INVOICE' 'AFFC60' 'Y' 'CHK' &RTN1)
             IF         COND(&RTN1 *NE ' ') THEN(GOTO @ENDP )
/* ========================================================================*/

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CLRPFM     FILE(HWFILE1/AFFWP60)
             CLRPFM     FILE(HWFILE1/AFFWP61)

/* UPLOAD TMQTY.CSV TO AFFWP60, AND COPY IT TO AFFWP61 */
             OVRDBF     FILE(AFFWP60) TOFILE(HWFILE1/AFFWP60)
             OVRDBF     FILE(AFFWP61) TOFILE(HWFILE1/AFFWP61)
             CALL       PGM(AFFR60)
 @ENDP2:
             CALL       PGM(CHKC45) PARM('INVOICE' 'AFFC60' 'N' '' '')

 @ENDP:      DLTOVR     FILE(*ALL)
             ENDPGM
