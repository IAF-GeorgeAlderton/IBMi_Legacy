             PGM
             /** ABVC2C ***********************************************/
             /*  VW Shipping Label data create   .                    */
             /*     FOR TEST DATA       T.SAKAKI 15.09.25             */
             /*********************************************************/

             CPYF       FROMFILE(TWFILE1/ABVWP2E) +
                          TOFILE(HWFILE1/ABVWP2E) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF0000)

             CPYF       FROMFILE(TWFILE1/ABVWP2F) +
                          TOFILE(HWFILE1/ABVWP2F) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF0000)

  END:
             ENDPGM
