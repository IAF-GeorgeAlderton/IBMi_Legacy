             PGM
             /** AB#CG6 **********************************************/
             /*  FORD EDI(997) MESSAGE                               */
             /*  J.WATANABE 2025.09.23                               */
             /********************************************************/

             DCL        VAR(&PD)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             OVRPRTF    FILE(QPRINT) OUTQ(SAVEOUTQ) HOLD(*YES)
             OVRDBF     FILE(AB#PP6U) TOFILE(TFILE1/AB#PP6U)

             CALL       PGM(AB#RG6A) PARM((&PD))

 /***************/
 /** GOTO ENDP **/
 /***************/

 /** TRANSFER QPRINT TO PRT132A **/
             IF         (&PD *EQ '1') THEN(DO)
             CRTDUPOBJ  OBJ(PRT132A) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/PRT132A)
             CPYSPLF    FILE(QPRINT) TOFILE(QTEMP/PRT132A) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132) TOFILE(QTEMP/PRT132A)
             CALL       PGM(AB#RW0)

 /** DOWNLOAD PRT132A TO IFS.CSV **/






             DLTOVR     FILE(PRT132)
             ENDDO
ENDP:
             ENDPGM
