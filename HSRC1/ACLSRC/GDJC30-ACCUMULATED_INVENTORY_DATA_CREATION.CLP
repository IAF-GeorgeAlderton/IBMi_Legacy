             /**** GDGC30 ****************************************************/
             /*      ACCUMULATED INVENTORY DATA CREATION                     */
             /*        GBC                              97/02/20             */
             /****************************************************************/
             PGM
             DCLF       FILE(GDJPW30)

 ##1:        SNDRCVF    RCDFMT(DSP01)
             IF  (&IN01 = '1')  GOTO END
             IF  (&IN05 = '1')  GOTO ##2
             GOTO ##1

##2:
             CALL       PGM(GDJR30)    /* PARTS */
             CALL       PGM(GDJR31)    /* DIE   */

END:         ENDPGM
