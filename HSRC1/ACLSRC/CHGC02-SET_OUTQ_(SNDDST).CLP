             /** CHGC02 ************************************/
             /*      OUTQ SET  　　　　　　　　　　　　  */
             /*   T.SAKAKI                 2015.12.23      */
             /**********************************************/
             PGM        PARM(&FILE &JOB &JOBU &JOBN &SPNB &OUTQ)

             DCL        VAR(&FILE)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBU)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBN)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&SPNB)    TYPE(*DEC)  LEN(6 0)
             DCL        VAR(&OUTQ)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&OTQ2)    TYPE(*CHAR) LEN(10)

             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)   TYPE(*CHAR) LEN(8)

             RTVJOBA    USER(&USER)
           /*--------------------------------------------*/
           /*    CHECK ENVIRONMENT                        */
           /*--------------------------------------------*/
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

             CPYSPLF    FILE(&FILE) TOFILE(&WLIB/PRT132A) +
                          JOB(&JOBN/&JOBU/&JOB) SPLNBR(&SPNB)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(PRT132) TOFILE(&WLIB/PRT132A)

             CALL       PGM(AB#RW0)
             MONMSG     MSGID(CPF0000)
             SNDDST     TYPE(*FILE) +
                          TOINTNET(('AS400-SYSTEM@IAFI.COM')) +
                          DSTD('GENTRAN ERROR NOTIFICATION') +
                          MSG('GENTRAN process got some errors. +
                          Please check the attached list and take +
                          care of it. (CHGC02).') +
                          DOCFILE(&WLIB/PRT132A) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD('GENTRAN ERROR +
                          NOTIFICATION')
             MONMSG     MSGID(CPF0000)

  /**JW      SNDDST     TYPE(*FILE) +                                  **/
  /**                     TOINTNET(('TAKASHI.SAKAKI@IAFI.COM')) +      **/
  /**                     DSTD('GENTRAN ERROR NOTIFICATION') +         **/
  /**                     MSG('GENTRAN process got an error. Please +  **/
  /**                     check the attached list and take care of. +  **/
  /**                     (CHGC02).') DOCFILE(&WLIB/PRT132A) +         **/
  /**                     DOCTYPE(*FFT) SNDFMT(*NOTE) DOCD('GENTRAN +  **/
  /**                     ERROR NOTIFICATION')                         **/
  /**        MONMSG     MSGID(CPF0000)                                 **/

             DLTOVR     FILE(PRT132)
             MONMSG     MSGID(CPF0000)

             CHGSPLFA   FILE(&FILE) JOB(&JOBN/&JOBU/&JOB) +
                          SPLNBR(&SPNB) OUTQ(&OUTQ)
             MONMSG     MSGID(CPF0000)

