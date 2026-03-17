             PGM
             /** MALC02 **********************************************/
             /*  SEND DATA BY MAIL                                   */
             /*  J.WATANABE 2022.06.15                               */
             /********************************************************/

             SNDSMTPEMM RCP((KAZ.WATANABE@IAFI.COM)) +
                          SUBJECT('PRIORITY LIST') NOTE('PRIORITY +
                          LIST') +
                          ATTACH(('/QNTC/IAF-AS400-FILE/AS400-TRANS/P+
                          C/DOWNLOAD/I0777/DATA.CSV'))

             ENDPGM
