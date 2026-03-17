             PGM        PARM(&PARM1 &PARM2 &MBR &PARM3 &PARM4 &PARM5)
             /** AA900C ******************************************/
             /*ＣＡ用　汎用データ転送プログラム（ＤＴＦ）      */
             /*        M.KATOGI               2012.2.1           */
             /*--------------------------------------------------*/
             /* &PARM1 ライブラリ                              */
             /* &PARM2 ファイル名前                            */
             /* &MBR   メンバー名                              */
             /* &PARM3 ホスト                                  */
             /* &PARM4 ＰＣファイル保管先                      */
             /* &PARM5 ＰＣファイルタイプ                      */
             /* &PARM5= 1:ＡＳＣⅡテキスト　　　　　　         */
             /*       = 6:無変換                               */
             /*       = 9: BIFF4                                 */
             /*       =12:コンマ区切り可変長（ＣＳＶ）         */
             /*       =14:タブ区切り　                         */
             /*       =16: BIFF8                                 */
             /****************************************************/
             DCL        VAR(&PARM1)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PARM2)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBR)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&PARM3)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&PARM4)  TYPE(*CHAR) LEN(52)
             DCL        VAR(&PARM5)  TYPE(*CHAR) LEN(2)
             DCL        VAR(&PARMS)  TYPE(*CHAR) LEN(21)
             DCL        VAR(&PARMX)  TYPE(*CHAR) LEN(30)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&SFT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PSTS) TYPE(*CHAR) LEN(2) VALUE(' ')
             DCL        VAR(&US)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS)    TYPE(*CHAR) LEN(10)

             DCL        VAR(&CMD)    TYPE(*CHAR) LEN(123)

             RTVJOBA    JOB(&WS) USER(&US)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WS 1 3))

         /*実行判断*/
         /*  CALL       PGM(AA889R) PARM(&WS3 &SFT)  */
         /*  IF         COND(&SFT *NE 'CA') THEN(DO) */
         /*  GOTO       CMDLBL(@END)                 */
         /*  ENDDO                                   */

             CALL       PGM(APLR98) PARM(&PARM1 &PARM2 &PARMS)

             CHGVAR     VAR(&PARMS) VALUE(' ')
             CHGVAR     VAR(&PARMS) VALUE(&PARM1 *TCAT '/' *TCAT +
                          &PARM2 *TCAT '(' *TCAT &MBR *TCAT ')')

          /*ＰＣＯＭのバージョン確認　５．０はオミット*/
         /*  CALL       PGM(AA902R) PARM(&PSTS)                     */
         /*  IF         COND(&PSTS *EQ 'NG') THEN(GOTO CMDLBL(@END))*/

          /*システム名称をドメイン付きに変更*/
             IF         COND(&PARM3 *EQ 'AOYAMA') THEN(DO)
             CHGVAR     VAR(&PARMX) VALUE('AOYAMA.ASJ-FASTENERS.CO.JP')
             ENDDO
             IF         COND(&PARM3 *EQ 'IAFAYM') THEN(DO)
             CHGVAR     VAR(&PARMX) VALUE('IAFAYM.ASJ-FASTENERS.CO.JP')
             ENDDO
             IF         COND(&PARM3 *EQ 'IAF') THEN(DO)
             CHGVAR     VAR(&PARMX) VALUE('IAF.ASJ-FASTENERS.CO.JP')
             ENDDO
             IF         COND(&PARM3 *EQ 'ATC') THEN(DO)
             CHGVAR     VAR(&PARMX) VALUE('ATC.ASJ-FASTENERS.CO.JP')
             ENDDO
             IF         COND(&PARM3 *EQ 'ACZ') THEN(DO)
             CHGVAR     VAR(&PARMX) VALUE('ACZ.ASJ-FASTENERS.CO.JP')
             ENDDO
             IF         COND(&PARM3 *EQ 'AFS') THEN(DO)
             CHGVAR     VAR(&PARMX) VALUE('AFS.ASJ-FASTENERS.CO.JP')
             ENDDO
             IF         COND(&PARM3 *EQ 'ASI') THEN(DO)
             CHGVAR     VAR(&PARMX) VALUE('ASI.ASJ-FASTENERS.CO.JP')
             ENDDO
             IF         COND(&PARM3 *EQ 'CKJ') THEN(DO)
             CHGVAR     VAR(&PARMX) VALUE('CKJ.ASJ-FASTENERS.CO.JP')
             ENDDO
             IF         COND(&PARM3 *EQ 'SNF') THEN(DO)
             CHGVAR     VAR(&PARMX) VALUE('SNF.ASJ-FASTENERS.CO.JP')
             ENDDO

             STRPCO     PCTA(*NO)
             MONMSG     MSGID(CPF0000)

             CHGVAR     VAR(&CMD) VALUE('C:/AS400/TTO/ANYFTTO.BAT' +
                          *BCAT &PARMS *BCAT &PARMX *BCAT &PARM4 +
                          *BCAT &PARM5)

             STRPCCMD   PCCMD(&CMD) PAUSE(*NO)

 @END:
             ENDPGM
