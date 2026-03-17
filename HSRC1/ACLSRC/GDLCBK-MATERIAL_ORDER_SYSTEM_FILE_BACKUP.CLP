             PGM
             /** GDLCBK ***************************/
             /*  MATERIAL ORDER SYSTEM FILE BACKUP*/
             /*       MSK.        2005.03.10      */
             /*************************** GDLCBK **/
             CPYF       FROMFILE(HFILE1/GDLPP01) +
                          TOFILE(HFILE1/GDLPP01BKP) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2817)

             CPYF       FROMFILE(HFILE1/GDLPP20) +
                          TOFILE(HFILE1/GDLPP20BKP) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2817)

             CPYF       FROMFILE(HWFILE1/GDLWP01) +
                          TOFILE(HWFILE1/GDLWP01BKP) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2817)

             CPYF       FROMFILE(HFILE1/GDLNP10) +
                          TOFILE(HFILE1/GDLNP10BKP) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2817)

             CPYF       FROMFILE(HFILE1/GDLPP25) +
                          TOFILE(HFILE1/GDLPP25BKP) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2817)

             CPYF       FROMFILE(HFILE1/GDLPP10) +
                          TOFILE(HFILE1/GDLPP10BKP) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2817)

             CPYF       FROMFILE(HWFILE1/GDLWP10) +
                          TOFILE(HWFILE1/GDLWP10BKP) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2817)

             ENDPGM
