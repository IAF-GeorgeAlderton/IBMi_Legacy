             PGM
             /*** GDIC20 ***********************************/
             /*  UPDAT OF SHIPPING INFORMATION (8MM TAPE)  */
             /*    G.B.C                      97/02/24     */
             /*    ADD FOR TEST MODE  HAYA  2004.01.22     */
             /**********************************************/
             DCLF       FILE(GDIPW20)
             DCL        VAR(&USER) TYPE(*CHAR)  LEN(10)
             DCL        VAR(&SNDA) TYPE(*CHAR)  LEN(4)
             DCL        VAR(&RCVA) TYPE(*CHAR)  LEN(1)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             RTVJOBA    USER(&USER)
            /*-------------------------------------------------------*/
             CALL       PGM(ALBC00) PARM(&USER &WLIB)
             CHGVAR     VAR(&D#MSG) VALUE(' ')
             CHGVAR     VAR(&IN99) VALUE('0')

             DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000)

 DSP1:       CHGVAR     VAR(&IN01) VALUE('0')
             CHGVAR     VAR(&IN05) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             /* CHECK THE SNDNETF */
             RTVMBRD    FILE(&WLIB/GIGWP53) NBRCURRCD(&REC)
             IF         COND(&REC = 0) THEN(DO)
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&D#MSG) VALUE('SHIPPNG DATA IS NOTHING +
                          !  CAN NOT INPUT DATA.PUSH CMD-1.')
             ENDDO

             SNDRCVF    RCDFMT(DSP01)
             IF         (&IN01 = '1') GOTO END
             IF         (&IN99 = '1') GOTO DSP1
             IF         (&IN05 = '0') GOTO DSP1

 JOB1:       DLTF       FILE(QTEMP/GDIWP01)
             MONMSG     MSGID(CPF0000)
             CRTPF      FILE(QTEMP/GDIWP01) RCDLEN(200)
             CPYF       FROMFILE(&WLIB/GIGWP53) +
                          TOFILE(QTEMP/GDIWP01) TOMBR(*FIRST) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)

 JOB2:       OVRDBF     FILE(FILE1) TOFILE(QTEMP/GDIWP01)
             CALL       PGM(GDIR20) PARM(&USER)
             CALL       PGM(GDKR07)
             DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(&WLIB/GIGWP53)

 END:        ENDPGM
