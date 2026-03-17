/** GIGT96 *****************************************/
/*   TURNING ON THE NETWROK JOB <OBJECT> ASJ-->IAF */
/*                            K.YASUDA  1997.10.08 */
/***************************************** GIGT96 **/
//BCHJOB   JOB(GIGT96) JOBD(QBATCH4) JOBQ(JOBQ4) MSGQ(QSYSOPR)
CALL       PGM(GIGC97) PARM('GIGWP53')
//ENDBCHJOB
