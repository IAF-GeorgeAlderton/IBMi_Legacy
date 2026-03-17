             PGM
             /** RGAC01 *************************/
             /* ..PRINTER POWER SUPPLY ENDWTR.. */
             /*   I-HASADA           97.07.01   */
             /*ADD JOB TO QGPL/@QSTRUP (AFTER IPL) */
             /************************* RGAC01 **/

             ENDWTR     WTR(PA) OPTION(*IMMED)
             MONMSG     MSGID(CPF3313)

             ENDWTR     WTR(PB) OPTION(*IMMED)
             MONMSG     MSGID(CPF3313)

             ENDWTR     WTR(P1) OPTION(*IMMED)
             MONMSG     MSGID(CPF3313)

             ENDWTR     WTR(PD) OPTION(*IMMED)
             MONMSG     MSGID(CPF0000)

             ENDWTR     WTR(PC) OPTION(*IMMED)
             MONMSG     MSGID(CPF0000)

             ENDWTR     WTR(QPRINT) OPTION(*IMMED)
             MONMSG     MSGID(CPF0000)

             ENDWTR     WTR(LANPRT07) OPTION(*IMMED)
             MONMSG     MSGID(CPF0000)

             ENDPGM
