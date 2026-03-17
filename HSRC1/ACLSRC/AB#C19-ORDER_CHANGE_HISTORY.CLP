             PGM
             /***AB#C19********************************************/
             /* ORDER CHANGE HISTORY                                   -EDP */
             /*         JAN/22/2004  TCH                          */
             /* TCHK1 08/20/14 ADD WORK-FILE FOR DISPLAYSEQ CHANGE*/
             /* -----------------------------------               */
             /* JW1   2023.06.07 CHG AB#WHP10 -->  AB#WP1H        */
             /*****************************************************/

             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

/* TCHK1 S */
       /**JW CRTDUPOBJ  OBJ(AB#WHP10) FROMLIB(HWFILE1) +        **/
       /**                OBJTYPE(*FILE) TOLIB(QTEMP)           **/
       /**   MONMSG     MSGID(CPF0000)                          **/
       /**   CLRPFM     QTEMP/AB#WHP10                          **/
       /**   OVRDBF     FILE(AB#WHP10) TOFILE(QTEMP/AB#WHP10)   **/
/* JW1   */
             CRTDUPOBJ  OBJ(AB#WP1H ) FROMLIB(HWFILE1) +
                          OBJTYPE(*FILE) TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     QTEMP/AB#WP1H
             OVRDBF     FILE(AB#WP1H ) TOFILE(QTEMP/AB#WP1H )

/* TCHK1 E */
             CALL       PGM(AB#R19) PARM('' '99999999' '' '' '')

             ENDPGM
