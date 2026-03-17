             PGM
             /** AANC10 **************************************/
             /* PUBLICATION OF WORK IN PROCESS KANBAN(DAILY) */
             /*   I-HASADA                     97.05.02      */
             /*-----------------------------------           */
             /* TCHK1 08/24/06 ADD WORK FILE                 */
             /* JW1   2023.05.16 ADD EXCUSIVE CONTROL        */
             /************************************************/

             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)

             DCL        VAR(&MBAN)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTN1)  TYPE(*CHAR) LEN(1)

/* JW1 CHECK OTHER USER IS USING  ==================================*/
             CALL CHKC45 ('AANC10' 'AANC10' 'Y'  'CHK' &RTN1)
             IF         COND(&RTN1 *NE ' ') THEN(GOTO EXIT)
/* =================================================================*/

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

  /***JW1    CHKOBJ     OBJ(AANC10ACT) OBJTYPE(*DTAARA)                ***/
  /***       MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STP1))         ***/
  /***                                                                 ***/
  /***   STP2:                                                         ***/
  /***       SNDPGMMSG  MSG('( G ) THIS PROCESSING IS BEING +          ***/
  /***                    PROCESSED WITH OTHER COMPUTERS.(AANC10)') +  ***/
  /***                    TOMSGQ(&WSID) MSGTYPE(*INQ) KEYVAR(&MBAN)    ***/
  /***       RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +       ***/
  /***                    MSG(&KOTE)                                   ***/
  /***       IF         COND((&KOTE *NE 'G') *AND (&KOTE *NE 'g')) +   ***/
  /***                    THEN(GOTO CMDLBL(STP2))                      ***/
  /***       GOTO       EXIT                                           ***/
  /***                                                                 ***/
  /***       STP1:                                                     ***/
  /***       CRTDTAARA  DTAARA(AANC10ACT) TYPE(*CHAR) LEN(1) AUT(*ALL) ***/

/*TCHK1 */   CLRPFM     FILE(&WLIB/AANWP11)

             DLTF       FILE(AANWP10)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AANWP10) RCDLEN(512) +
                          OPTION(*NOLIST) SIZE(2000 1000 2) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(OUTPUT1) TOFILE(AANWP10)
             CALL       PGM(AANR10) PARM(&USER)
             DLTOVR *ALL

     /****JW DLTDTAARA  DTAARA(AANC10ACT)  **********/

/* JW1 CHECK OTHER USER IS USING  ==================================*/
             CALL CHKC45 ('AANC10' 'AANC10' 'N'  '' '')
/*==================================================================*/

 EXIT:
             ENDPGM
