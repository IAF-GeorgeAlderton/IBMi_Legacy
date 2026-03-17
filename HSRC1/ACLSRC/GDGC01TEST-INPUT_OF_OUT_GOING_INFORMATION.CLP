             PGM
             /** GDGC01 ************************/
             /* INPUT OF OUT GOING INFORMATION */
             /*   G.B.C             97/02/18   */
             /************************ GDGC01 **/
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&PPUSER) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)

        /*  MSK 2004.11.10 */
             CHKOBJ     OBJ(TWFILE1/GDGWP9X) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)

             CRTPF      FILE(TWFILE1/GDGWP9X) RCDLEN(128) +
                          OPTION(*NOLIST *NOSRC) SIZE(*NOMAX) +
                          LVLCHK(*NO) AUT(*ALL)
             ENDDO

             CHGJOB     OUTQ(&PRTG)

             OVRDBF     FILE(GDGPW01) TOFILE(TOBJ1/GDGPW01)
             OVRDBF     FILE(GDGPL02) TOFILE(TFILE1/GDGPL02)
             OVRDBF     FILE(GDGNP01) TOFILE(TWFILE1/GDGNP01)
             OVRDBF     FILE(GDGPL01) TOFILE(TFILE1/GDGPL01)
             OVRDBF     FILE(AAPPL05) TOFILE(HFILE1/AAPPL05)
             OVRDBF     FILE(AKBPL06) TOFILE(HFILE1/AKBPL06)
             OVRDBF     FILE(AANPL05) TOFILE(HFILE1/AANPL05)
             OVRDBF     FILE(AAPTL01) TOFILE(HFILE1/AAPTL01)
             OVRDBF     FILE(AKBPL04) TOFILE(HFILE1/AKBPL04)
             OVRDBF     FILE(AANPL06) TOFILE(HFILE1/AANPL06)
             OVRDBF     FILE(GDKPL02) TOFILE(HFILE1/GDKPL02)
             OVRDBF     FILE(GDGPL25) TOFILE(HFILE1/GDGPL25)
             OVRDBF     FILE(AGDPL12) TOFILE(HFILE1/AGDPL12)
             OVRDBF     FILE(GDGPP02) TOFILE(TFILE1/GDGPP02)
             OVRDBF     FILE(GDGPPNO) TOFILE(TFILE1/GDGPPNO)
             OVRDBF     FILE(GDGWP9X) TOFILE(TWFILE1/GDGWP9X)
             OVRDBF     FILE(IICSD)   TOFILE(TWFILE1/IICSD)
             OVRDBF     FILE(FCEPL01) TOFILE(HFILE1/FCEPL01)
             OVRDBF     FILE(GDMPL10) TOFILE(HFILE1/GDMPL10)
             OVRDBF     FILE(GDMPL82) TOFILE(HFILE1/GDMPL82)

             CALL       PGM(TOBJ1/GDGR01) PARM(&USER)

             ENDPGM
