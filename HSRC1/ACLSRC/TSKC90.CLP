             PGM

             STRPCO     PCTA(*NO)
             MONMSG     MSGID(CPF0000)

          /* CHGUSRPRF  USRPRF(PCSJP) LANGID(JPN) CNTRYID(JP) */
          /* I ACCESSのパスワード入力でPCSJP/PCSJPを      */
          /*入力してもらう。                                */
          /*このユーザーだと２バイト文字（日本語）が        */
          /*文字化けしない。                                */

          /* PERSONAL COMMUNICATIONSはパソコン側の言語      */
          /* I ACCESSはIBM I                                */

             STRPCCMD   PCCMD('CWBLOGON IAF /U PCSJP /P PCSJP') +
                          PAUSE(*NO)

             STRPCCMD   PCCMD('CWBLOGON IAF.ASJ-FASTENERS.CO.JO /U +
                          PCSJP /P PCSJP') PAUSE(*NO)

             STRPCCMD   PCCMD('CWBLOGON IAF.ASJ.ASJ-FASTENERS.CO.JO /U +
                          PCSJP /P PCSJP') PAUSE(*NO)

             STRPCCMD   PCCMD('CWBLOGON 10.1.1.25 /U PCSJP /P +
                          PCSJP') PAUSE(*NO)

             STRPCCMD   PCCMD('CWBLOGON IAF.IAFI.LAN /U PCSJP /P +
                          PCSJP') PAUSE(*NO)

             ENDPGM
