             PGM       PARM(&USER &WNBR)
             /** AIAC57 **********************************************/
             /* CANCELLING COMMUNICATION PROGRAM FOR MEKI_M          */
             /*  CODING:T.SAKASHITA 2010.04.15                       */
             /*  UPDATE:                                             */
             /*------------------------------------------------------*/
             /*  DAY   : NIGHT  :  END DATE      :   START DATE      */
             /*  BLANK :  BLANK : ( NEXT 04:30 ) :  ( NEXT 04:40 )   */
             /*  BLANK :    *   : (TODAY 17:00 ) :  ( NEXT 04:40 )   */
             /*    *   :  BLANK : ( NEXT 04:30 ) :  ( NEXT 17:45 )   */
             /*    *   :    *   : ( END IMMED  ) :  ( NO START   )   */
             /********************************************** AIAC57 **/
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WNBR)   TYPE(*CHAR) LEN(6)

             DCL        VAR(&EDATE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&ETIME) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SDATE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&STIME) TYPE(*CHAR) LEN(6)
             DCL        VAR(&STPGM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)

             CHGVAR     VAR(&JOB) VALUE('MEKI_M    ')

             CALL       PGM(AJVRE4) PARM(&EDATE &ETIME &SDATE &STIME)

             CHGVAR     VAR(&STPGM) VALUE('AJVCM1    ')
             IF         COND(&SDATE = '00000000' *AND &STIME = +
                          '000000') THEN(DO)
             CHGVAR     VAR(&STPGM) VALUE('AJVCM1    ')
             CHGVAR     VAR(&SDATE) VALUE(&EDATE)
             CHGVAR     VAR(&STIME) VALUE(&ETIME)
             ENDDO

             CALL       PGM(ENDR01) PARM(&JOB &USER &WNBR &EDATE +
                          &ETIME 'AJVCM1ACT ' 'HOBJ1     ' &SDATE +
                          &STIME &STPGM ' '       ' '     &JOB +
                          'QBATCH    ' 'QBATCH    ' '          ' +
                          '          ')

             ENDPGM
