             PGM
             /** VVVC92 *************************************************/
             /*  DSPFD *MBRLIST (RPG SOURCE PROGRAM FILE)               */
             /*  SET IN VVVC10 - VJBC71 (RUN EVERYDAY AT 5:45AM)        */
             /*  J.WATANABE     2021.07.09                              */
             /***********************************************************/
             DCL        VAR(&SL) TYPE(*CHAR) LEN(10) VALUE('HSRC1')
             DCL        VAR(&ML) TYPE(*CHAR) LEN(10) VALUE('*MBRLIST')
             DCL        VAR(&OU) TYPE(*CHAR) LEN(10) VALUE('*OUTFILE')
             DCL        VAR(&L ) TYPE(*CHAR) LEN(10) VALUE('HFILE1')
             DCL        VAR(&F ) TYPE(*CHAR) LEN(10) VALUE('VVVPP50')
             DCL        VAR(&FS) TYPE(*CHAR) LEN(10) VALUE('*FIRST')
             DCL        VAR(&AD) TYPE(*CHAR) LEN(10) VALUE('*ADD')

             CLRPFM     FILE(HFILE1/VVVPP50)
/** RPG **/
 DSPFD FILE(&SL/ARPGSRC ) TYPE(&ML) OUTPUT(&OU) OUTFILE(&L/&F) OUTMBR(&FS &AD)

/** CLP **/
 DSPFD FILE(&SL/ACLSRC ) TYPE(&ML) OUTPUT(&OU) OUTFILE(&L/&F) OUTMBR(&FS &AD)

             ENDPGM
