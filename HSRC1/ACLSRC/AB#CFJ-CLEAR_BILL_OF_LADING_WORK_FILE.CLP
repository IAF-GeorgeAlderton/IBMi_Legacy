             PGM
             /** AB#CFJ *****************************/
             /*  ..PRINT BILL OF LADING(CLEAR)      */
             /*     N.HYOTO          2000.11.03     */
             /***************************** AB#CFI **/
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)

             RTVJOBA    USER(&USER)

             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             DLTF       FILE(AB#WPFI1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AB#WPFI1) RCDLEN(256) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)
             DLTF       FILE(AB#WPFI2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AB#WPFI2) RCDLEN(256) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             CLRPFM     FILE(ABFFP01)

 @END:       ENDPGM
