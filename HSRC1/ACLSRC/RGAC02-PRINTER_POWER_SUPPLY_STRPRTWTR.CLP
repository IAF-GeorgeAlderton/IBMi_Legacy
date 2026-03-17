             PGM
             /** RGAC00 ***************************/
             /* ..PRINTER POWER SUPPLY STRPRTWTR.. */
             /* ..DEV OUTQ MSGQ                   */
             /*                                   */
             /*ADD JOB TO QGPL/@QSTRUP (AFTER IPL)*/
             /*************************** RGAC00 **/


             STRPRTWTR  DEV(P1) OUTQ(QGPL/QPRINT) MSGQ(DSP01)
             MONMSG     MSGID(CPF0000)

             STRPRTWTR  DEV(QPRINT) OUTQ(QUSRSYS/QPRINT) MSGQ(DSP01)
             MONMSG     MSGID(CPF0000)


             STRPRTWTR  DEV(PA) OUTQ(QPRINTA) MSGQ(DSP01)
             MONMSG     MSGID(CPF0000)
             STRPRTWTR  DEV(PB) OUTQ(QPRINTB) MSGQ(DSP01)
             MONMSG     MSGID(CPF0000)
             STRPRTWTR  DEV(PC) OUTQ(QPRINTC) MSGQ(DSP01)
             MONMSG     MSGID(CPF0000)
             STRPRTWTR  DEV(PD) OUTQ(QPRINTD) MSGQ(DSP01)
             MONMSG     MSGID(CPF0000)

             STRRMTWTR  OUTQ(LANPRT07) MSGQ(DSP01)
             MONMSG     MSGID(CPF0000)
             STRRMTWTR  OUTQ(LANPRT13) MSGQ(DSP01)
             MONMSG     MSGID(CPF0000)
             STRRMTWTR  OUTQ(LANPRT29) MSGQ(DSP01)
             MONMSG     MSGID(CPF0000)

 END:        ENDPGM
