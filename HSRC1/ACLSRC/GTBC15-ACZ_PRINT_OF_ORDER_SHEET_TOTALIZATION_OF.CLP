             PGM
             /**** GDGC15 *****************************************/
             /*  RE-PRINT DATA SUMMARY LIST                       */
             /*  N.HYOTO    2001/04/25                            */
             /*  TCH56 TCH 05/05/05 CHANGED SORTING FOR GDGR15    */
             /*  TCHK1 TCH 05/06/09 ADD PREVIOUS ORDER DATE       */
             /*****************************************************/

/* TCHK1 */  DCL        VAR(&PRVDATE) TYPE(*CHAR) LEN(6)

             /* PRINT OF KANBAN TOTAL LIST */
/* TCH56     OVRPRTF    FILE(QPRINT) OUTQ(QPRINTB) FORMTYPE(K6H1) */
/* TCHK2     OVRPRTF    FILE(QPRINT2) OUTQ(QPRINTB) FORMTYPE(K6H1) */
/* TCHK2 */  OVRPRTF    FILE(QPRINT2) OUTQ(QPRINT)  FORMTYPE(K6H1)
             CLRPFM     FILE(HWFILE1/GDGWP15)
             MONMSG     MSGID(CPF0000)
/* TCHK1 START */
/* TCHK1     CALL GDGR15 */
             RTVDTAARA  DTAARA(GDGC12DATE) RTNVAR(&PRVDATE)
             CALL GDGR15 PARM(&PRVDATE)
/* TCHK1 END */
   /*        DLTOVR QPRINT       */
             DLTOVR QPRINT2

 END:        ENDPGM
