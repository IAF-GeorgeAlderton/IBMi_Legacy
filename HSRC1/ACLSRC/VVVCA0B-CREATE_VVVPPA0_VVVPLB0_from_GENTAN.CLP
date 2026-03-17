             PGM
             /** VVVCA0B *********************************/
             /* CREATE VVVPPA0/VVVPLB0 FROM GENTRAN      */
             /* JW   2016.04.28 ADD CALL                 */
             /********************************************/

             DSPPGMREF  PGM(G3X1CUSOBJ/*ALL) OUTPUT(*OUTFILE) +
                          OUTFILE(HWFILE1/VVVWPAG)

      /* DELETE NOT 'GENEDI ' BY STRSQL   **/

             ENDPGM
