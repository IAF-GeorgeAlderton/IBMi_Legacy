             PGM
             /** CHKC35 *****************************************/
             /*  REMOVE GENTRAN ARC 7 DAYS OLD MEBER (DAILY)    */
             /*  ADD JOB TO VJBC71  (JOB SCHEDULE  05:45 AM)    */
             /*  J.WATANABE 2018.09.26                          */
             /***************************************************/

             DCL        VAR(&DATE6) TYPE(*CHAR) LEN(6)
             DCL        VAR(&DATE8) TYPE(*CHAR) LEN(8)
             DCL        VAR(&SIGN ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DAYS ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&IAF  ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TGT8 ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&RTN  ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&LIB  ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB  ) TYPE(*CHAR) LEN(10)

             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&DATE6)
             CHGVAR     VAR(&DATE8) VALUE('20' *CAT &DATE6)
             CHGVAR     VAR(&SIGN ) VALUE('-')
             CHGVAR     VAR(&IAF  ) VALUE('N')
             CHGVAR     VAR(&TGT8 ) VALUE('        ')
             CHGVAR     VAR(&RTN  ) VALUE(' ')
             CHGVAR     VAR(&LIB  ) VALUE('HFILE1')
             CHGVAR     VAR(&WLIB ) VALUE('HWFILE1')

 /* KEEP 7 DAYS -----------------------------------------------------------*/
             CHGVAR     VAR(&DAYS ) VALUE('0007')
             CALL       PGM(UTLR10) PARM(&DATE8 &SIGN &DAYS &IAF &TGT8 &RTN)

 /* ABVEP52ARC */
             CALL       PGM(UTLC91) PARM(&TGT8 'ABVEP52ARC' &WLIB)
 /* ABVEP53ARC */
             CALL       PGM(UTLC91) PARM(&TGT8 'ABVEP53ARC' &WLIB)
 /* ABVEP54ARC */
             CALL       PGM(UTLC91) PARM(&TGT8 'ABVEP54ARC' &WLIB)
 /* ABVEP55ARC */
             CALL       PGM(UTLC91) PARM(&TGT8 'ABVEP55ARC' &WLIB)
 /* ABVEP56ARC */
             CALL       PGM(UTLC91) PARM(&TGT8 'ABVEP56ARC' &WLIB)
 /* ABVEP57ARC */
             CALL       PGM(UTLC91) PARM(&TGT8 'ABVEP57ARC' &WLIB)

 /* KEEP 30 DAYS ----------------------------------------------------------*/
             CHGVAR     VAR(&DAYS ) VALUE('0030')
             CALL       PGM(UTLR10) PARM(&DATE8 &SIGN &DAYS &IAF &TGT8 &RTN)

 /* AB#WP2I    */
             CALL       PGM(UTLC91) PARM(&TGT8 'AB#WP2I   ' &LIB)
 /* AB#WP2M    */
             CALL       PGM(UTLC91) PARM(&TGT8 'AB#WP2M   ' &LIB)

 END:        ENDPGM
