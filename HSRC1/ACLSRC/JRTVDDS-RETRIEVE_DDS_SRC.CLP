/****************************************************************************/
/* COPYRIGHT 2002  Sﾎｵﾈﾂｹﾄｷ Cﾅﾃﾃｵﾈｳｵ    */
/* Pﾈﾅｷﾈｱﾃ ID..:  @RTVDDSE      */
 /* Pﾈﾅｷﾈｱﾃ Dｵﾍｳ:  CPP ｶﾅﾈ ｳﾅﾃﾃｱﾄｴ RTVDDSSRC, ｳﾈｵｱﾎｵﾍ DDS ﾍﾅﾏﾈｳｵ ﾃｵﾃｲｵﾈ" */
/*                Tｸｹﾍ ﾆﾈﾅｷﾈｱﾃ ﾈｵｱｴﾍ ﾎｸｵ ｵﾒﾎｵﾈﾄｱﾂ ｶｹｵﾂｴ ｱﾄｴ ﾁｵﾓ ｴｵﾍｳﾈｹﾆﾎｹﾅﾄﾍ */
/*                ﾅｶ ｱ ﾍｵﾂｵｳﾎｵｴ ﾆｸﾓﾍｹｳｱﾂ ｶｹﾂｵ ｱﾄｴ ｳﾈｵｱﾎｵﾍ ｱ ﾍﾅﾏﾈｳｵ ﾃｵﾃｲｵﾈ   */
/*                ｹﾄ ﾎｸｵ ﾍｵﾂｵｳﾎｵｴ ﾂｹｲﾈｱﾈﾓ ｱﾄｴ ﾍﾅﾏﾈｳｵ ｶｹﾂｵ.  Tｸｵ ﾂｹｲﾈｱﾈﾓ */
 /*                ｴｵｶｱﾏﾂﾎﾍ ﾎﾅ QTEMP, ｱﾄｴ ﾎｸｵ ﾍﾅﾏﾈｳｵ ｶｹﾂｵ ｴｵｶｱﾏﾂﾎﾍ ﾎﾅ"  */
 /*                QDDSSRC. Iｶ ｱ ﾍﾅﾏﾈｳｵ ｶｹﾂｵ ｹﾍ ﾄｱﾃｵｴ ﾎｸｱﾎ ｴﾅｵﾍ ﾄﾅﾎ ｵﾒｹﾍﾎ," */
/*                ｹﾎ ﾑｹﾂﾂ ｲｵ ｳﾈｵｱﾎｵｴ.   */
/*      */
/* Dｱﾎｵ        :  04/16/02      */
/* Aﾏﾎｸﾅﾈ      :  Mｹﾁｵ Fｹﾅﾈｹﾂﾂﾅ; Sﾎｵﾈﾂｹﾄｷ Cﾅﾃﾃｵﾈｳｵ      */
/* CHANGED     :        */
/****************************************************************************/
 /* Iﾄﾆﾏﾎ (ｶﾈﾅﾃ CMD) ｶｹﾂｵﾄｱﾃｵ, ﾂｹｲﾈｱﾈﾓ, ﾍﾅﾏﾈｳｵ ﾂｹｲ, ﾍﾅﾏﾈｳｵ ｶｹﾂｵ, ﾍﾅﾏﾈｳｵ ﾃｲﾈ"  */
 /* Iﾄﾆﾏﾎ (ｶﾈﾅﾃ CMD) ﾇﾏｱﾂｶｹｵｴ ｶｹﾂｵﾄｱﾃｵ, ﾇﾏｱﾂｹｶｹｵｴ ﾍﾅﾏﾈｳｵ ｶｹﾂｵ, ﾍﾅﾏﾈｳｵ ﾃｵﾃｲｵﾈ" */
/*RTVDDS:    PGM        PARM(&FILE &LIB &SRCLIB &SRCFIL &SRCMBR)        */
@RTVDDS:    PGM        PARM(&LIBFIL &SRCLIBFIL &SRCMBR)

/* Dｵｳﾂｱﾈｵ ﾐｱﾈｹｱｲﾂｵﾍ ｶﾅﾈ ｶｹﾂｵ, ﾂｹｲﾈｱﾈﾓ ﾍﾎｱﾈﾎ ﾈｵｳﾅﾈｴ, ｱﾄｴ ﾈｵｳﾅﾈｴ ｳﾅﾏﾄﾎ"  */
DCL        VAR(&LIBFIL)    TYPE(*CHAR) LEN(20)
DCL        VAR(&SRCLIBFIL) TYPE(*CHAR) LEN(20)
DCL        VAR(&FILE)      TYPE(*CHAR) LEN(10)
DCL        VAR(&LIB)       TYPE(*CHAR) LEN(10)
DCL        VAR(&SRCLIB)    TYPE(*CHAR) LEN(10)
DCL        VAR(&SRCFIL)    TYPE(*CHAR) LEN(10)
DCL        VAR(&SRCMBR)    TYPE(*CHAR) LEN(10)

