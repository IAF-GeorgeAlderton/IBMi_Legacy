/*      ***********************************************************************/
/*      COPYRIGHT 2002  Sﾎｵﾈﾂｹﾄｷ Cﾅﾃﾃｵﾈｳｵ       */
/*      Pﾈﾅｷﾈｱﾃ ID..:  @UNPACK  */
/*      Dｱﾎｵ        :  04/16/02 */
/*      Aﾏﾎｸﾅﾈ      :  Mｹﾁｵ Fｹﾅﾈｹﾂﾂﾅ; Sﾎｵﾈﾂｹﾄｷ Cﾅﾃﾃｵﾈｳｵ */
/*  Pﾈﾅｷﾈｱﾃ Dｵﾍｳ:  CPP ｶﾅﾈ ｳﾃｴ UNPACK, ｳﾈｵｱﾎｵﾍ ｶｹﾂｵ ﾑｹﾎｸ ﾏﾄﾆｱｳﾁｵｴ  ﾄﾏﾃｵﾈｹｳﾍ*/
/*      Tｸｹﾍ ｹﾍ Cﾅﾃﾃｱﾄｴ Pﾈﾅｳｵﾍﾍｹﾄｷ Pﾈﾅｷﾈｱﾃ ｶﾅﾈ ｳﾅﾃﾃｱﾄｴ UNPACK.  Iﾎ      */
/*      "ｳｸｵｳﾁﾍ ｶﾅﾈ ｵﾒｹﾍﾎｵﾄｳｵ ﾅｶ ｶｹﾂｵ ﾎﾅ ｲｵ ﾏﾄﾆｱｳﾁｵｴ, ｵﾄﾍﾏﾈｵﾍ ﾎｸｱﾎ"     */
/*      "ﾏﾄﾆｱｳﾁ ｶｹﾂｵ ｴﾅｵﾍ ﾄﾅﾎ ｵﾒｹﾍﾎ, ﾎｸｵﾄ ﾈｵﾎﾈｹｵﾐｵﾍ DDS ﾍﾅﾏﾈｳｵ ﾅｶ"      */
/*      "ｶｹﾂｵ, ﾃﾅｴｹｶｹｵﾍ DDS ﾍﾅﾏﾈｳｵ ﾅｶ ﾆｱｳﾁｵｴ ﾄﾏﾃｵﾈｹｳ ｶｹｵﾂｴﾍ ｳｸｱﾄｷｹﾄｷ"   */
/*      "ﾎｸｵﾃ ﾎﾅ ﾔﾅﾄｵｴ, ﾎｸｵﾄ ｳﾈｵｱﾎｵﾍ ﾎｱﾈｷｵﾎ ﾏﾄﾆｱｳﾁｵｴ ｶｹﾂｵ.  Uﾍｵﾍ"       */
/*      CPYF FMTOPT(*MAP) ﾎﾅ ｳﾅﾆﾓ ﾅﾈｹｷｹﾄｱﾂ ｶｹﾂｵ ﾎﾅ ﾏﾄﾆｱｳﾁｵｴ ﾐｵﾈﾍｹﾅﾄ.    */
/* Pﾈｵﾈｵﾇﾏｹﾍｹﾎｵ:Tｸｹﾍ ﾆﾈﾅｷﾈｱﾃ REQUIRES ｵﾒｹﾍﾎｵﾄｳｵ ﾅｶ ｳﾅﾃﾃｱﾄｴ RTVDDSS RC ｱﾄｴ ｹﾎ */
/*      ｱﾍﾍﾅｳｹｱﾎｵｴ ﾆﾈﾅｷﾈｱﾃﾍ ｹﾄ ﾅﾈｴｵﾈ ﾎﾅ ﾈﾏﾄ.    */
/*      Aﾏﾎｸﾅﾈ      :  Mｹﾁｵ Fｹﾅﾈｹﾂﾂﾅ; Sﾎｵﾈﾂｹﾄｷ Cﾅﾃﾃｵﾈｳｵ */
/*      CHANGED     :   */
/*      ***********************************************************************/
/*      Iﾄﾆﾏﾎ (ｶﾈﾅﾃ CMD UNPACK) */
/*      &PCKFIL     ｶｹﾂｵ  ｳﾅﾄﾎｱｹﾄｹﾄｷ ﾆｱｳﾁｵｴ ﾄﾏﾃｵﾈｹｳ ｶｹｵﾂｴﾍ      */
/*      &PCKLIB     ﾂｹｲﾈｱﾈﾓ     */
/*      &UPKFIL     ｶｹﾂｵ ｳﾅﾄﾎｱｹﾄｹﾄｷ ﾏﾄﾆｱｳﾁｵｴ ﾄﾏﾃｵﾈｹｳ ｶｹｵﾂｴﾍ     */
/*      &UPKLIB     ﾂｹｲﾈｱﾈﾓ     */

