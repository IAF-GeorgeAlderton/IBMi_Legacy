             PGM
             /** AY020C ****************************/
             /* CONVERT DDS DATA TO CSV FILE       */
             /*    Y.MAEDA       2012.10.26        */
             /**************************************/
             DCLF       FILE(AYBPW20)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WUSR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WNUM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PSRCF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PMBRD) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE0) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SYS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(10) VALUE('HWFILE1')

       /*JW  DCL        VAR(&PARM1) TYPE(*CHAR) LEN(10) +               */
       /*                 VALUE('HSJWFILE')    ライブラリー           */
       /*    DCL        VAR(&PARM2) TYPE(*CHAR) LEN(10) /* +            */
       /*                 ファイル名                                  */
       /*    DCL        VAR(&PARM3) TYPE(*CHAR) LEN(8)                  */
       /*    DCL        VAR(&PARM4) TYPE(*CHAR) LEN(52) +               */
       /*                 VALUE('C:$AS400$DATA$DDSHEADER.CSV')          */
       /*                 ＰＣファイル保管先                          */
       /*    DCL        VAR(&PARM5) TYPE(*CHAR) LEN(2) VALUE('1') +     */
       /*                    ＰＣファイルタイプ                       */

             RTVNETA    SYSNAME(&SYS)
             RTVJOBA    JOB(&WS) USER(&WUSR) NBR(&WNUM)
             CHGVAR     VAR(&FILE0) VALUE('AY020W0' *CAT &WS)
             CHGVAR     VAR(&FILE1) VALUE('AY020W1' *CAT &WS)
             CHGVAR     VAR(&FILE2) VALUE('AY020W2' *CAT &WS)

 @STP1:      SNDRCVF    DEV(&WS) RCDFMT(AYBPW201)
             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(@END))
             CHGVAR     VAR(&IN11) VALUE('0')
             CHGVAR     VAR(&IN12) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&@DDS *EQ ' ') DO
             CHGVAR     VAR(&IN11) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('ENTER FILE NAME!')
             GOTO       CMDLBL(@STP1)
             ENDDO

             DLTF       FILE(&WLIB/&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE1) RCDLEN(2048) +
                          IGCDTA(*YES) OPTION(*NOLIST *NOSRC) +
                          SIZE(10000 3000 3) LVLCHK(*NO)
             DLTF       FILE(&WLIB/&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE2) RCDLEN(2048) +
                          IGCDTA(*YES) OPTION(*NOLIST *NOSRC) +
                          SIZE(10000 3000 3) LVLCHK(*NO)

             IF         COND(&@LIB *EQ ' ') THEN(DO)
             DSPOBJD    OBJ(*LIBL/&@DDS) OBJTYPE(*FILE) +
                          OUTPUT(*OUTFILE) OUTFILE(&WLIB/&FILE0)
             MONMSG     MSGID(CPF2105) EXEC(DO)
             CHGVAR     VAR(&IN12) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG)  VALUE('ENTER LIBRARY!')

             GOTO       CMDLBL(@STP1)
             ENDDO
             ENDDO
             ELSE DO
             DSPOBJD    OBJ(&@LIB/&@DDS) OBJTYPE(*FILE) +
                          OUTPUT(*OUTFILE) OUTFILE(&WLIB/&FILE0)
             MONMSG     MSGID(CPF2105) EXEC(DO)
             CHGVAR     VAR(&IN11) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) +
                          VALUE('LIBRARY/FILE NOT FOUND!')
             GOTO       CMDLBL(@STP1)
             ENDDO
             MONMSG     MSGID(CPF2110) EXEC(DO)
             CHGVAR     VAR(&IN12) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) +
                          VALUE('LIBRARY NOT FOUND!')
             GOTO       CMDLBL(@STP1)
             ENDDO
             ENDDO

             IF         COND(&IN05 *EQ '0') THEN(DO)
             GOTO       CMDLBL(@STP1)
             ENDDO

             OVRDBF     FILE(FAY020W0) TOFILE(&FILE0)
             CALL       PGM(AYBR20) PARM(&PLIBL &PSRCF &PMBRD)
             DLTOVR     FILE(*ALL)

     /*JW    PRTSRCMBR  MBR(&PMBRD) SRCFILE(&PLIBL/&PSRCF)   */


             CPYSPLF    FILE(PRTSRCMBR) TOFILE(&WLIB/&FILE1) +
                          JOB(&WNUM/&WUSR/&WS) SPLNBR(*LAST)
             DLTSPLF    FILE(PRTSRCMBR) SPLNBR(*LAST)

             OVRDBF     FILE(AY020W1) TOFILE(&FILE1)
             OVRDBF     FILE(AY020W2) TOFILE(&FILE2)
             CALL       PGM(AYBR21)
             DLTOVR     FILE(*ALL)

          /* CHGVAR     VAR(&PARM2) VALUE(&FILE2)                       */
          /* CHGVAR     VAR(&PARM3) VALUE(&SYS)                         */
          /* CALL       PGM(AA900C) PARM(&PARM1 &PARM2 &PARM3 &PARM4 +  */
          /*              &PARM5)                                       */

 @END:       ENDPGM
