/** AJBT68 **************************************/
/*  ..AS/400 IAF--->AOYAMA DATABASE TRANSFER..  */
/*      I-HASADA                  97.12.22      */
/************************************** AJBT68 **/
//BCHJOB   JOB(SBMJOB2) JOBD(QBATCH5) JOBQ(JOBQ5) MSGQ(QSYSOPR)
CALL       PGM(AJBC68) PARM('PGMR      ' 'LIBR      ')
//ENDBCHJOB
