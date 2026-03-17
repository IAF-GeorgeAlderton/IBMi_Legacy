             PGM        PARM(&PSTS &SERV_IP &AS_SEND)
             /** AIAC55 **************************************/
             /*..送信データＦＴＰ送信処理(AS400ｰ>APICS)    */
             /*      A-INOUE       2004.08.09                */
             /************************************** AIAC52 **/

             DCL        VAR(&PSTS) TYPE(*CHAR) LEN(1) /* STATUS */
             DCL        VAR(&AS_SEND) TYPE(*CHAR) LEN(10) /*AS->PC*/
             DCL        VAR(&SERV_IP) TYPE(*CHAR) LEN(15) /*SERVER IP*/

             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)

/*ＩＮＺ*/
             CHGVAR     VAR(&PSTS) VALUE(' ')

             MONMSG     MSGID(CPF0000 CPA0000 CPD0000 MCH0000)

             CHGJOB     OUTQ(QTCPIP)
/*属性データの送信*/
             CHKOBJ     OBJ(HWFILE1/AIAWPLG) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTPF      FILE(HWFILE1/AIAWPLG) RCDLEN(266) +
                          IGCDTA(*YES) TEXT('APICS FTP LOG') +
                          MAXMBRS(*NOMAX) SIZE(1000 300)
             ENDDO
             ADDPFM     FILE(AIAWPLG) MBR(&AS_SEND) +
                          TEXT('APICS FTP LOG ' *CAT &AS_SEND)
             MONMSG     MSGID(CPF5812 CPF7306)

             CLRPFM     FILE(HWFILE1/AIAWPLG) MBR(&AS_SEND)

             OVRDBF     FILE(INPUT) TOFILE(HSRC1/FMTSRC) MBR(&AS_SEND)
             OVRDBF     FILE(OUTPUT) TOFILE(HWFILE1/AIAWPLG) +
                          MBR(&AS_SEND)
             STRTCPFTP  RMTSYS(*INTNETADR) INTNETADR(&SERV_IP)
             DLTOVR     FILE(INPUT)
             CALL       PGM(AIAR55)
             DLTOVR     FILE(OUTPUT)
             RTVJOBA    SWS(&SWS)    /* 1桁目  OK=1  NG=0 */

             IF         COND(%SST(&SWS 1 1) = '0') THEN(GOTO +
                          CMDLBL(ERR))

             GOTO       CMDLBL(END)

             /**  ERR時の処理 **/
 ERR:        CHGVAR     VAR(&PSTS) VALUE('E')

 END:        ENDPGM