/* Dｵｳﾂｱﾈｵ ﾐｱﾈｹｱｲﾂｵ ｶﾅﾈ ﾆﾅﾆ-ﾏﾆ ﾑｹﾄｴﾅﾑ ﾃｵﾍﾍｱｷｵ   */
DCL        VAR(&MSG)    TYPE(*CHAR) LEN(72)

/* Eﾒﾎﾈｱｳﾎ ﾇﾏｱﾂｹｶｹｵｴ ｶｹﾂｵ ﾄｱﾃｵﾍ */
CHGVAR     VAR(&FILE)   VALUE(%SST(&LIBFIL     1 10))
CHGVAR     VAR(&LIB)    VALUE(%SST(&LIBFIL    11 10))
CHGVAR     VAR(&SRCFIL) VALUE(%SST(&SRCLIBFIL  1 10))
CHGVAR     VAR(&SRCLIB) VALUE(%SST(&SRCLIBFIL 11 10))

/* Cｸｵｳﾁ ｶﾅﾈ ｴｵｶｱﾏﾂﾎ Sﾅﾏﾈｳｵ Mｵﾃｲｵﾈ ﾄｱﾃｵ */
IF         COND(&SRCMBR *EQ '*FILE') THEN(CHGVAR +
VAR(&SRCMBR) VALUE(&FILE))

/* Cｸｵｳﾁ ｶﾅﾈ ｵﾒｹﾍﾎｵﾄｳｵ ﾅｶ ﾍｵﾂｵｳﾎｵｴ ｶｹﾂｵ */
CHKOBJ     OBJ(&LIB/&FILE) OBJTYPE(*FILE)
MONMSG     MSGID(CPF0000) EXEC(DO)
 /* Cｱﾂﾂ ﾆﾅﾆﾏﾆ ﾑｹﾄｴﾅﾑ API ｶﾅﾈ ｵﾈﾈﾅﾈ ﾃｵﾍﾍｱｷｵ, ﾎｸｵﾄ ｱｲﾅﾈﾎ ﾆﾈﾅｷﾈｱﾃ              */
 /* QUILNGTX ﾆｱﾈﾃﾍ:    Mｵﾍﾍｱｷｵ (Cｸｱﾈ, Lｵﾄｷﾎｸ ｴｵｶｹﾄｵｴ ｲﾓ Pｱﾈﾃ 2)              */
 /*                    Mｵﾍﾍｱｷｵ Lｵﾄｷﾎｸ (Hｵﾒ, 4 ｲﾓﾎｵﾍ ｲｹﾄｱﾈﾓ)                  */
 /*                    Mｵﾍﾍｱｷｵ ID (Cｸｱﾈ 7, BLANKS ﾏﾍｵｴ ｸｵﾈｵ)                 */
 /*                    Qﾏｱﾂｹｶｹｵｴ MSG Fｹﾂｵ Nｱﾃｵ (Cｸｱﾈ 20, BLANKS ﾏﾍｵｴ ｸｵﾈｵ)   */
 /*                    ERROR ｳﾅｴｵ (Pﾅｹﾄﾎｵﾈ, Hｵﾒ 4 ｲﾓﾎｵﾍ ｲｹﾄｱﾈﾓ)              */
