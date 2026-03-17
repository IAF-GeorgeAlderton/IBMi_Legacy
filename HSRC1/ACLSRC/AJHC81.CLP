             PGM

             CLRPFM     FILE(AJHPP80)

             CALL       PGM(AJHR80)

             CLRPFM     FILE(OUTPUT)
             CALL       PGM(AJHR81) PARM('1')
             EDTDTA     FILE(OUTPUT)

             CLRPFM     FILE(OUTPUT)
             CALL       PGM(AJHR81) PARM('2')
             EDTDTA     FILE(OUTPUT)

             CLRPFM     FILE(OUTPUT)
             CALL       PGM(AJHR81) PARM('3')
             EDTDTA     FILE(OUTPUT)

             CLRPFM     FILE(OUTPUT)
             CALL       PGM(AJHR81) PARM('4')
             EDTDTA     FILE(OUTPUT)

             CLRPFM     FILE(OUTPUT)
             CALL       PGM(AJHR81) PARM('5')
             EDTDTA     FILE(OUTPUT)

             CLRPFM     FILE(OUTPUT)
             CALL       PGM(AJHR81) PARM('6')
             EDTDTA     FILE(OUTPUT)

             CLRPFM     FILE(OUTPUT)
             CALL       PGM(AJHR81) PARM('7')
             EDTDTA     FILE(OUTPUT)

             ENDPGM
