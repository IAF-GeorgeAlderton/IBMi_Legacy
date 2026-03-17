             PGM
/** AJAC83 ************************************************/
/*  .. STRPASTHR  IAF --> IAFAYM .(ASJ DEVELOPMENT)       */
/*     Y.SAMEJIMA       2021.01.26                        */
/************************************************ AJAC83 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&VWS) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID)

    /* GET COMMON DEVICE NAME */
             CALL       PGM(AJAR81) PARM(&VWS 'S')

    /* EXCEED 20 DEVICES */
             IF         COND(&VWS *EQ '          ') THEN(DO)
             SNDPGMMSG  MSG('Unable to PASS THROUGH from this +
                          termianl for a while. Please try again +
                          later.') TOMSGQ(&WSID)
             GOTO       END
             ENDDO

    /* START PASS-THROUGH */
             STRPASTHR  RMTLOCNAME(IAFYAM) VRTDEV(&VWS) MODE(#INTER) +
                          LCLLOCNAME(IAF) RMTNETID(NETNMS1)

             MONMSG     MSGID(CPF8921 CPF8916) EXEC(DO)
             SNDPGMMSG  MSG('EITHER THIS TERMINAL IS DISCONNECTED TO +
                          AS/400 IN JAPAN, OR UNABLE TO PASS +
                          THROUGH FROM THIS TERMINAL. OR, THE PASS +
                          THROUGH LINE IS NOT ACTIVATED.') +
                          TOMSGQ(&WSID)
             GOTO       END
             ENDDO

             MONMSG     MSGID(CPF8936) EXEC(DO)
             SNDPGMMSG  MSG('THE PASSWORD OF AS/400 IN JAPAN IS +
                          EITHER WRONG OR NOT REGISTERED VERIFY.') +
                          TOMSGQ(&WSID)
             GOTO       END
             ENDDO

             MONMSG     MSGID(CPF8905 CPF8933) EXEC(DO)
             SNDPGMMSG  MSG('EITHER THAT THE POWER OF AS/400 IS OFF, +
                          OR THAT THE LINE IS NOT ACTIVATED +
                          VERIFY.') TOMSGQ(&WSID)
             ENDDO

    /* UNLOCK COMMON DEVICE NAME MASTER */
             CALL       PGM(AJAR81) PARM(&VWS 'E')

 END:        ENDPGM
