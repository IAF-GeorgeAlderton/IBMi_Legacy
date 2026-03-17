             /**** GDJC09 ****************************************************/
             /*      INVENTORY DATA INITIALIZATION                           */
             /*        A.IDOTA                          97/10/30             */
             /****************************************************************/
             PGM
             DCLF       FILE(GDJPW09)

##1:         SNDRCVF RCDFMT(DSP01)
             IF  (&IN01 = '1')  GOTO END
             IF  (&IN05 = '1')  GOTO ##2
             GOTO ##1

##2:
             CLRPFM     FILE(GDJPP15)
             CLRPFM     FILE(GDJPP20)
             DLTF       FILE(HWFILE1/GDJWP15)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/GDJWP15) RCDLEN(30) +
                          OPTION(*NOLIST) SIZE(10000 1000) +
                          LVLCHK(*NO) AUT(*ALL)
             STRPCO     PCTA(*NO)
             MONMSG     MSGID(IWS4010)
             STRPCCMD   PCCMD('TANA_DEL.BAT') PAUSE(*NO)

END:         ENDPGM
