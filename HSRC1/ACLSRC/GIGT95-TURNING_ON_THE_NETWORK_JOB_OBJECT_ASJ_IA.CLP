/** GIGT95 *****************************************/
/*   TURNING ON THE NETWORK JOB <OBJECT> ASJ-->IAF */
/*                            K.YASUDA  1997.10.06 */
/***************************************** GIGT95 **/
//BCHJOB   JOB(GIGT95) JOBD(QBATCH4) JOBQ(JOBQ4) MSGQ(QSYSOPR)
CALL       PGM(GIGC97) PARM('GIGWP52')
//ENDBCHJOB
