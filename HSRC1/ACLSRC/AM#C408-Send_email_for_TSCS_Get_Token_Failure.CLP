             PGM
             /** AM#C408 ***************************/
             /* SEND EMAIL FOR GET TOKEN FAILURE   */
             /*      MESSAGE.                      */
             /*   LEC.             2022.01.21      */
             /**************************************/

             DCL        VAR(&LMSG) TYPE(*CHAR) LEN(150)

             CHGVAR     VAR(&LMSG) VALUE('Get TOKEN for Service Pa+
                          rts SCS did NOT receive back a +
                          response.  Result Message was blank.')

  /*     send email to recipients                                  */
  /****      SNDDST     TYPE(*LMSG) TOINTNET((Larry.Cox@iafi.com)) +
                          DSTD('Get TOKEN for SP SCS failed.')  +
                          LONGMSG(&LMSG)   *****/


  /*****************************************************************/

             RETURN

  /*****************************************************************/


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
