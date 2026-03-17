             /**** GDGC01 ****************************************************/
             /*      INVENTORY UNIT PRICE M/F CREATION                       */
             /*        GBC                              97/02/20             */
             /****************************************************************/
             PGM
             DCLF       FILE(GDJPW01)

 ##1:        SNDRCVF    RCDFMT(DSP01)
             IF  (&IN01 = '1')  GOTO END
             IF  (&IN05 = '1')  GOTO ##2
             GOTO ##1

##2:
             CLRPFM     FILE(GDJPP01)
             CALL       PGM(GDJR01) /* PARTS */
             CALL       PGM(GDJR05) /* DIE   */

END:         ENDPGM
