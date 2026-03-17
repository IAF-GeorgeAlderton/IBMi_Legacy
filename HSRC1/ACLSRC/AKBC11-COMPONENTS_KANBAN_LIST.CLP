             PGM
             /** AKBC11 **********************************/
             /*      COMPONENTS KANBAN LIST              */
             /* CREATE DATE. : 2000.06.23                */
             /* AUTHOR.      : MSK.KUNIEDA               */
             /********************************** AKBC11 **/
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)  VALUE(' ')
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)  VALUE(' ')
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&WS)    TYPE(*CHAR) LEN(2)
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE3) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE4) TYPE(*CHAR) LEN(9)
             DCL        VAR(&REC1) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&REC2) TYPE(*DEC) LEN(10 0)
             DCLF       FILE(AKBPW11)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGJOB     SWS(00000000)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
        /* */
 SETP1:      SNDRCVF    DEV(&WSID) RCDFMT(AKBPW111)
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
             CHGVAR     VAR(&FILE1) VALUE('AKBWP11A' *CAT &WS)
             CHGVAR     VAR(&FILE2) VALUE('AKBWP11B' *CAT &WS)
             CHGVAR     VAR(&FILE3) VALUE('AKBWP12' *CAT &WS)
             CHGVAR     VAR(&FILE4) VALUE('AKBWP13' *CAT &WS)

             IF (&@NUBR  *EQ '2')  GOTO RETRY

             /* DATA OUTPUT                                */
             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTPF      FILE(HWFILE1/&FILE1) RCDLEN(100) +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX) +
                          LVLCHK(*NO)

             DLTF       FILE(&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTPF      FILE(HWFILE1/&FILE2) RCDLEN(100) +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX) +
                          LVLCHK(*NO)

             OVRDBF     FILE(AKBWP11A) TOFILE(&FILE1)
             OVRDBF     FILE(AKBWP11B) TOFILE(&FILE2)
             CALL       PGM(AKBR11) PARM(&USER)

   RETRY:    RTVMBRD    FILE(HWFILE1/&FILE1) NBRCURRCD(&REC1)
             MONMSG     MSGID(CPF9812) EXEC(GOTO CMDLBL(END))

             IF  (&REC1  *NE 0)  DO
             CLRPFM AKBWP01
             CPYF       FROMFILE(&FILE1) TOFILE(AKBWP01) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)
             ENDDO

         /*-----------------------------*/
         /* COMPONENTS KANBAN LIST      */
         /*-----------------------------*/

       /*    DLTF       FILE(&FILE3)        */
       /*    MONMSG     MSGID(CPF3261 CPF2105)    */

      /*     CRTPF      FILE(HWFILE1/&FILE3) RCDLEN(100) +
                          IGCDTA(*YES) OPTION(*NOLIST) SIZE(*NOMAX) +
                          LVLCHK(*NO)     */

      /*     FMTDTA     INFILE((&FILE1)) OUTFILE(&FILE3) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AKBS12) +
                          OPTION(*NOPRT)   */

      /*   OVRPRTF    FILE(AKBPR12) DEVTYPE(*AFPDS) PAGESIZE(65 +
                        132) LPI(6) OVRFLW(65) RPLUNPRT(*YES '*') +
                        OUTQ(QPRINTB) FORMTYPE(D986)      */

     /*      OVRPRTF    FILE(AKBPR12) DEVTYPE(*AFPDS) PAGESIZE(64 +
                          132) LPI(6) OVRFLW(64) RPLUNPRT(*YES '*') +
                          OUTQ(QPRINTB) FORMTYPE(D986)   */

     /*      OVRDBF     FILE(AKBWP12) TOFILE(&FILE3)  */

    /*       CALL       PGM(AKBR12)    */

         /*-----------------------------*/
         /* KANBAN NUMBER ADJUST        */
         /*-----------------------------*/

/* NEXT:     RTVMBRD    FILE(HWFILE1/&FILE2) NBRCURRCD(&REC2) */

      /*     IF  (&REC2  *EQ 0)  DO    */
       /*        GOTO   END  */
     /*      ENDDO    */

      /*     DLTF       FILE(&FILE4)   */
    /*       MONMSG     MSGID(CPF3261 CPF2105)  */

        /*   CRTPF      FILE(HWFILE1/&FILE4) RCDLEN(100) +
                          IGCDTA(*YES) OPTION(*NOLIST) SIZE(*NOMAX) +
                          LVLCHK(*NO)    */

     /*      FMTDTA     INFILE((&FILE2)) OUTFILE(&FILE4) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AKBS13) +
                          OPTION(*NOPRT)     */

    /*    OVRPRTF   FILE(AKBPR13) DEVTYPE(*AFPDS) PAGESIZE(66 +
                         132) LPI(6) OVRFLW(62) RPLUNPRT(*YES '*') +
                         OUTQ(QPRINTB) FORMTYPE(K6H1)  */

        /*   OVRDBF     FILE(AKBWP13) TOFILE(&FILE4)   */

        /*   CALL       PGM(AKBR13)                    */

 END:        DLTOVR     FILE(*ALL)

             ENDPGM
