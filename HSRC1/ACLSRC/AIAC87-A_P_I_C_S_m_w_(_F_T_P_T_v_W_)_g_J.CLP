             PGM       PARM(&USER &WNBR &LOCATION &PC_SYS)
             /** AIAC77 **********************************************/
             /*ＡＰＩＣＳシステム（ＦＴＰ通信処理）キャンセル JOB  */
             /*  CODING:A.MAMIYA  2004.08.29                         */
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

             DCL        VAR(&ACTDTAARA) TYPE(*CHAR) LEN(10)
             DCL        VAR(&EDATE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&ETIME) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SDATE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&STIME) TYPE(*CHAR) LEN(6)
             DCL        VAR(&STPGM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&EJOB) TYPE(*CHAR) LEN(10)

             CHGVAR     VAR(&JOB) VALUE(&PC_SYS *CAT &LOCATION)
             CHGVAR     VAR(&EJOB) VALUE(&PC_SYS *CAT &LOCATION)

             CHGVAR     VAR(&ACTDTAARA) VALUE(&PC_SYS *CAT &LOCATION +
                          *CAT 'ACT')

             CALL       PGM(AIAR57) PARM(&EDATE &ETIME &SDATE &STIME)

             CHGVAR     VAR(&STPGM) VALUE('AIAC81    ')
             IF         COND(&SDATE = '00000000' *AND &STIME = +
                          '000000') THEN(DO)
             CHGVAR     VAR(&STPGM) VALUE('AIAC58    ')
             CHGVAR     VAR(&SDATE) VALUE(&EDATE)
             CHGVAR     VAR(&STIME) VALUE(&ETIME)
             CHGVAR     VAR(&EJOB) VALUE('E' *CAT &PC_SYS *CAT +
                          &LOCATION)
             ENDDO

             CALL       PGM(ENDR01) PARM(&JOB &USER &WNBR &EDATE +
                          &ETIME '          ' '          ' &SDATE +
                          &STIME &STPGM &LOCATION &PC_SYS &EJOB +
                          'APICSCTL  ' 'APICSCTL  ' '          ' +
                          '          ')

             ENDPGM
