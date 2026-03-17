             PGM       PARM(&LOCATION &PC_SYS)
             /** AIAC58 **********************************************/
             /*ＡＰＩＣＳ（ＦＴＰ通信終了処理）                    */
             /*  CODING:A.MAMIYA  2005.09.26                         */
             /*  UPDATE:                                             */
             /*------------------------------------------------------*/
             /*  稼動チェック用データエリアの削除                  */
             /********************************************** AIAC57 **/
             DCL        VAR(&LOCATION) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PC_SYS) TYPE(*CHAR) LEN(2)

             DCL        VAR(&ACTDTAARA) TYPE(*CHAR) LEN(10)

             CHGVAR     VAR(&ACTDTAARA) VALUE(&PC_SYS *CAT &LOCATION +
                          *CAT 'ACT')

             DLTDTAARA  DTAARA(APICSFTP/&ACTDTAARA)
             MONMSG     MSGID(CPF2105)

             ENDPGM
