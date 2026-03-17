             PGM
             /** FCEC61 ***************************************/
             /*  SERVICE PARTS LIST                           */
             /*    TCH                            01.10.16    */
             /* TCHK1 05/07/09 ADD FCER61                     */
             /*************************************************/
             DCLF       FILE(FCEPW61)

 @STRT:
             SNDRCVF    RCDFMT(DSP01)
             CHGVAR     VAR(&IN61) VALUE('0')

             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(@END))

             IF         COND(&D@OPT *NE '1' *AND &D@OPT *NE '2') +
                          THEN(CHGVAR VAR(&IN61) VALUE('1'))

             IF         COND(&IN05 *EQ '1' *AND &IN61 *EQ '0') THEN(DO)
/* TCHK1 */
/* TCHK1 */  CLRPFM     FILE(HWFILE1/FCEWP30)
/* TCHK1 */  CALL       FCER61
/* TCHK1 */
             IF         COND(&D@OPT *EQ '1') THEN(RUNQRY +
                          QRY(HOBJ1/QFCEP301))
             IF         COND(&D@OPT *EQ '2') THEN(RUNQRY +
                          QRY(HOBJ1/QFCEP302))

             GOTO       CMDLBL(@END)
             ENDDO

             GOTO       CMDLBL(@STRT)

 @END:        ENDPGM
