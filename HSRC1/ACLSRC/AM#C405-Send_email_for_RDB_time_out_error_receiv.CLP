             PGM        PARM(&FILE)
             /** AM#C405 ***************************/
             /* SEND EMAIL FOR RDB TIME-OUT ERROR  */
             /*   LEC.             2020.11.11      */
             /**************************************/

             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LMSG) TYPE(*CHAR) LEN(150)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&LMSG) +
                          VALUE('RDB received a +
                          Time-out error when trying to insert a +
                          record into SQL table for TSCS.  Please +
                          check file ' *CAT &FILE)

  /*     send email to recipients                                  */
             SNDDST     TYPE(*LMSG) TOINTNET((Larry.Cox@iafi.com)) +
                          DSTD('RDB Connect received Time-out Error +
                          for TSCS') LONGMSG(&LMSG)

             SNDDST     TYPE(*LMSG) +
                          TOINTNET((Jonathon.Julson@iafi.com)) +
                          DSTD('RDB Connect received Time-out Error +
                          for TSCS') LONGMSG(&LMSG)

             SNDDST     TYPE(*LMSG) +
                          TOINTNET((Kaz.Watanabe@iafi.com)) +
                          DSTD('RDB Connect received Time-out Error +
                          for TSCS') LONGMSG(&LMSG)

 #END:       ENDPGM
