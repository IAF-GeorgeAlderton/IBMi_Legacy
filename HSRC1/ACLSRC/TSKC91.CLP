             PGM

             STRPCO     PCTA(*NO)
             MONMSG     MSGID(CPF0000)

             STRPCCMD   PCCMD('CWBLOGON IAF /C') PAUSE(*NO)

             STRPCCMD   PCCMD('CWBLOGON IAF /U QPGMR /P QPGMR') +
                          PAUSE(*NO)

             ENDPGM
