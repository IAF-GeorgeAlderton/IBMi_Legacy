             PGM
             /**** GDAC10 *****************************************/
             /*  MATERIAL ORDER SUMMARIZATION                     */
             /*               TCH  FEB/06/2003                    */
             /*****************************************************/
             DCL        VAR(&PPUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&END) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)
             RTVJOBA    JOB(&WSID) USER(&PPUSER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             OVRPRTF    FILE(QPRINT) OUTQ(&PRTG) FORMTYPE(K6H1)
             CALL       PGM(GDAR10) PARM(&END)
             IF         (&END *EQ '1')   GOTO END

     /*      CPYF       FROMFILE(GDAPP01)  TOFILE(QTEMP/GDAPP01X) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          INCREL((*IF IVSYHZ *EQ 0))  */
    /*       MONMSG     MSGID(CPF0000)   */

    /*       RTVMBRD    FILE(QTEMP/GDAPP01X) NBRCURRCD(&REC)  */
    /*       IF         COND(&REC *EQ 0) THEN(CLRPFM FILE(GDAPP01)) */
    /*       ELSE       CMD(DO) */

    /*       CPYF       FROMFILE(QTEMP/GDAPP01X) TOFILE(GDAPP01) +
                          MBROPT(*REPLACE)  */
    /*       MONMSG     MSGID(CPF0000)  */
    /*       ENDDO      */


             /* PRINT OF KANBAN TOTAL LIST */
             OVRPRTF    FILE(QPRINT) OUTQ(&PRTG) FORMTYPE(K6H1)
             CALL GDAR15
             CALL GDAR17

 END:        ENDPGM
