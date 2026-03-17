/********************************************************************/
/*                                        2015.08.20    %0001       */
/* DUE TO INCREASE INTIAL SIZE OF QTEMP/CSVPF   T.SAKAKI            */
/********************************************************************/
/*                                                                ED*/
/* 5770SS1 V7R1M0 100423     RTVCLSRC Output     15.08.19 21:51:03  */
/*                                                                  */
/* Program name . . . . . . . . . . . . . . :   DBTOCSV           PN*/
/* Library name . . . . . . . . . . . . . . :   MAI               PL*/
/* Original source file . . . . . . . . . . :   QCLSRC            SN*/
/* Library name . . . . . . . . . . . . . . :   MAISRC            SL*/
/* Original source member . . . . . . . . . :   DBTOCSV           SM*/
/* Source file change                                               */
/*   date/time  . . . . . . . . . . . . . . :   01.03.15 13:05:55 SC*/
/* Patch option . . . . . . . . . . . . . . :   *NOPATCH          PO*/
/* User profile . . . . . . . . . . . . . . :   *USER             UP*/
/* Text . . . : DBTOCSV                                           TX*/
/* Owner  . . . . . . . . . . . . . . . . . :   QDFTOWN           OW*/
/* User mod flag  . . . . . . . . . . . . . :   *YES              UM*/
/* Retrieve included source . . . . . . . . :   *NO               RI*/
/*                                                                ED*/
/********************************************************************/
     PGM PARM(&INAME &ONAME &INMBR &REPOPT &CRTFILE &STMF &FCCSID -
&TCCSID)
     DCL VAR(&INAME) TYPE(*CHAR) LEN(20)
     DCL VAR(&INFILE) TYPE(*CHAR) LEN(10)
     DCL VAR(&INMBR) TYPE(*CHAR) LEN(10)
     DCL VAR(&INLIB) TYPE(*CHAR) LEN(10)
     DCL VAR(&ONAME) TYPE(*CHAR) LEN(20)
     DCL VAR(&OUTFILE) TYPE(*CHAR) LEN(10)
     DCL VAR(&OUTLIB) TYPE(*CHAR) LEN(10)
     DCL VAR(&REPOPT) TYPE(*CHAR) LEN(8)
     DCL VAR(&CRTFILE) TYPE(*CHAR) LEN(4)
     DCL VAR(&STMF) TYPE(*CHAR) LEN(256)
     DCL VAR(&FILLEN) TYPE(*DEC) LEN(15 0)
     DCL VAR(&FCCSID) TYPE(*CHAR) LEN(5)
     DCL VAR(&TCCSID) TYPE(*CHAR) LEN(5)
     MONMSG MSGID(CPF9800) EXEC(GOTO CMDLBL(ENDLABEL))
     CHGVAR VAR(&INFILE) VALUE(%SST(&INAME 1 10))
     CHGVAR VAR(&INLIB) VALUE(%SST(&INAME 11 10))
     CHGVAR VAR(&OUTFILE) VALUE(%SST(&ONAME 1 10))
     CHGVAR VAR(&OUTLIB) VALUE(%SST(&ONAME 11 10))
     CHKOBJ OBJ(&INLIB/&INFILE) OBJTYPE(*FILE) MBR(&INMBR)
     IF COND((&CRTFILE *EQ '*NO') *AND (&OUTFILE *NE '*STMF')) -
THEN(DO)
     CHKOBJ OBJ(&OUTLIB/&OUTFILE) OBJTYPE(*FILE)
     ENDDO
     DSPFFD FILE(&INLIB/&INFILE) OUTPUT(*OUTFILE) OUTFILE(QTEMP/DSPFF-
DF)
     OVRDBF FILE(DSPFFDF) TOFILE(QTEMP/DSPFFDF)
     IF COND(&OUTFILE *EQ '*STMF') THEN(DO)
     CHGVAR VAR(&OUTLIB) VALUE('QTEMP')
/*  CHGVAR VAR(&OUTLIB) VALUE('SAKAKI')   */
     CHGVAR VAR(&OUTFILE) VALUE('CSVPF')
     ENDDO
     IF COND(&CRTFILE *EQ '*YES') THEN(DO)
     CALL PGM(DBTOCSVL) PARM(&FILLEN)
             CRTPF      FILE(&OUTLIB/&OUTFILE) RCDLEN(&FILLEN) +
                          IGCDTA(*YES) SIZE(100000 10000)
     MONMSG MSGID(CPF0000)
     ENDDO
     IF COND(&REPOPT *EQ '*REPLACE') THEN(DO)
     CLRPFM FILE(&OUTLIB/&OUTFILE)
     MONMSG MSGID(CPF0000)
     ENDDO
     OVRDBF FILE(INPUT) TOFILE(&INLIB/&INFILE) MBR(&INMBR)
     OVRDBF FILE(OUTPUT) TOFILE(&OUTLIB/&OUTFILE)
     CALL PGM(DBTOCSVR)
     DLTF FILE(QTEMP/DSPFFDF)
     MONMSG MSGID(CPF0000)
     IF COND(&OUTFILE *EQ 'CSVPF') THEN(DO)
     CPYTOSTMF FROMMBR('/QSYS.LIB/QTEMP.LIB/CSVPF.FILE/CSVPF.MBR') -
TOSTMF(&STMF) STMFOPT(&REPOPT) DBFCCSID(&FCCSID) STMFCODPAG(&TCCSID)
     DLTF FILE(QTEMP/CSVPF)
     ENDDO
ENDLABEL: +
     ENDPGM
