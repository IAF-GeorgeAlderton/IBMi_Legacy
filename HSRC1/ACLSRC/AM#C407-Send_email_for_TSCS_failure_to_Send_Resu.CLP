             PGM
             /** AM#C407 ***************************/
             /* SEND EMAIL FOR TSCS FAILURE TO SEND*/
             /*      RESULT MESSAGE.               */
             /*   LEC.             2021.10.07      */
             /**************************************/

             DCL        VAR(&LMSG) TYPE(*CHAR) LEN(150)

             CHGVAR     VAR(&LMSG) +
                          VALUE('Pallet/Load Transmission +
                          to Toyota SCS did NOT receive back a +
                          response.  Result Message was blank.')

  /*     send email to recipients                                  */
             SNDDST     TYPE(*LMSG) TOINTNET((Larry.Cox@iafi.com)) +
                          DSTD('TSCS - Result Message is blank.')  +
                          LONGMSG(&LMSG)

             SNDDST     TYPE(*LMSG) +
                          TOINTNET((Jonathon.Julson@iafi.com)) +
                          DSTD('TSCS - Result Message is blank.')  +
                          LONGMSG(&LMSG)

             SNDDST     TYPE(*LMSG) +
                          TOINTNET((Kaz.Watanabe@iafi.com)) +
                          DSTD('TSCS - Result Message is blank.')  +
                          LONGMSG(&LMSG)

             SNDDST     TYPE(*LMSG) +
                          TOINTNET((Shipping@iafi.com)) +
                          DSTD('TSCS - Result Message is blank.')  +
                          LONGMSG(&LMSG)

 #END:       ENDPGM
