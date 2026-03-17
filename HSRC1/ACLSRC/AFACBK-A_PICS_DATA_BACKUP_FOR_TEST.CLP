             PGM
             /** AFACBK ****************************/
             /* A-PICS DATA BACKUP FOR TEST        */
             /*  Y.MAEDA                           */
             /*    CREATE DATE  2020.12.11         */
             /**************************** AFAC90 **/
             /*確定発注*/
             CPYF       FROMFILE(AU#PP11) TOFILE(APTEST/AU#PP11) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF0000)
             /*上限カットファイル*/
             CPYF       FROMFILE(ADKPP21) TOFILE(APTEST/ADKPP21) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF0000)
             /*便あたりの上限カットファイル*/
             CPYF       FROMFILE(ADKPP41) TOFILE(APTEST/ADKPP41) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF0000)
             /*便あたり上限値（工程別）07/29 ADD */
             CPYF       FROMFILE(ADKPP52) TOFILE(APTEST/ADKPP52) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF0000)
             /*生産指示処理履歴　上限カット回数確認用？*/
             CPYF       FROMFILE(ADKPP00) TOFILE(APTEST/ADKPP00) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF0000)
             /*品番別上限Ｆ*/
             CPYF       FROMFILE(ADKPP60) TOFILE(APTEST/ADKPP60) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF0000)
             /*かんばん発行元ファイル*/
             CPYF       FROMFILE(ADKPP11) TOFILE(APTEST/ADKPP11) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF0000)
             /*計画発行*/
             CPYF       FROMFILE(BTAPP04) TOFILE(APTEST/BTAPP04) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF0000)
             /*臨時*/
             CPYF       FROMFILE(ADKPP31) TOFILE(APTEST/ADKPP31) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF0000)
             CPYF       FROMFILE(ADAPP60) TOFILE(APTEST/ADAPP60) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF0000)
             /*未手配ファイル*/
             CPYF       FROMFILE(AD#PP11) TOFILE(APTEST/AD#PP11) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF0000)

 @END:       ENDPGM
