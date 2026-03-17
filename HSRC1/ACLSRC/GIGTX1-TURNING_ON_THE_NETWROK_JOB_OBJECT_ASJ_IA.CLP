/** GIGT96 *****************************************/
/*   TURNING ON THE NETWROK JOB <OBJECT> ASJ-->IAF */
/*                            K.YASUDA  1997.10.08 */
/***************************************** GIGT96 **/
//BCHJOB   JOB(GIGTX1) JOBD(QBATCH4) JOBQ(JOBQ4) MSGQ(QSYSOPR)
CALL       PGM(GIGCX1) PARM('INVOIS')
//ENDBCHJOB
