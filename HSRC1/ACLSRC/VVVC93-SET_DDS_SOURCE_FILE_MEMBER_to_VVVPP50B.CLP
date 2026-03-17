             PGM
             /** VVVC93 *************************************************/
             /*  DSPFD *MBRLIST (DDS SOURCE PROGRAM FILE)               */
             /*  SET IN FCKC03 - RUN EVERYDAY AT 7:33AM                 */
             /*  J.WATANABE     2022.09.02                              */
             /***********************************************************/
             DCL        VAR(&SL) TYPE(*CHAR) LEN(10) VALUE('HSRC1')
             DCL        VAR(&ML) TYPE(*CHAR) LEN(10) VALUE('*MBRLIST')
             DCL        VAR(&OU) TYPE(*CHAR) LEN(10) VALUE('*OUTFILE')
             DCL        VAR(&L ) TYPE(*CHAR) LEN(10) VALUE('HFILE1')
             DCL        VAR(&F ) TYPE(*CHAR) LEN(10) VALUE('VVVPP50B')
             DCL        VAR(&FS) TYPE(*CHAR) LEN(10) VALUE('*FIRST')
             DCL        VAR(&AD) TYPE(*CHAR) LEN(10) VALUE('*ADD')

             CLRPFM     FILE(HFILE1/VVVPP50B)
/** DDS **/
 DSPFD FILE(&SL/ADDSSRC ) TYPE(&ML) OUTPUT(&OU) OUTFILE(&L/&F) OUTMBR(&FS &AD)

             ENDPGM
