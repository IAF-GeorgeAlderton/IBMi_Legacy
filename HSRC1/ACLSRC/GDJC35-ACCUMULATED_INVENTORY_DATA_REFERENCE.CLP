             /**** GDGC35 ****************************************************/
             /*      ACCUMULATED INVENTORY DATA REFERENCE                */
             /*         GBC                             97/02/20             */
             /****************************************************************/
             PGM

             DCLF GDJPW35
##1:         CHGVAR &D1NO 1
             CHGVAR &IN10 '0'
##2:         SNDRCVF RCDFMT(DSP01)
               IF  (&IN01 = '1') GOTO END
               IF  (&D1NO = 1)   DO
                                 CALL  PGM(GDJR36)
                                 ENDDO
               IF  (&D1NO = 2)   DO
                                 CALL  PGM(GDJR37)
                                 ENDDO
             GOTO ##2

END:         ENDPGM
