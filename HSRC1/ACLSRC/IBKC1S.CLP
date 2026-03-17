            PGM
            /** IBKC11 *************************************/
            /* FCGPP51 RECEVE NETWORKFILE( AOYAMA-->IAF )  */
            /*     A.IDOTA               2006.07.31        */
            /************************************* IBKC11 **/

             DLTF       FILE(SAKASITA/FCGPP51)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTDUPOBJ  OBJ(FCGPP51) FROMLIB(HFILE1) OBJTYPE(*FILE) +
                          TOLIB(SAKASITA)

             RCVNETF    FROMFILE(FCGPP51) TOFILE(SAKASITA/FCGPP51) +
                          USER(QFILE)

             EDTDTA     FILE(SAKASITA/FCGPP51)

          /* CPYF       FROMFILE(WEEKDLT/FCGPP51) +
                          TOFILE(HFILE1/FCGPP51) MBROPT(*REPLACE) */

             ENDPGM
