             PGM
             /** DNLC01 ************************************/
             /*  DOWNLOAD ABBPP7G TO CSV                   */
             /*  J.WATANABE  2021.06.18                    */
             /**********************************************/
             DCL        VAR(&FNAM)   TYPE(*CHAR) LEN(30)

             CLRPFM     FILE(HWFILE1/DNLWP01)

             CALL       PGM(DNLR01)

             CHGVAR     VAR(&FNAM) VALUE('MACHINE MASTER')
             CALL       PGM(APLC94) PARM('2' 'DNLWP01' 'HWFILE1' &FNAM +
                          'Y' ' ' 'Y')

             ENDPGM
