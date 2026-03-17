 /** AC#C20 ***************************************************/
 /* (HONDA) CREATE WORK FILE OF CONSOLIDATED ORDER            */
 /*                                                           */
 /* J.W.  2017.01.31                                          */
 /*************************************************************/
             PGM        PARM(&BAR)

             DCL        VAR(&BAR)  TYPE(*CHAR) LEN(9)

             CLRPFM     FILE(*LIBL/AC#PP32)

             CALL       PGM(AC#R20) PARM(&BAR)

             ENDPGM
