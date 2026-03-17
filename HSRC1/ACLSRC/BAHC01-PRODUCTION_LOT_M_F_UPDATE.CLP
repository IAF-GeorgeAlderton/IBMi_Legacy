/** BTAT60 *****************************/
/* P/T    PLAN PUBLICATION M/F    LIST */
/*           T.SAKASHITA 2004.07.28    */
/***************************** BTAT60 **/
//BCHJOB   JOB(BTAT60) JOBD(QBATCH4) JOBQ(JOBQ4) MSGQ(QSYSOPR)
CALL       PGM(BTAC70) PARM('??????????')
CALL       PGM(BTAC71)
//ENDBCHJOB
