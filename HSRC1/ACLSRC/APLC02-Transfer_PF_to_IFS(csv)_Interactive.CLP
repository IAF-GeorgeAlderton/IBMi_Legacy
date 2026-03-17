PGM
             /**** APLC02 *****************************************/
             /* TRANSFER PF TO CSV                                */
             /* JW  2019.10.24                                    */
             /*****************************************************/
             DCLF       FILE(APLPW02)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)

 /* DEFAULT */
             CHGVAR     VAR(&XTYPE) VALUE('2')
             CHGVAR     VAR(&XFIL ) VALUE('PF')
             CHGVAR     VAR(&XLIB ) VALUE('HFILE1')
             CHGVAR     VAR(&XFILN) VALUE('DATA TRANSFER')
             CHGVAR     VAR(&XCSV ) VALUE('C')
             CHGVAR     VAR(&XCLM ) VALUE('Y')

             RTVJOBA    JOB(&WSID)
 @DSP1:
             SNDRCVF    DEV(&WSID) RCDFMT(DSP01)

             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(@EXIT))

             CHGVAR     VAR(&IN41) VALUE('0')
             CHGVAR     VAR(&IN42) VALUE('0')
             CHGVAR     VAR(&IN43) VALUE('0')
             CHGVAR     VAR(&IN44) VALUE('0')
             CHGVAR     VAR(&IN45) VALUE('0')
             CHGVAR     VAR(&IN46) VALUE('0')

             IF         COND((&XTYPE *NE '1') *AND (&XTYPE *NE '2')) +
                          THEN(DO)
             CHGVAR     VAR(&IN41) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('ENTER TYPE 1 OR 2 !')
             GOTO @DSP1
             ENDDO

             IF         COND(&XFIL  *EQ ' ') THEN(DO)
             CHGVAR     VAR(&IN42) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('ENTER FILE !')
             GOTO @DSP1
             ENDDO

             IF         COND(&XLIB  *EQ ' ') THEN(DO)
             CHGVAR     VAR(&IN43) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('ENTER LIBRARY !')
             GOTO @DSP1
             ENDDO

             IF         COND(&XFILN *EQ ' ') THEN(DO)
             CHGVAR     VAR(&IN44) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('ENTER FILE NAME !')
             GOTO @DSP1
             ENDDO

             IF         COND((&XCSV *NE 'C') *AND (&XCSV *NE 'N') +
                          *AND (&XCSV *NE 'T')) THEN(DO)
             CHGVAR     VAR(&IN45) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('CSV SHOULD BE C, T OR N !')
             GOTO @DSP1
             ENDDO

             IF         COND((&XCLM *NE 'Y') *AND (&XCLM *NE 'N')) +
                          THEN(DO)
             CHGVAR     VAR(&IN46) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('IT SHOULD BE Y OR N !')
             GOTO @DSP1
             ENDDO

             IF         COND(&IN05 *NE '1') THEN(DO)
             CHGVAR     VAR(&XMSG) VALUE('PRESS F5 TO RUN...')
             GOTO       @DSP1
             ENDDO

             CALL       PGM(APLC94 ) PARM(&XTYPE &XFIL &XLIB &XFILN +
                          &XCSV &XCLM 'Y')
 @EXIT:
             ENDPGM
