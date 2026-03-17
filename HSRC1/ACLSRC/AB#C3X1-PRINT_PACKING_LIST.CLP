/********************************************************************/
/*                                                                  */
/* 5770SS1 V7R3M0 160422     RTVCLSRC Output     18.04.10 20:47:40  */
/*                                                                  */
/* Program name . . . . . . . . . . . . . . :   AB#C3X1           PN*/
/* Library name . . . . . . . . . . . . . . :   HOBJ1             PL*/
/* Original source file . . . . . . . . . . :   ACLSRC            SN*/
/* Library name . . . . . . . . . . . . . . :   HSRC1             SL*/
/* Original source member . . . . . . . . . :   AB#C3X1           SM*/
/* Source file change                                               */
/*   date/time  . . . . . . . . . . . . . . :   18.03.28 21:40:51 SC*/
/* Patch option . . . . . . . . . . . . . . :   *NOPATCH          PO*/
/* User profile . . . . . . . . . . . . . . :   *USER             UP*/
/* Text . . . : PRINT PACKING LIST                                TX*/
/* Owner  . . . . . . . . . . . . . . . . . :   QPGMR             OW*/
/* User mod flag  . . . . . . . . . . . . . :   *YES              UM*/
/* Retrieve included source . . . . . . . . :   *NO               RI*/
/*                                                                ED*/
/********************************************************************/
     DCL VAR(&USER) TYPE(*CHAR) LEN(10)
     DCL VAR(&NAME) TYPE(*CHAR) LEN(15)
     RTVJOBA USER(&USER)
     CALL PGM(AB#R3X1) PARM(&USER &NAME)
     ADDDIRE USRID(&USER IAF) USRD(&NAME) USER(&USER) SYSNAME(IAF) -
NETUSRID(&USER *CAT 'IAF')
     MONMSG MSGID(CPF0000)
END: +
     ENDPGM
