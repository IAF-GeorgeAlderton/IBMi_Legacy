             PGM
             /*** GDGC20 ***********************************/
             /*  UPDAT OF SHIPPING INFORMATION (SNDNETF)   */
             /*    G.B.C                      97/02/24     */
             /*  GDGR20 ->ASJOUTQ         05/13/04   */
             /**********************************************/
             DCLF       FILE(GDGPW20)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SNDA) TYPE(*CHAR)  LEN(4)
             DCL        VAR(&RCVA) TYPE(*CHAR)  LEN(1)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             RTVJOBA    USER(&USER)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGJOB     OUTQ(&PRTG)

             CALL       PGM(ALBC00) PARM(&USER &WLIB)
            /*-------------------------------------------------------*/
             CHGVAR     VAR(&D#MSG) VALUE(' ')
             CHGVAR     VAR(&IN99) VALUE('0')

             DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000)

 DSP1:       CHGVAR     VAR(&IN01) VALUE('0')
             CHGVAR     VAR(&IN05) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             /* CHECK THE SNDNETF */
             RTVMBRD    FILE(&WLIB/GIGWP52) NBRCURRCD(&REC)
             IF         COND(&REC = 0) THEN(DO)
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&D#MSG) VALUE('SHIPPNG DATA IS NOTHING +
                          !  CAN NOT INPUT DATA.PUSH CMD-1.')
             ENDDO

             SNDRCVF    RCDFMT(DSP01)

             IF         (&IN01 = '1') GOTO END
             IF         (&IN99 = '1') GOTO DSP1
             IF         (&IN05 = '0') GOTO DSP1

 JOB1:       DLTF       QTEMP/GDGWP01
             MONMSG     CPF0000
             CRTPF      FILE(QTEMP/GDGWP01) RCDLEN(200)
             CPYF       FROMFILE(&WLIB/GIGWP52) +
                          TOFILE(QTEMP/GDGWP01) TOMBR(*FIRST) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)

JOB2:        OVRDBF     FILE(INFILE) TOFILE(QTEMP/GDGWP01)
             OVRDBF     FILE(FILE1) TOFILE(QTEMP/GDGWP01)

             OVRPRTF    FILE(QPRINT) OVRFLW(52) OUTQ(ASJOUTQ) +
                          FORMTYPE(K6H1)

             CALL       PGM(GDGR20) PARM(&USER)
        /*   CALL       PGM(GDKR03)  */
             DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(&WLIB/GIGWP52)

 END:        ENDPGM
