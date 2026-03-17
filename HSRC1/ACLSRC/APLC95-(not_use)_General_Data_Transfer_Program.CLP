             PGM        PARM(&PFRMLB &PFRMFL &PTYPE &PTODIR &PIPGMN)
             /** APLC95 ******************************************/
             /*汎用データ転送プログラム                        */
             /*    MSK           2011.02.09                      */
             /*　パラメータ説明                                */
             /*    &PFRMLB :転送するデータのライブラリー       */
             /*    &PFRMFL :転送するデータのファイル名         */
             /*    &PTYPE  :転送するデータ形式                 */
             /*       '1':PCﾃｰnﾞmgﾇn                             */
             /*       '3':BASIC順次                            */
             /*       '9':BIFF4                                  */
             /*    &PTODIR :転送するデータの保存先ディレクトリ */
             /*             （呼出元で設定したデフォルト値）   */
             /*    &PIPGMN :呼出元のプログラム名               */
             /* ※C:$AS400$TTOにTTOSND.TTOを保管すること   */
             /* ※論理ファイルはできません                     */
             /****************************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3)  TYPE(*CHAR) LEN(3)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)

             DCL        VAR(&WS)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&PFRMLB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PFRMFL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PTODIR) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PIPGMN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CMD1) TYPE(*CHAR) LEN(90)
             DCL        VAR(&APLPP00) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ANYFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PODIR)  TYPE(*CHAR) LEN(200)
             DCL        VAR(&POSTS) TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WS) USER(&USER)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WS 1 3))

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGVAR     VAR(&APLPP00) VALUE('APLPP00' *CAT &WS3)
             CHGVAR     VAR(&ANYFILE) VALUE('ANYFILE' *CAT &WS3)

         /*転送先の指定*/
             CALL       PGM(APLR95) PARM(&PIPGMN &WS &PODIR &POSTS)
             IF         COND(&POSTS *EQ '1') THEN(DO)
             CHGVAR     VAR(&PTODIR) VALUE(&PODIR)
             ENDDO

             CPYF       FROMFILE(HWFILE1/APLPP00) +
                          TOFILE(HWFILE1/&APLPP00) +
                          MBROPT(*REPLACE) CRTFILE(*YES)

             OVRDBF     FILE(APLPP00) TOFILE(HWFILE1/&APLPP00)
             CALL       PGM(APLR91) PARM(HWFILE1 &ANYFILE +
                          &PTYPE &PTODIR)

             DLTF       FILE(HWFILE1/&ANYFILE)
             MONMSG     MSGID(CPF2105)

        /*   CPYF       FROMFILE(&PFRMLB/&PFRMFL) +          */
        /*                TOFILE(HWFILE1/&ANYFILE) +       */
        /*                MBROPT(*REPLACE) FMTOPT(*NOCHK)    */

             CRTDUPOBJ  OBJ(&PFRMFL) FROMLIB(&PFRMLB) OBJTYPE(*FILE) +
                          TOLIB(HWFILE1) NEWOBJ(&ANYFILE) DATA(*YES)

             CHGVAR     VAR(&CMD1) VALUE('"C:$PROGRAM FILES$PERSONAL +
                          COMMUNICATIONS$PCSFT5.EXE" +
                          C:$AS400$TTO$TTOSNDIAF.TTO')
             STRPCO     PCTA(*NO)
             MONMSG     MSGID(CPF0000)
             STRPCCMD   PCCMD(&CMD1) PAUSE(*NO)

             CHGVAR     VAR(&CMD1) VALUE('"C:$PROGRAM FILES$PERSONAL +
                          COMMUNICATIONS$PCSFT5.EXE" +
                          C:$AS400$TTO$ANYFTTO.TTO')
             STRPCO     PCTA(*NO)
             MONMSG     MSGID(CPF0000)
             STRPCCMD   PCCMD(&CMD1) PAUSE(*NO)

 @END:       ENDPGM
