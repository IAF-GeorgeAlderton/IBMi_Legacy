             PGM        PARM(&PBMON &PDATE &PBIN)
             /** CAAC17 ******************************/
             /* INSTRUCTION KANBAN DATA CREATE        */
             /*  ..Ａ－ＰＩＣＳⅡ                  */
             /*      T-SAKAKI          2020.08.18    */
             /****************************** CAAC17 **/
             DCL        VAR(&PBMON) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PDATE) TYPE(*DEC) LEN(8 0)
             DCL        VAR(&PBIN) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RPY) TYPE(*CHAR) LEN(1)

             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FL0111) TYPE(*CHAR) LEN(9)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0) VALUE(0)
             DCL        VAR(&PMSG)  TYPE(*CHAR) LEN(256)

             RTVJOBA    JOB(&WSID) USER(&USER)

           /*---------------------------*/
           /* CHECK LIBRARY             */
           /*---------------------------*/
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

           /*---------------------------*/
           /* CREATE WORK FILE          */
           /*---------------------------*/
             DLTF       FILE(&WLIB/CAAWP1E)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/CAAWP1E) RCDLEN(90) +
                          OPTION(*NOLIST *NOSRC) SIZE(100 10 3) +
                          LVLCHK(*NO) AUT(*ALL)

             CHGVAR     VAR(&FL0111) VALUE('CAA0111' *TCAT &PBIN)
             CHKOBJ     OBJ(&FL0111) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(&WLIB/&FL0111) RCDLEN(3072) +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX) +
                          AUT(*ALL))
             CLRPFM     FILE(&FL0111)
 @STP1:
           /*--------------------------------------*/
           /*  ..指示かんばん発行データ抜出し..  */
           /*  ..各工場・便                      */
           /*  CAAPP05 -> CAA011101 OR CAA011102   */
           /*          -> CAA011177 RE-PRINT       */
           /*          -> CAA011188 OFF-LINE       */
           /*   CAAPP05 IS CREATED BY CAAR05 <- CAACJ1 */
           /*--------------------------------------*/
 @STP2:      OVRDBF     FILE(CAAWP17) TOFILE(&FL0111)
             CALL       PGM(CAAR17) PARM(&PBMON &PDATE &PBIN)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDUSRMSG  MSG('AN ERROR OCCURRED IN THE PROGRAM +
                          (CAAR17) ....< RETRY -> R  CANCEL -> C +
                          >') VALUES('R' 'C') MSGTYPE(*INQ) +
                          TOMSGQ(&WSID) MSGRPY(&RPY)
             IF         COND(&RPY *EQ 'R' *OR &RPY *EQ 'r') +
                          THEN(GOTO CMDLBL(@STP2))
             GOTO CMDLBL(@END)
             ENDDO

           /*------------------------------*/
           /* ERROR NOTIFICATION           */
           /*------------------------------*/
             RTVMBRD    FILE(&WLIB/CAAWP1E) NBRCURRCD(&REC)
             IF         COND(&REC *GT 0) THEN(DO)
             CRTFLR     FLR(MAIL)
             MONMSG     MSGID(CPF8A18)

             CPYTOPCD   FROMFILE(CAAWP1E) TOFLR(MAIL) +
                          TODOC(CAAWP1E.CSV) REPLACE(*YES)

             SNDDST     TYPE(*DOC) +
                          TOINTNET(('SAKAKI.TAKASHI@AOYAMAGRP.COM')+
                          ) DSTD('DSTS') MSG('A-PICS2/3 ERROR +
                          LIST  * YOU NEED TO FIX MASTER, THEN YOU +
                          CAN PRINT BY DAILY OPERATION AGAIN.') +
                          DOC(CAAWP1E.CSV) FLR('MAIL')
             MONMSG     MSGID(CPF0000)

             CHGVAR     VAR(&PMSG) VALUE('ERROR LIST IS SENT TO PC. +
                          PLEASE CHECK THE CONTENTS.')
             CALL       PGM(QUILNGTX) PARM(&PMSG X'00000046' '       +
                          ' '                    ' X'00000000')
             ENDDO

           /*------------------------------*/
           /* CHECK # OF RECORD            */
           /*------------------------------*/
             RTVMBRD    FILE(&WLIB/&FL0111) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(DO)

             CHGVAR     VAR(&PMSG) VALUE('NO ISSUE DATA.')
             CALL       PGM(QUILNGTX) PARM(&PMSG X'00000046' '       +
                          ' '                    ' X'00000000')

             ENDDO

           /*------------------------------*/
           /* WRITE CA#PP01  ACCUMULATION  */
           /*------------------------------*/
 @STP3:      IF         COND(&PBIN *NE '77') THEN(DO)
             CALL       PGM(CAAR19)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDUSRMSG  MSG('AN ERROR OCCURRED IN THE PROGRAM +
                          (CAAR19) .... <  RETRY -> R  CANCEL -> C  +
                          >') VALUES('R' 'C') MSGTYPE(*INQ) +
                          TOMSGQ(&WSID) MSGRPY(&RPY)
             IF         COND(&RPY *EQ 'R' *OR &RPY *EQ 'r') +
                          THEN(GOTO CMDLBL(@STP3))
             GOTO CMDLBL(@END)
             ENDDO

             ENDDO
           /*------------------------------*/
           /* ASCII DATA CREATION          */
           /*------------------------------*/
 @STP4:      DLTOVR     FILE(*ALL)
             CALL       PGM(CAAC18) PARM(&PBMON &PDATE &PBIN)

 @END:       ENDPGM
