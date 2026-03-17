             PGM
             /** GCQC49 **********************************/
             /*      DIE  KANBAN LIST                    */
             /* CREATE DATE. : 98.09.30                  */
             /* AUTHOR.      : MSK.KUNIEDA               */
             /********************************** GCQC49 **/
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)  VALUE(' ')
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)  VALUE(' ')
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&WS)    TYPE(*CHAR) LEN(2)
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE2) TYPE(*CHAR) LEN(9)
             DCLF       FILE(GCQPW49)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGJOB     SWS(00000000)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
        /* */
 SETP1:      SNDRCVF    DEV(&WSID) RCDFMT(GCQPW491)
             CHGVAR     VAR(&IN99) VALUE('0')
             CHGVAR     VAR(&IN11) VALUE('0')
             CHGVAR     VAR(&@MSG) +
                          VALUE('                            ')
             IF (&IN01 *EQ '1')  GOTO END
             IF (&@NUBR  *EQ '1')  GOTO SETP2
             IF (&@NUBR  *EQ '2')  GOTO SETP2

             CHGVAR     VAR(&@MSG) VALUE('NUMBER INSTRUCTIN IS < 1 2 +
                          >')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&IN11) VALUE('1')
             GOTO SETP1
 SETP2:      IF (&IN05   *EQ '1')  GOTO SETP3
             GOTO SETP1

 SETP3:      CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 2))
             CHGVAR     VAR(&FILE1) VALUE('GCQWP49' *CAT &WS)
             CHGVAR     VAR(&FILE2) VALUE('GCQWP50' *CAT &WS)

             IF (&@NUBR  *EQ '2')  GOTO RETRY

             /* DATA OUTPUT                                */
             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTPF      FILE(HWFILE1/&FILE1) RCDLEN(60) +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX) +
                          LVLCHK(*NO)

             OVRDBF     FILE(GCQWP49) TOFILE(&FILE1)
             CALL       PGM(GCQR49) PARM(&USER)

             IF         COND(%SWITCH(00XXXXXX)) THEN(GOTO CMDLBL(END))

             DLTF       FILE(&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTPF      FILE(HWFILE1/&FILE2) RCDLEN(60) IGCDTA(*YES) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO)

             FMTDTA     INFILE((HWFILE1/&FILE1)) +
                          OUTFILE(HWFILE1/&FILE2) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(GCQS49) +
                          OPTION(*NOPRT)

 RETRY:      OVRPRTF    FILE(GCQPR50) DEVTYPE(*AFPDS) PAGESIZE(63 +
                          132) LPI(6) OVRFLW(63) RPLUNPRT(*YES '*') +
                          OUTQ(QPRINTD) FORMTYPE(D986)

             OVRDBF     FILE(GCQWP50) TOFILE(&FILE2)

             CALL       PGM(GCQR50)

 END:        DLTOVR     FILE(*ALL)

             ENDPGM
