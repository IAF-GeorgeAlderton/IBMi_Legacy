          PGM        PARM(&TTL &MSG)
          /** MSGC10 **********************************************/
          /* MESSAGE SENDING PROGRAM  BY E-MAIL                   */
          /*   T.SAKAKI                          2016.10.13       */
          /********************************************** MSGC10 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TTL) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(256)

             RTVJOBA    USER(&USER)

             IF         COND(&USER *NE 'TEST') THEN(DO)
             SNDDST     TYPE(*LMSG) +
                          TOINTNET(('AS400-SYSTEM@IAFI.COM')) +
                          DSTD('B2B NOTIFICATION') LONGMSG(&MSG) +
                          DOCTYPE(*FFT) DOCD(&TTL)
                        ENDDO

             SNDDST     TYPE(*LMSG) +
                          TOINTNET(('T-SAKAKI@ASJ-FASTENERS.CO.JP')) +
                          DSTD('B2B NOTIFICATION') LONGMSG(&MSG) +
                          DOCTYPE(*FFT) DOCD(&TTL)

             ENDPGM
