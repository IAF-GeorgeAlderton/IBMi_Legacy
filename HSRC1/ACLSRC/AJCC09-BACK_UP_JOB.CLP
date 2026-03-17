             PGM
             /** AJCC09 ******************************************************/
             /*  BACK-UP JOB                                                 */
             /*   TCH 01.07.18                                               */
             /****************************************************** AJCC02 **/
             DCLF       FILE(AJCPW09)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID)

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(AJCPW091)


             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(END))



             IF         COND((&IN01 *NE '1') *AND (&IN05 *NE '1')) +
                          THEN(GOTO CMDLBL(STP1))


             IF         COND(&IN05 *EQ '1') THEN(DO)

             INZTAP     DEV(TAP01) NEWVOL(DBACK) CHECK(*NO) +
                          DENSITY(*ULTRIUM6)
             MONMSG     MSGID(CPF0000)

             SAVLIB     LIB(HOBJ1 HFILE1 HWFILE1 HJRN1 HSRC1) +
                          DEV(TAP01) SAVACT(*SYNCLIB)
             ENDDO

END:         ENDPGM
