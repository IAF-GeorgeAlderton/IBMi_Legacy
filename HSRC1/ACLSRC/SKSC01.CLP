PGM
             DLTF       FILE(SKSWP01)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/SKSWP01) RCDLEN(1024) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(SKSR01)

             CALL       PGM(APLC98) PARM('HWFILE1' 'SKSWP01' 'IAF' +
                          'C:/AS400/DATA/SKSWP01.CSV' ' 1')

             STRPCO     PCTA(*NO)
             MONMSG     MSGID(CPF0000)

             STRPCCMD   PCCMD('C:/AS400/DATA/SKSWP01.CSV') PAUSE(*NO)

ENDPGM
