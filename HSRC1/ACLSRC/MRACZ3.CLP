             PGM       PARM(&USER &WNBR &LOCATION &PC_SYS)
             /** MRACZ3 **********************************************/
             /*通信処理　キャンセル JOB                            */
             /*  TRANCOM ITS      2011.11.28                         */
             /*  UPDATE:                                             */
             /*------------------------------------------------------*/
             /* 終了（当日）起動（翌日）の状態                 */
             /*------------------------------------------------------*/
             /* 昼勤 | 夜勤 |  終了日付    |   起動日付      */
             /*  ﾎﾞ[]h |  ﾎﾞ[]h | (翌日04:30 ) |  (翌日04:40 )   */
             /*  ﾎﾞ[]h |    *   | (当日17:00 ) |  (翌日04:40 )   */
             /*    *   |  ﾎﾞ[]h | (翌日04:30 ) |  (翌日17:45 )   */
             /*    *   |    *   | (即時終了  ) |  (起動無し  )   */
             /********************************************** AIAC57 **/
             DCL        VAR(&LOCATION) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PC_SYS) TYPE(*CHAR) LEN(2)
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WNBR)   TYPE(*CHAR) LEN(6)

             DCL        VAR(&EDATE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&ETIME) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SDATE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&STIME) TYPE(*CHAR) LEN(6)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)

             CHGVAR     VAR(&JOB) VALUE(&PC_SYS *CAT &LOCATION)

             CALL       PGM(MRARZ3) PARM(&EDATE &ETIME &SDATE &STIME)

             CALL       PGM(ENDR01) PARM(&JOB &USER &WNBR &EDATE +
                          &ETIME '          ' '          ' &SDATE +
                          &STIME 'MRACZ1    ' &LOCATION &PC_SYS +
                          &JOB 'QBATCH1   ' 'QBATCH1   ' '          +
                          ' '          ')

             ENDPGM