@UNPACK:    PGM        PARM(&PCKPCK &UPKUPK)

/*      "Dｵｳﾂｱﾈｵ ﾐｱﾈｹｱｲﾂｵﾍ ｶﾅﾈ ｶｹﾂｵ, ﾂｹｲﾈｱﾈﾓ ﾍﾎｱﾈﾎ ﾈｵｳﾅﾈｴ, ｱﾄｴ ﾈｵｳﾅﾈｴ ｳﾅﾏﾄﾎ*/
        DCL        VAR(&PCKPCK) TYPE(*CHAR) LEN(20)
        DCL        VAR(&PCKFIL) TYPE(*CHAR) LEN(10)
        DCL        VAR(&PCKLIB) TYPE(*CHAR) LEN(10)
        DCL        VAR(&UPKUPK) TYPE(*CHAR) LEN(20)
        DCL        VAR(&UPKFIL) TYPE(*CHAR) LEN(10)
        DCL        VAR(&UPKLIB) TYPE(*CHAR) LEN(10)

/*      Dｵｳﾂｱﾈｵ ﾐｱﾈｹｱｲﾂｵ ｶﾅﾈ ﾆﾅﾆ-ﾏﾆ ﾃｵﾍﾍｱｷｵ     */
        DCL        VAR(&MSG) TYPE(*CHAR) LEN(72)

/*      Eﾒﾎﾈｱｳﾎ ﾇﾏｱﾂｹｶｹｵｴ ｶｹﾂｵ ﾄｱﾃｵﾍ    */
        CHGVAR     VAR(&PCKFIL) VALUE(%SST(&PCKPCK  1 10))
        CHGVAR     VAR(&PCKLIB) VALUE(%SST(&PCKPCK 11 10))
        CHGVAR     VAR(&UPKFIL) VALUE(%SST(&UPKUPK  1 10))
        CHGVAR     VAR(&UPKLIB) VALUE(%SST(&UPKUPK 11 10))

/*"Cｸｵｳﾁ ｶﾅﾈ ｵﾒｹﾍﾎｵﾄｳｵ ﾅｶ ﾍﾅﾏﾈｳｵ (ﾆｱｳﾁｵｴ) ﾂｹｲ/ｶｹﾂｵ, ｱｲﾅﾈﾎ ｹｶ ﾄﾅﾎ ｶﾅﾏﾄｴ  */
        CHKOBJ     OBJ(&PCKLIB/&PCKFIL) OBJTYPE(*FILE)
        MONMSG     MSGID(CPF0000) EXEC(DO)
        CHGVAR     VAR(&MSG) VALUE('Fｹﾂｵ ' *CAT &PCKFIL *CAT ' +
        ﾄﾅﾎ ｶﾅﾏﾄｴ ｹﾄ ﾂｹｲ ' *CAT &PCKLIB *CAT +
        ' -- Cﾅﾃﾃｱﾄｴ ｹﾍ ｱｲﾅﾈﾎｹﾄｷ!')
