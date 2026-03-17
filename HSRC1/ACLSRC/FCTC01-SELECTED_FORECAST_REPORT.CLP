             PGM
             /** FCTC01 ****************************/
             /*  SELECTED FORECAST REPORT          */
             /*  J.WATANABE  2019.01.16            */
             /**************************************/

             CLRPFM     FILE(WATALIB/FCT02)
             CLRPFM     FILE(WATALIB/FCT03)
             CLRPFM     FILE(WATALIB/FCT04)
             CLRPFM     FILE(WATALIB/FCT05)
             CLRPFM     FILE(WATALIB/FCT07)
             CLRPFM     FILE(WATALIB/FCT08)
             CLRPFM     FILE(WATALIB/FCT09)

             RUNQRY     QRY(WATALIB/FCT01A)
             RUNQRY     QRY(WATALIB/FCT01B)

             RUNQRY     QRY(WATALIB/FCT02A)
             RUNQRY     QRY(WATALIB/FCT02B)

             CPYF FROMFILE(WATALIB/FCT04) TOFILE(WATALIB/FCT07) MBROPT(*REPLACE)
             CPYF FROMFILE(WATALIB/FCT05) TOFILE(WATALIB/FCT07) MBROPT(*ADD)

             RUNQRY     QRY(WATALIB/FCT03)

             RUNQRY     QRY(WATALIB/FCT04)

             ENDPGM