CHGVAR     VAR(&MSG) VALUE(&LIB *TCAT '/' *TCAT &FILE +
*BCAT 'ﾄﾅﾎ ｶﾅﾏﾄｴ -- Cﾅﾃﾃｱﾄｴ ｹﾍ ｱｲﾅﾈﾎｹﾄｷ.')
CALL       PGM(QUILNGTX) PARM(&MSG X'00000048' '       +
' '                    ' X'00000000')
GOTO       CMDLBL(ENDPGM)
ENDDO

/* Oﾐｵﾈﾈｹｴｵ RPG ｶｹﾂｵﾄｱﾃｵ ﾎﾅ ｴｱﾎｱｲｱﾍｵ ｶｹﾂｵﾄｱﾃｵ   */
OVRDBF     FILE(FILNM) TOFILE(&LIB/&FILE)

 /* Cｸｵｳﾁ ｹｶ ﾆﾈﾅｳｵﾍﾍｹﾄｷ ﾆﾈﾅｷﾈｱﾃ ｵﾒｹﾍﾎﾍ -- ｹｶ ﾄﾅﾎ, ｳﾈｵｱﾎｵ ｹﾎ            ｴ*/
CHKOBJ     OBJ(QTEMP/&FILE) OBJTYPE(*PGM)  /* IF IT DOESNT EXIST        */
MONMSG     MSGID(CPF9801) EXEC(DO)         /* CREATE IT */

/****************************************************************************/
/**   Bｵｷｹﾄ RPG ﾆﾈﾅｳｵﾍﾍｹﾄｷ ﾆﾈﾅｷﾈｱﾃ ｳﾈｵｱﾎｹﾅﾄ                                 */
/****************************************************************************/

/* CREATE FILE DSPFFD WITH LIST OF FIELDS */
DLTF       QTEMP/DSPFFD
MONMSG     MSGID(CPF0000)
DSPFFD     FILE(&LIB/&FILE) OUTPUT(*OUTFILE) +
OUTFILE(QTEMP/DSPFFD)

/* CREATE FILE DSPFD ﾑｹﾎｸ Kｵﾓ Fｹｵﾂｴ ｹﾄｶﾅ  */
DLTF       QTEMP/DSPFD
MONMSG     MSGID(CPF0000)
DSPFD      FILE(&LIB/&FILE) TYPE(*ACCPTH) +
OUTPUT(*OUTFILE) OUTFILE(QTEMP/DSPFD)

/* CREATE SOURCE FILE IN QTEMP */
CHKOBJ     OBJ(&SRCLIB/&SRCFIL) OBJTYPE(*FILE)
MONMSG     MSGID(CPF9801) EXEC(CRTSRCPF +
FILE(&SRCLIB/&SRCFIL) RCDLEN(92))
MONMSG     MSGID(CPF9810) EXEC(DO)
/* Cｱﾂﾂ ﾆﾅﾆﾏﾆ ﾑｹﾄｴﾅﾑ API ｶﾅﾈ ｵﾈﾈﾅﾈ ﾃｵﾍﾍｱｷｵ, ﾎｸｵﾄ ｱｲﾅﾈﾎ ﾆﾈﾅｷﾈｱﾃ */
CHGVAR     VAR(&MSG) VALUE('Lｹｲﾈｱﾈﾓ' *BCAT &SRCLIB +
*TCAT ' ﾄﾅﾎ ｶﾅﾏﾄｴ -- Cﾅﾃﾃｱﾄｴ ｹﾍ ｱｲﾅﾈﾎｹﾄｷ.')
CALL       PGM(QUILNGTX) PARM(&MSG X'00000048' '       +
' '                    ' X'00000000')
GOTO CMDLBL(ENDPGM)
ENDDO
ADDPFM     FILE(&SRCLIB/&SRCFIL) MBR(&SRCMBR) +
TEXT('Mｵﾃｲｵﾈ ｱｴｴｵｴ ｲﾓ RTVDDSSRC ｳﾅﾃﾃｱﾄｴ') +
SRCTYPE(PF)
MONMSG     MSGID(CPF5812 CPF7306) EXEC(DO)
/* Cｱﾂﾂ ﾆﾅﾆﾏﾆ ﾑｹﾄｴﾅﾑ API ｶﾅﾈ ｵﾈﾈﾅﾈ ﾃｵﾍﾍｱｷｵ, ﾎｸｵﾄ ｱｲﾅﾈﾎ ﾆﾈﾅｷﾈｱﾃ               */
CHGVAR     VAR(&MSG) VALUE('Mｵﾃｲｵﾈ' *BCAT &SRCMBR +
*BCAT 'ｵﾒｹﾍﾎﾍ -- Cﾅﾃﾃｱﾄｴ ｹﾍ ｱｲﾅﾈﾎｹﾄｷ.')
CALL       PGM(QUILNGTX) PARM(&MSG X'00000048' '       +
' '                    ' X'00000000')
GOTO CMDLBL(ENDPGM)
ENDDO

/* POINT OUTPUT TO SOURCE FILE */
OVRDBF     FILE(SRCF) TOFILE(&SRCLIB/&SRCFIL) MBR(&SRCMBR)
OVRDBF     FILE(DSPFFD) TOFILE(QTEMP/DSPFFD)
OVRDBF     FILE(DSPFD) TOFILE(QTEMP/DSPFD)

/* CREATE ﾈｵｳﾅﾈｴﾍ ｹﾄ DDS ﾍﾅﾏﾈｳｵ ﾃｵﾃｲｵﾈ                                      */
             CALL       PGM(JCRTSRC) PARM(&FILE)

ENDDO      /* IF PROGRAM WAS NOT FOUND */

/****************************************************************************/
/**   Eﾄｴ   RPG ﾆﾈﾅｳｵﾍﾍｹﾄｷ ﾆﾈﾅｷﾈｱﾃ ｳﾈｵｱﾎｹﾅﾄ                                 */
/****************************************************************************/

ENDPGM:     DLTOVR     FILE(*ALL)

DLTF       FILE(QTEMP/DSPFFD)
MONMSG     MSGID(CPF0000)

DLTF       FILE(QTEMP/DSPFD)
MONMSG     MSGID(CPF0000)


ENDPGM
