             PGM
             /** FCJC21 *******************************************/
             /* PRECEDING PROCESS M/F COMMON RIVET ACCOUNT BOOK PRINT OP-EDP */
             /*            M-OKUDA        1983.11.10              */
             /* TCHK1 03/15/12 CHG OUTQ                           */
             /* JW1   2018.09.07 CHG ERROR MSG FOR USING OTHER */
             /** * * * * * * * * * * * * * * * * * */
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&RTN1 ) TYPE(*CHAR) LEN(1)

/* JW1 CHECK OTHER USER IS USING  ==================================*/
             CALL CHKC45 ('AAVACT' 'FCJC21' 'Y'  'CHK' &RTN1)
             IF         COND(&RTN1 *NE ' ') THEN(GOTO END)
/* =================================================================*/

             RTVJOBA    JOB(&WSID) USER(&US)

             CHGJOB     RUNPTY(40)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

    /* JW1   CHKOBJ OBJ(AAVACT) OBJTYPE(*DTAARA)                          */
    /*                    USED CHECK                                      */
    /*       MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STEP04))          */
    /*                                                                    */
    /*       STEP05: SNDPGMMSG  MSG('( G ) PRESENT +                      */
    /*                       COMMON RIVET M/F IS USING ANOTHER DEPT. +    */
    /*                       PLEASE WAIT TO MAKE LISTS FOR A WHILE!!') +  */
    /*                    TOMSGQ(&WSID) MSGTYPE(*INQ) KEYVAR(&MBAN)       */
    /*       RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +          */
    /*                    MSG(&KOTAE)                                     */
    /*       IF         COND((&KOTAE *NE 'G') *AND (&KOTAE *NE 'g')) +    */
    /*                    THEN(GOTO CMDLBL(STEP05))                       */
    /*       RETURN                                                       */
    /*       GOTO       END                                               */
    /*                                                                    */
    /*       STEP04: CRTDTAARA  DTAARA(HFILE1/AAVACT) TYPE(*CHAR) LEN(10)+*/
    /*                    TEXT('FOR PRECEDING PROCESS HANDLING CHECK')    */
    /*                                                                    */
/*                                                                 */
/* TCHK1     OVRPRTF    FILE(QPRINT) PAGESIZE(88 132) LPI(8) +
                          OVRFLW(80) OUTQ(QPRINTC) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD) */
/* TCHK1 */  OVRPRTF    FILE(QPRINT) PAGESIZE(88 132) LPI(8) +
                          OVRFLW(80) OUTQ(QPRINTB) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)
/*           OVRPRTF    FILE(QPRINT) PAGESIZE(66 +                 */
/*                        132) LPI(6) OVRFLW(60)                   */
/*                                                                 */

             CALL       PGM(FCJR21) PARM(&US)
             DLTOVR     FILE(QPRINT)
      /*JW1* DLTDTAARA  DTAARA(AAVACT)*****************/
             CALL CHKC45 ('AAVACT' 'FCJC21' 'N'  '' '')

 END:        CHGJOB     RUNPTY(20)

             ENDPGM
