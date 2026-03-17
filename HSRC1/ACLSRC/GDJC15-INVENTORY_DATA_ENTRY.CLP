             /**** GDGC15 ****************************************************/
             /*      INVENTORY DATA ENTRY                                    */
             /*         GBC                             97/02/20             */
             /****************************************************************/
             PGM
             DCLF GDJPW15
##1:         CHGVAR &D1NO 1
             CHGVAR &IN10 '0'
##2:         SNDRCVF RCDFMT(DSP01)
               IF  (&IN01 = '1') GOTO END
               IF  (&D1NO = 1)   DO
                                 CALL  PGM(GDJR16)
                                 ENDDO
               IF  (&D1NO = 2)   DO
                                 CALL  PGM(GDJR17)
                                 ENDDO
END:         ENDPGM
