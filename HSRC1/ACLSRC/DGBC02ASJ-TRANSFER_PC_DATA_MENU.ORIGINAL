             PGM
             /** DGBC02 *************************/
             /*  ＰＣデータ転送用総合メニュー */
             /*        M-OKUDA      03.07.02    */
             /************************* DGBC02 **/
             DCLF       FILE(DGBPW02)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             RTVJOBA    JOB(&WS) USER(&US)
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)
 STEP00:     CHGVAR     VAR(&IN01) VALUE('0')
             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN03) VALUE('0')
             CHGVAR     VAR(&NO) VALUE(0)

 STEPSS:     SNDRCVF    DEV(&WS) RCDFMT(DGBPW021)
             CHGVAR     VAR(&IN99) VALUE('0')
             IF         (&IN01 *EQ '1') GOTO END
             IF         (&IN02 *EQ '1') GOTO STEPSP
             IF         (&IN03 *EQ '1') GOTO END

             IF         (&NO *EQ 1) GOTO STEP01
             IF         (&NO *EQ 2) GOTO STEP02
             IF         (&NO *EQ 3) GOTO STEP03
             IF         (&NO *EQ 4) GOTO STEP04
             IF         (&NO *EQ 5) GOTO STEP05
             IF         (&NO *EQ 6) GOTO STEP06
             IF         (&NO *EQ 7) GOTO STEP07
             IF         (&NO *EQ 8) GOTO STEP08
             IF         (&NO *EQ 9) GOTO STEP09
             IF         (&NO *EQ 10) GOTO STEP10
             IF         (&NO *EQ 11) GOTO STEP11
             IF         (&NO *EQ 12) GOTO STEP12
             IF         (&NO *EQ 13) GOTO STEP13
             IF         (&NO *EQ 14) GOTO STEP14
             IF         (&NO *EQ 15) GOTO STEP15
             IF         (&NO *EQ 16) GOTO STEP16
             IF         (&NO *EQ 16) GOTO STEP16
             IF         (&NO *EQ 17) GOTO STEP17
             IF         (&NO *EQ 18) GOTO STEP18
             IF         (&NO *EQ 19) GOTO STEP19
             IF         (&NO *EQ 20) GOTO STEP20
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) +
                          VALUE('選択№を正しく入力して下さい。')
             GOTO       STEPSS

 STEPSP:     WRKOUTQ    OUTQ(&PRTG)
             GOTO       STEP00
             /*設備負荷グラフデータの作成　　*/
 STEP01:     CALL       MEBC1N
             GOTO       STEP00
             /*設備負荷情報の作成　　　　　 */
 STEP02:     CALL       MEBC20
             GOTO       STEP00
             /*設備管理Ｍと生産実績　　　 */
 STEP03:     CALL       MDBC81
             GOTO       STEP00
             /*工程Ｍと設備管理Ｍの不照合　 */
 STEP04:     CALL       GHCC31
             GOTO       STEP00
             /*設備管理情報の抜出し　　　 */
 STEP05:     CALL       MDBC81
             GOTO       STEP00
             /*型の新設・継続・廃止型費　 */
 STEP06:     CALL       ECVC56
             GOTO       STEP00
             /*機番別個当たり型費データ　 */
 STEP07:     CALL       FCDC75
             GOTO       STEP00
             /*機番別型消費統計データ　　 */
 STEP08:     CALL       FCDC77
             GOTO       STEP00
             /*型番範囲指定で型消費データ*/
 STEP09:     CALL       FCDC93
             GOTO       STEP00
             /*廃止型の工場転売データ作成  */
 STEP10:     CALL       FCDC70
             GOTO       STEP00
             /*再メッキ品番明細データ */
 STEP11:     CALL       FCDC41
             GOTO       STEP00
             /*工場間物流データ　　　　 */
 STEP12:     CALL       OKUC31
             GOTO       STEP00
             /*工程内不良データの抜出し */
 STEP13:     CALL       NSAC61
             GOTO       STEP00
             /*機番別品種切替データの作成　*/
 STEP14:     CALL       MCDC26
             GOTO       STEP00
             /*作業日報品番別明細データ作成 */
 STEP15:     CALL       FCDC87
             GOTO       STEP00
             /*作業日報項目別時間データ */
 STEP16:     CALL       FCDC80
             GOTO       STEP00
             /*機番別作業日報データ　　　　*/
 STEP17:     CALL       FCDC85
             GOTO       STEP00
             /*センター・社員別作業日報　　*/
 STEP18:     CALL       FCDC83
             GOTO       STEP00
             /*センター別作業日報データ */
 STEP19:     CALL       FCDC81
             GOTO       STEP00
             /*前のメニュー　　　　　　 */
 STEP20:
             CALL       MCDC52
             GOTO       STEP00
 END:        RETURN
             ENDPGM
