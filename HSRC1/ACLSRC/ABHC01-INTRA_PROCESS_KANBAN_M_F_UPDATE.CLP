             PGM
             /*** ABHC01 ***************************************/
             /* INTRA-PROCESS KANBAN M/F UPDATE */
             /*         A.IDOTA             1995.01.18         */
             /* -----------------------------------------------*/
             /*  JW1   2023.05.08 ADD EXCLUSIVE CONTROL        */
             /**************************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTN2) TYPE(*CHAR) LEN(1)

/* CHECK OTHER USER IS USING  (JW1) ================================*/
             CALL       PGM(CHKC45) PARM('ABHC20' 'ABHC01' 'Y' 'CHK' &RTN2)
             IF         COND(&RTN2 *NE ' ') THEN(GOTO @ENDP2)
/* =================================================================*/

             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGJOB     OUTQ(&PRTG)

 STP1:       OVRDBF     FILE(AAJTL14) SHARE(*YES)
             OPNDBF     FILE(AAJTL14) OPTION(*ALL) OPNID(A01) +
                        TYPE(*PERM)
             MONMSG     MSGID(CPA0701 CPF4174)

             CALL       PGM(ABHR01) PARM(&WSID &USER)

             CLOF       OPNID(A01)
 @ENDP1:
             CALL       PGM(CHKC45) PARM('ABHC20' 'ABHC01' 'N' '' '')
 @ENDP2:
             ENDPGM
