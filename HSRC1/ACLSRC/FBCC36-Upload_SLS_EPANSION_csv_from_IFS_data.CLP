             PGM
             /*** FBCC36 ************************************/
             /*   UPLOAD SLS-EPANSION.CSV FROM IFS DATA     */
             /*   JW (SRA)    2021.05.21                    */
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
             DCL        VAR(&UPFLG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PFLG ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&KEN )  TYPE(*DEC ) LEN(10 0)
             DCL        VAR(&NBR )  TYPE(*CHAR) LEN(6)
             DCL        VAR(&RTN1)  TYPE(*CHAR) LEN(1)

/* CHECK OTHER USER IS USING  ======================================*/
             CALL       PGM(CHKC45) PARM('FBCC36' 'FBCC36' 'Y' 'CHK' &RTN1)
             IF         COND(&RTN1 *NE ' ') THEN(GOTO @ENDP0)
/* =================================================================*/

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CLRPFM     FILE(HWFILE1/FBCWP36A)

  /* ======= UPLOAD =========*/
             CALL       PGM(FBCR36) PARM(&UPFLG)

  /* SKIP TO ENDP WHEN NO DATA TO UPLOAD */
             IF         COND(&UPFLG *NE 'Y') THEN(GOTO CMDLBL(@ENDP1))

  /* SAVE FBCWP36A TO FBCWP36S  */
             CALL       PGM(FBCR36B)
 @ENDP1:
             CALL       PGM(CHKC45) PARM('FBCC36' 'FBCC36' 'N' '' '')

 @ENDP0:     DLTOVR     FILE(*ALL)
             ENDPGM
