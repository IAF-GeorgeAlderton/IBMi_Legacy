             /**** GDGC20 ****************************************************/
             /*  INPUT OF SHIPPING INFORMATION                               */
             /*       N.HAYAKAWA                        97/02/20             */
             /****************************************************************/
             PGM
             DCLF       FILE(GDJPW20)

 ##1:        SNDRCVF    RCDFMT(DSP01)
             IF  (&IN01 = '1')  GOTO END
             IF  (&IN05 = '1')  GOTO ##2
             GOTO ##1

 ##2:        CLRPFM     FILE(GDJPP23)
             CLRPFM     FILE(GDJPP24)
             CPYF       FROMFILE(GDJPP20) TOFILE(GDJPP24) +
                          MBROPT(*REPLACE) INCREL((*IF IPKKBN *NE '7'))
             MONMSG     MSGID(CPF0000)
             CPYF       FROMFILE(GDJPP20) TOFILE(GDJPP23) +
                          MBROPT(*REPLACE) INCREL((*IF IPKKBN *EQ '7'))
             MONMSG     MSGID(CPF0000)
             CPYF       FROMFILE(GDJPP22) TOFILE(GDJPP24) +
                          MBROPT(*ADD) INCREL((*IF IPKKBN *NE '7')) +
                          FMTOPT(*MAP *DROP)
             MONMSG     MSGID(CPF0000)
             CPYF       FROMFILE(GDJPP22) TOFILE(GDJPP23) +
                          MBROPT(*ADD) INCREL((*IF IPKKBN *EQ '7')) +
                          FMTOPT(*MAP *DROP)
             MONMSG     MSGID(CPF0000)

             CALL       PGM(GDJR20)

END:         ENDPGM