/* "Cｱﾂﾂ ﾆﾅﾆﾏﾆ ﾑｹﾄｴﾅﾑ API ｶﾅﾈ ｵﾈﾈﾅﾈ ﾃｵﾍﾍｱｷｵ, ﾎｸｵﾄ ｱｲﾅﾈﾎ ﾆﾈﾅｷﾈｱﾃ   */
/* "QUILNGTX ﾆｱﾈﾃﾍ:    Mｵﾍﾍｱｷｵ (Cｸｱﾈ, Lｵﾄｷﾎｸ ｴｵｶｹﾄｵｴ ｲﾓ Pｱﾈﾃ 2)   */
/* "Mｵﾍﾍｱｷｵ Lｵﾄｷﾎｸ (Hｵﾒ, 4 ｲﾓﾎｵﾍ ｲｹﾄｱﾈﾓ)                  */
/* "Mｵﾍﾍｱｷｵ ID (Cｸｱﾈ 7, BLANKS ﾏﾍｵｴ ｸｵﾈｵ)                 */
/* "Qﾏｱﾂｹｶｹｵｴ MSG Fｹﾂｵ Nｱﾃｵ (Cｸｱﾈ 20, BLANKS ﾏﾍｵｴ ｸｵﾈｵ)   */
/* "ERROR ｳﾅｴｵ (Pﾅｹﾄﾎｵﾈ, Hｵﾒ 4 ｲﾓﾎｵﾍ ｲｹﾄｱﾈﾓ)              */
        CALL       PGM(QUILNGTX) PARM(&MSG X'00000048' '       +
        ' '                    ' X'00000000')
        GOTO       CMDLBL(ENDPGM)
        ENDDO

/* "Cｸｵｳﾁ ｶﾅﾈ ｱﾐｱｹﾂｱｲｹﾂｹﾎﾓ ﾅｶ ﾍﾅﾏﾈｳｵ (ﾆｱｳﾁｵｴ) ﾂｹｲ/ｶｹﾂｵ, ｱｲﾅﾈﾎ ｹｶ ﾄﾅﾎ ｶﾅﾏﾄｴ */
        ALCOBJ     OBJ((&PCKLIB/&PCKFIL *FILE *SHRRD)) WAIT(1)
        MONMSG     MSGID(CPF0000) EXEC(DO)
        CHGVAR     VAR(&MSG) VALUE('Fｹﾂｵ ' *CAT &PCKFIL *CAT ' +
        ﾄﾅﾎ ｱﾐｱｹﾂｱｲﾂｵ ｹﾄ ﾂｹｲ ' *CAT &PCKLIB *CAT +
        ' -- Cﾅﾃﾃｱﾄｴ ｹﾍ ｱｲﾅﾈﾎｹﾄｷ!')
/*      "Cｱﾂﾂ ﾆﾅﾆﾏﾆ ﾑｹﾄｴﾅﾑ API ｶﾅﾈ ｵﾈﾈﾅﾈ ﾃｵﾍﾍｱｷｵ, ﾎｸｵﾄ ｱｲﾅﾈﾎ ﾆﾈﾅｷﾈｱﾃ  */
/*      "QUILNGTX ﾆｱﾈﾃﾍ:    Mｵﾍﾍｱｷｵ (Cｸｱﾈ, Lｵﾄｷﾎｸ ｴｵｶｹﾄｵｴ ｲﾓ Pｱﾈﾃ 2)  */
/*      "Mｵﾍﾍｱｷｵ Lｵﾄｷﾎｸ (Hｵﾒ, 4 ｲﾓﾎｵﾍ ｲｹﾄｱﾈﾓ)                  */
/*      "Mｵﾍﾍｱｷｵ ID (Cｸｱﾈ 7, BLANKS ﾏﾍｵｴ ｸｵﾈｵ)                 */
/*      "Qﾏｱﾂｹｶｹｵｴ MSG Fｹﾂｵ Nｱﾃｵ (Cｸｱﾈ 20, BLANKS ﾏﾍｵｴ ｸｵﾈｵ)   */
/*      "ERROR ｳﾅｴｵ (Pﾅｹﾄﾎｵﾈ, Hｵﾒ 4 ｲﾓﾎｵﾍ ｲｹﾄｱﾈﾓ)              */
        CALL       PGM(QUILNGTX) PARM(&MSG X'00000048' '       +
        ' '                    ' X'00000000')
        GOTO       CMDLBL(ENDPGM)
        ENDDO
        DLCOBJ     OBJ((&PCKLIB/&PCKFIL *FILE *SHRRD))

/*      "Cｸｵｳﾁ ｶﾅﾈ ｵﾒｹﾍﾎｵﾄｳｵ ﾅｶ ﾎｱﾈｷｵﾎ (ﾏﾄﾆｱｳﾁｵｴ) ﾂｹｲ/ｶｹﾂｵ, ｱｲﾅﾈﾎ ｹｶ ｶﾅﾏﾄｴ */
        CHKOBJ     OBJ(&UPKLIB/&UPKFIL) OBJTYPE(*FILE)
        MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(TARGET) )
        CHGVAR     VAR(&MSG) VALUE('Fｹﾂｵ ' *CAT &UPKFIL *CAT ' +
        ｵﾒｹﾍﾎﾍ ｹﾄ ﾂｹｲ ' *CAT &UPKLIB *CAT ' -- +
        Cﾅﾃﾃｱﾄｴ ｹﾍ ｱｲﾅﾈﾎｹﾄｷ!')
        CALL       PGM(QUILNGTX) PARM(&MSG X'00000040' '       +
        ' '                    ' X'00000000')
        GOTO       CMDLBL(ENDPGM)

TARGET:     /*  Tｱﾈｷｵﾎ (ﾏﾄﾆｱｳﾁｵｴ) ｴﾅｵﾍ ﾄﾅﾎ ｱﾂﾈｵｱｴﾓ ｵﾒｹﾍﾎ */

/*      Rﾎﾐ DDS ｶﾅﾈ ﾏﾄﾆｱｳﾁｵｴ ｶｹﾂｵ ﾎﾅ QTEMP/DDSTMP     */
        DLTF       FILE(QTEMP/DDSTMP)  /* Dｵﾂｵﾎｵ ｹｶ ｱﾂﾈｵｱｴﾓ ｵﾒｹﾍﾎ */
        MONMSG     MSGID(CPF0000) /* Iｷﾄﾅﾈｵ ｱﾂﾂ  */

        CRTSRCPF   QTEMP/DDSTMP
        MONMSG     MSGID(CPF0000)
        RTVDDSSRC  FILE(&PCKFIL) SRCFIL(DDSTMP)

/*  Mﾅｴｹｶﾓ ﾈｵﾎﾈｹｵﾐｵｴ DDS ﾍﾅﾏﾈｳｵ ﾎﾅ ｹｴｵﾄﾎｹｶﾓ ｱﾄﾓ ﾄﾏﾃｵﾈｹｳ ｶｹｵﾂｴﾍ ｴｵｶｹﾄｵｴ ｱﾍ */
/*  "ﾆｱｳﾁｵｴ, ｱﾄｴ ﾈｵｴｵｶｹﾄｵ ｱﾍ ﾔﾅﾄｵｴ; ｱﾂﾍﾅ, ｵﾒﾆｱﾄｴ ｶｹｵﾂｴ ﾂｵﾄｷﾎｸ.            */
        OVRDBF     SRCF QTEMP/DDSTMP MBR(&PCKFIL)
    /*  CALL       @MODSRC002 */
        CALL       JMODSRC

/*  Cﾈｵｱﾎｵ ｶｹﾂｵ ﾎﾅ ｸﾅﾂｴ ﾏﾄﾆｱｳﾁｵｴ ｶｹｵﾂｴﾍ ﾏﾍｹﾄｷ ﾃﾅｴｹｶｹｵｴ DDS.  Nﾅﾎｵ ｶｹﾂｵ     */
/*  ﾍｹﾔｵ ｱﾄｴ ｹﾄｳﾈｵﾃｵﾄﾎﾍ ｱﾈｵ ﾂｱﾈｷｵﾈ ﾎｸｱﾄ ﾍﾓﾍﾎｵﾃ ｴｵｶｱﾏﾂﾎ.  Aﾂﾍﾅ ﾄﾅﾎｵ ﾎｸｱﾎ ﾄｵﾑ */
/*  ｶｹﾂｵ ｴｵﾍｳﾈｹﾆﾎｹﾅﾄ ｹﾄｴｹｳｱﾎｵﾍ ﾅﾈｹｷｹﾄｱﾂ ｶｹﾂｵ ﾑｹﾎｸ ﾆｱｳﾁｵｴ ﾄﾏﾃｵﾈｹｳ ｴｱﾎｱ.     */
        CRTPF      FILE(&UPKLIB/&UPKFIL) SRCFILE(QTEMP/DDSTMP) +
        SRCMBR(&PCKFIL) TEXT('UNPACKｵｴ +
        ｶﾈﾅﾃ ' *CAT &PCKLIB *TCAT '/' *TCAT +
        &PCKFIL) OPTION(*NOSRC *NOLIST) +
        SIZE(10000 10000 300)

/*      Cﾅﾆﾓ ﾎﾅ ﾄｵﾑ ｶｹﾂｵ ﾏﾍｹﾄｷ FMTOPT(*MAP)    */
        CPYF       FROMFILE(&PCKLIB/&PCKFIL) +
        TOFILE(&UPKLIB/&UPKFIL) MBROPT(*REPLACE) +
        FROMRCD(1) FMTOPT(*MAP)

/*      Dｵﾂｵﾎｵ ﾑﾅﾈﾁｹﾄｷ DDS ﾍﾅﾏﾈｳｵ ｶｹﾂｵ         */
        DLTF       QTEMP/DDSTMP

ENDPGM:     DLTOVR     FILE(*ALL)

        ENDPGM
