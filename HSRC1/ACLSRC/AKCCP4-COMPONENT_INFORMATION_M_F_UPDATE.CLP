             PGM
             /** AKCCP4 **********************************/
             /*  COMPONENT INFORMATION M/F UPDATE        */
             /*  AEBC70                                  */
             /*  COMPONENTS KANBAN SYSTEM FILE           */
             /*  DATA AND AMOUNT MAKING AGAIN            */
             /* TCH 02/03/05   INQUIRY                   */
             /*--------------------------------------    */
             /* JW1   2023.07.26 ADD EXCLUCIVE CONTROL   */
             /********************************************/

             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE)   TYPE(*CHAR) LEN(1)
 /*JW1*/     DCL        VAR(&RTN1)   TYPE(*CHAR) LEN(1)

/* JW1 CHECK OTHER USER IS USING  ==================================*/
             CALL CHKC45 ('AKCACT' 'AKCCP4' 'Y'  'CHK' &RTN1)
             IF         COND(&RTN1 *NE ' ') THEN(GOTO ENDP)
/* =================================================================*/

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

 /**JW1      CHKOBJ     OBJ(HOBJ1/AKCACT) OBJTYPE(*DTAARA)             **/
 /**         MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STP1))         **/
 /**  STP2:  SNDPGMMSG  MSG('(G) PLEASE WAIT FOR A WHILE AND TRY +     **/
 /**                      AGAIN LATER. COMPONENTS PART M/F IS IN +     **/
 /**                      USE NOW. (AKCCP4).') TOMSGQ(&WSID) +         **/
 /**                      MSGTYPE(*INQ) KEYVAR(&MBAN)                  **/
 /**         RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +       **/
 /**                      MSG(&KOTE)                                   **/
 /**         IF         COND((&KOTE *NE 'G') *AND (&KOTE *NE 'g')) +   **/
 /**                      THEN(GOTO CMDLBL(STP2))                      **/
 /**         GOTO       END                                            **/
 /**                                                                   **/
 /**  STP1:  CRTDTAARA  DTAARA(HOBJ1/AKCACT) TYPE(*CHAR) LEN(10) +     **/
 /**                      TEXT('COMPONENTS P/N PLAN NOTICE +           **/
 /**                      PUBLICATION SYSTEM') AUT(*ALL)               **/

             CLRPFM     FILE(AKDWP01)
             CLRPFM     FILE(AKDWP02)
             CLRPFM     FILE(AKDTP02)

             STRCMTCTL  LCKLVL(*ALL) NFYOBJ(*NONE)
             CALL       PGM(AKCR04) PARM(&USER)
             ENDCMTCTL

             MONMSG     MSGID(CPF8356)
             DLTOVR     FILE(*ALL)

      /**JW1 DLTDTAARA  DTAARA(HOBJ1/AKCACT) **/

 /*JW1*/     CALL CHKC45 ('AKCACT' 'AKCCP4' 'N'  '' '')

 ENDP:       ENDPGM
