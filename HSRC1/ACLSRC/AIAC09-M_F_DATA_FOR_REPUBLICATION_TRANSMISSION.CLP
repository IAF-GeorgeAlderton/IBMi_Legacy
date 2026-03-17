             PGM
             /** AIAC09 ***************************************/
             /*  M/F DATA FOR REPUBLICATION TRANSMISSION      */
             /*  I-HASADA                  86.11.21           */
             /* ------------------------------------          */
             /*  JW1       2023.06.30 ADD EXCLUSIVE CONTROL   */
             /*************************************************/
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RPY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&BMON) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ANS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)

 /*JW1*/     DCL        VAR(&RTN1)  TYPE(*CHAR) LEN(1)

/* JW2 CHECK OTHER USER IS USING  ==================================*/
             CALL CHKC45 ('AIAC09' 'AIAC09' 'Y'  'CHK' &RTN1)
             IF         COND(&RTN1 *NE ' ') THEN(GOTO ENDAT)
/* =================================================================*/

             RTVJOBA    JOB(&WSNO) USER(&USER)
             CHGJOB     RUNPTY(40)

             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

 /**JW1      CHKOBJ     OBJ(&PLIB/AIAACTA) OBJTYPE(*DTAARA) AUT(*ALL)    **/
 /**         MONMSG     MSGID(CPF9801 CPF1023) EXEC(GOTO CMDLBL(CRT01))  **/
 /**                                                                     **/
 /** CRT02:  SNDPGMMSG  MSG('( G ) M/F IS REMAKING RIGHT +               **/
 /**                      NOW.(AIAC09)') TOMSGQ(&WSNO) +                 **/
 /**                      MSGTYPE(*INQ) KEYVAR(&MBAN)                    **/
 /**                                                                     **/
 /**         RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +         **/
 /**                      MSG(&ANS)                                      **/
 /**         IF         COND(&ANS *NE 'G') THEN(GOTO CMDLBL(CRT02))      **/
 /**         RETURN                                                      **/
 /**                                                                     **/
 /**         GOTO       CMDLBL(ENDAT)                                    **/

 CRT01:  /** CRTDTAARA  DTAARA(&PLIB/AIAACTA) TYPE(*CHAR) LEN(1) +  **/
         /**              VALUE('*') TEXT('M/F IS REMAKING RIGHT +  **/
         /**              NOW CHECK IT') AUT(*ALL)                  **/

             CALL       PGM(AIAR08) PARM('A')
             CHGJOB     RUNPTY(20)

         /** DLTDTAARA  DTAARA(AIAACTA)                             **/
             CALL CHKC45 ('AIAC09' 'AIAC09' 'N'  '' '')

 ENDAT:      ENDPGM
