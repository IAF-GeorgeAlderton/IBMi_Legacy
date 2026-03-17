  PGM
/** AN#CFJ ************************************************/
/*  ANDROID PRINT BILL OF LADING(FILE CLEAR)              */
/*                                                        */
/* TCHK1 07/26/06 CREATE(COPY FROM AB#CFJ)                */
/**********************************************************/
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)

             RTVJOBA    USER(&USER)

             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             DLTF       FILE(AN#WPFI1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AN#WPFI1) RCDLEN(256) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)
             DLTF       FILE(AN#WPFI2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AN#WPFI2) RCDLEN(256) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             CLRPFM     FILE(ABRFP01)

 @END:       ENDPGM
