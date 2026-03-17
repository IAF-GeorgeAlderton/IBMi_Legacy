             /**** GDGC08 ****************************************************/
             /*      INVENTORY DATA CV (BAR CODE READER -> AS/4--)           */
             /*        GBC                              97/02/20             */
             /****************************************************************/
             PGM
             DCLF       FILE(GDJPW08)

##1:         SNDRCVF RCDFMT(DSP01)
             IF  (&IN01 = '1')  GOTO END
             IF  (&IN05 = '1')  GOTO ##2
             GOTO ##1

##2:
             CALL       PGM(GDJR08)
             CLRPFM     FILE(GDJWP15)

END:         ENDPGM
