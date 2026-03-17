//BCHJOB   JOB(ABMT63) JOBD(QBATCH4X) JOBQ(JOBQ4) MSGQ(QSYSOPR)
SETASPGRP  ASPGRP(IASP01) USRLIBL(QGPL QTEMP QEVX APWLIB +
             ASJFILE ASJWFILE ASJOBJ APLIB APWRKLIB APGMLIB FILELIB +
             WORKLIB PGMLIB SRCLIB IKLIB IKWRKLIB IPGMLIB +
             OALIB OAWRKLIB OPGMLIB JRNLIB TLIBRARY APSAVLIB)
CALL       PGM(ABMC63)
//ENDBCHJOB
/** ABMT63 ***********************************************************/
/*  <ＩＡＦ> SBMNETJOB -->１号機ABMC63                           */
/*----------+-----+----------+---------------------------------------*/
/*2021.07.16|TEC. |T.MITSUI  | INITIAL VERSION.                      */
/*********************************************************** ABMT63 **/
