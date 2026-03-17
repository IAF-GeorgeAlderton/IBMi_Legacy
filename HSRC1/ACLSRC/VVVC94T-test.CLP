             PGM
             /** VVVC94 *************************************************/
             /*  DSPFD *MBRLIST (ALL SOURCE FILE MEMBER)                */
             /*  SET IN FCKC03 - RUN EVERYDAY AT 7:33AM                 */
             /*  J.WATANABE     2026.01.14                              */
             /***********************************************************/
             DCL        VAR(&SL) TYPE(*CHAR) LEN(10) VALUE('HSRC1')
             DCL        VAR(&ML) TYPE(*CHAR) LEN(10) VALUE('*MBRLIST')
             DCL        VAR(&OU) TYPE(*CHAR) LEN(10) VALUE('*OUTFILE')
             DCL        VAR(&L ) TYPE(*CHAR) LEN(10) VALUE('HFILE1')
             DCL        VAR(&F ) TYPE(*CHAR) LEN(10) VALUE('VVVPP50C')
             DCL        VAR(&FS) TYPE(*CHAR) LEN(10) VALUE('*FIRST')
             DCL        VAR(&AD) TYPE(*CHAR) LEN(10) VALUE('*ADD')

             CLRPFM     FILE(HFILE1/VVVPP50C)
     /****** CLRPFM     FILE(HFILE1/VVVPP50D) ********/

/* GET SOURCE FILE MEMBER NAME */
             DSPFD      FILE(&SL/*ALL) TYPE(&ML) OUTPUT(&OU) +
                          OUTFILE(&L/&F) OUTMBR(&FS &AD)

/* DELETE GARBAGE DATA         */
      /***** CALL       PGM(VVVR94)  ****/

/* CREATE VVVPP50D             */
      /***** CALL       PGM(VVVR94A) ****/

             ENDPGM
