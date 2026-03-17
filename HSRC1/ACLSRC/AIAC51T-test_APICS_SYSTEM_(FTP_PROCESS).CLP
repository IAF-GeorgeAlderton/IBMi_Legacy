           /*PGM       PARM(&LOCATION &PC_SYS)    */
             PGM
             /*   AIAC51 , AIAC52 は一緒に修正すること！*/
             /*********************************************/
             /*  &LOCATION  &PC_SYS       NOTES           */
             /* ﾜiｰﾆｭ]　システム区分 備考           */
             /*    9999        ZM        図面サーバー   */
             /*    0111        AP        ﾎﾟﾛbmｧ]hﾞ発行機*/
             /*********************************** AIAC51 **/
             DCL        VAR(&LOCATION) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PC_SYS) TYPE(*CHAR) LEN(2)
             DCL        VAR(&FTP_LIB) TYPE(*CHAR) LEN(10)

             /*-----------------------------------*/
             /*  サーバー別利用ファイルのセット */
             /*-----------------------------------*/
             CHGVAR     VAR(&FTP_LIB)  VALUE('TWFILE1 ')
             CHGVAR     VAR(&LOCATION) VALUE('0111')
             CHGVAR     VAR(&PC_SYS )  VALUE('AP')
             CHGVAR     VAR(&AT_TMP)   VALUE('AT' *CAT &LOCATION *CAT +
                          &PC_SYS *CAT 'E')

             OVRDBF     FILE(INPUT) TOFILE(&FTP_LIB/&AT_TMP)
             CALL       PGM(AIAR52) PARM(&PSTS &LOCATION &PC_SYS +
                          &PKFLG &PFILE &PUALL)

 ENDCL:      ENDPGM
