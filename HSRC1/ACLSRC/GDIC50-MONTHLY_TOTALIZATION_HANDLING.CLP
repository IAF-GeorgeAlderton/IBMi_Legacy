             PGM
             /*** GDIC50 ************************/
             /*  MONTHLY TOTALIZATION HANDLING  */
             /*   G.B.C              97/03/06   */
             /***********************************/
             DCLF       FILE(GDIPW50)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CHK) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&DATE2) TYPE(*CHAR) LEN(6)
             DCL        VAR(&DY0) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DY1) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DMM) TYPE(*CHAR) LEN(2)
            /*-------------------------------------------------------*/
             RTVJOBA    USER(&USER) DATE(&DATE)

             CHGVAR     VAR(&DY1) VALUE(%SST(&DATE 1 2))
             CHGVAR     VAR(&DMM) VALUE(%SST(&DATE 3 2))
             CHGVAR     VAR(&DY0) VALUE('19')
             IF         COND(&DY1 *LE '90') THEN(CHGVAR VAR(&DY0) +
                          VALUE('20'))
             CHGVAR     VAR(%SST(&DATE2 1 2)) VALUE(&DY0)
             CHGVAR     VAR(%SST(&DATE2 3 2)) VALUE(&DY1)
             CHGVAR     VAR(%SST(&DATE2 5 2)) VALUE(&DMM)

             CHGVAR     VAR(&D#MSG) VALUE(' ')
             CHGVAR     VAR(&IN99) VALUE('0')

             DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000)

             CHGVAR     VAR(&D1YYMM) VALUE(&DATE2)
             CHGVAR     VAR(&IN11) VALUE('0')

 DSP1:       CHGVAR     VAR(&IN01) VALUE('0')
             CHGVAR     VAR(&IN05) VALUE('0')

             SNDRCVF    RCDFMT(DSP01)
             IF         (&IN01 = '1') GOTO END
             CHGVAR     VAR(&IN99) VALUE('0')

             CHGVAR     VAR(&DATE2) VALUE(&D1YYMM)
             CHGVAR     VAR(&CHK) VALUE(%SST(&DATE2 5 2))
             IF         (&CHK *GE '13') GOTO ERR1
             IF         (&CHK *LE '00') GOTO ERR1

             IF         (&IN05 = '0') GOTO DSP1
             GOTO       STEP

 ERR1:
             CHGVAR     VAR(&IN11) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&D#MSG) VALUE('INCORRECT DATE.')
             GOTO       DSP1

 STEP:
             CALL       PGM(GDIR50) PARM(&USER &DATE2)

             /* ORDER RESULTS LIST */
             CALL       PGM(GDIR51) PARM(&USER &DATE2)

             /*                    */
             CALL       PGM(GDIR52) PARM(&USER &DATE2)

     /*    日次発注データファイル        */
             RGZPFM     FILE(GDIPP15)
             MONMSG     MSGID(CPF2981)

     /*    インボイス番号管理データファイル        */
             RGZPFM     FILE(GDIPP25)
             MONMSG     MSGID(CPF2981)

 END:        ENDPGM
