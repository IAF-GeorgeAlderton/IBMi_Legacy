             PGM
             /**** APLC05 *****************************************/
             /* TRANSFER CSV TO PF                                */
             /*          FROM --> TO                              */
             /* JW  2020.05.06                                    */
             /* FROM: (J:) /PC/UPLOAD/UPL120.CSV                  */
             /* TO  : HWFILE1 / UPLWP20                           */
             /*****************************************************/

             CPYFRMIMPF +
                          FROMSTMF('/QNTC/IAF-AS400-FILE/AS400-TRANS/+
                          PC/Upload/PT.csv') +
                          TOFILE(HWFILE1/UPLWP12) MBROPT(*REPLACE) +
                          FROMCCSID(*FILE) RCDDLM(*CRLF) +
                          STRDLM(*DBLQUOTE) FLDDLM(*TAB) +
                          DATFMT(*USA) TIMFMT(*USA) ERRRCDOPT(*REPLACE)

    /*****   MONMSG     MSGID(CPF0000)   *******/

             ENDPGM
