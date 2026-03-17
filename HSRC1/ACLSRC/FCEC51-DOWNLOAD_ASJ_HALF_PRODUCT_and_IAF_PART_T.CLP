             PGM
             /** FCEC51 ***************************************/
             /*  DOWNLOAD ASJ HALF PRODUCT AND IAF PART TABLE */
             /*  JW       2024.09.13                          */
             /*************************************************/
             DCL        VAR(&FNAM)   TYPE(*CHAR) LEN(30)

             CLRPFM     FILE(FCEWP40)

             CALL       PGM(FCER51)

             CHGVAR     VAR(&FNAM) VALUE('IAF-ASJ PART TABLE')
             CALL       PGM(APLC94) PARM('2' 'FCEWP40' 'HWFILE1' &FNAM +
                          'Y' ' ' 'Y')
             ENDPGM
