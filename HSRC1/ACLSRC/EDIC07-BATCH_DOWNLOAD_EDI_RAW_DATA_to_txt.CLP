             PGM
             /** EDIC07 *******************************************/
             /*  DOWNLOAD EDI RAW DATA TO CSV                     */
             /* J.WATANABE   2025.04.03                           */
             /*****************************************************/

             DCL        VAR(&FNAM) TYPE(*CHAR) LEN(30)

             CHGVAR     VAR(&FNAM) VALUE('EDI RAW DATA')

         CALL  PGM(APLC94ND) PARM('2' 'EDIWP01' 'QTEMP' &FNAM  'T' 'N' 'Y')

             ENDPGM
