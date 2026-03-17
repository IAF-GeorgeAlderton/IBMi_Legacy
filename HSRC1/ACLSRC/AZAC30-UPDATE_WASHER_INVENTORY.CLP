             PGM
             /** AZAC30 **********************************************/
             /*  UPDATE WASHER INVENTORY                             */
             /*                                                      */
             /*  TCH 02.07.19                                        */
             /********************************************** AZAC30 **/
             DCLF       FILE(AZAPW3C)

 STP1:       CHGVAR     VAR(&OPT) VALUE(' ')
             SNDRCVF    RCDFMT(DSP01)

             IF         (&IN01 *EQ '1') GOTO END

             IF         COND(&OPT *EQ '1') THEN(DO)
             CALL AZAR30
             ENDDO

             IF         COND(&OPT *EQ '2') THEN(DO)
             CALL AZAR32
             ENDDO

             GOTO       CMDLBL(STP1)

 END:
             ENDPGM
