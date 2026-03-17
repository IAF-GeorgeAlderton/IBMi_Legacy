             PGM
             /** EJCC01 *************************************/
             /*  FORD S856 CONVERT AND RESIGTER FOR B2B_S   */
             /*    T.SAKAKI                   2016.11.29    */
             /*                                             */
             /* ******************************************* */
             /* * NEED TO REGISTER TO EJKPP10 IN ADVANCE  * */
             /* ******************************************* */
             /* JW1     2017.11.06 CHG JOBQ TO JOBQ7        */
             /*********************************** EJCC01 ****/

     /* CHG JOBQ6 TO JOBQ7 (JW1)                                      */
             SBMJOB     CMD(CALL PGM(EB#CXS) PARM(' ' ' ')) +
                          JOB(EB#CXS) JOBD(QBATCH) JOBQ(JOBQ7) +
                          USER(B2BUSER) RTGDTA(*JOBD) +
                          INLLIBL(*JOBD) LOG(4 00 *SECLVL) +
                          LOGCLPGM(*YES)

             ENDPGM
