             PGM
             /** AM#C406 ***************************/
             /* SEND EMAIL FOR TSCS OPEN FAILURE   */
             /*   LEC.             2021.06.16      */
             /**************************************/

             DCL        VAR(&LMSG) TYPE(*CHAR) LEN(150)

             CHGVAR     VAR(&LMSG) +
                          VALUE('Pallet/Load Transmission +
                          to Toyota SCS Failed.  Could not +
                          open JPA EntityManager.  Post Status - 500.')

  /*     send email to recipients                                  */
             SNDDST     TYPE(*LMSG) TOINTNET((Larry.Cox@iafi.com)) +
                          DSTD('TSCS - Post Status Error 500')  +
                          LONGMSG(&LMSG)

             SNDDST     TYPE(*LMSG) +
                          TOINTNET((Jonathon.Julson@iafi.com)) +
                          DSTD('TSCS - Post Status Error 500')  +
                          LONGMSG(&LMSG)

             SNDDST     TYPE(*LMSG) +
                          TOINTNET((Kaz.Watanabe@iafi.com)) +
                          DSTD('TSCS - Post Status Error 500')  +
                          LONGMSG(&LMSG)

             SNDDST     TYPE(*LMSG) +
                          TOINTNET((Shipping@iafi.com)) +
                          DSTD('TSCS - Post Status Error 500')  +
                          LONGMSG(&LMSG)

 #END:       ENDPGM
