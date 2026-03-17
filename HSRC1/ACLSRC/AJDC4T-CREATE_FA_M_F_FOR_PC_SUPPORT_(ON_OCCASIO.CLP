             PGM
             /** AJDC4T **********************************************/
             /* CREATE FA M/F FOR PC SUPPORT (ON OCCASION) ALL DATA  */
             /*      CREATE DATE  :  SEP/24/1997.                    */
             /*      AUTHOR.      :  S.OHTAKE.                       */
             /*                                                      */
             /* TCHK1  01/11/07 ADD OQ MASTER CREATE PROCESS         */
             /* TCHK2  06/18/08 ADD GM MASTER CREATE PROCESS         */
             /* TCHK3  01/07/10 ADD DSM MASTER CREATE PROCESS        */
             /* TCHK4  07/23/10 ADD MAC DERMID MASTER CREATE PROCESS */
             /* TCHK5  03/24/11 ADD ALL DATA(AJHC4T)                 */
             /* SAKAKI 12/19/19 ADD SB-KRO MASTER CREATE PROCESS     */
             /********************************************** AJDC4T **/
             DCLF       FILE(AJDPW40)
             DCL        VAR(&US)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&MBAN)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&ANS)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&KOTAE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&TVMENT) TYPE(*CHAR) LEN(1)
/*  JOB TYPE 0 = BATCH, 1 = INTERACTIVE                                    */
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSGQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID) USER(&US) TYPE(&JOBTYPE)

             CALL       PGM(ALBC01) PARM(&US &PLIB &WLIB)

             CHGJOB     OUTQ(QGPL/FAOUTQ) RUNPTY(40)

             /* DATA AREA CHECK */
             CHKOBJ     OBJ(&PLIB/FAMASMAK) OBJTYPE(*DTAARA) AUT(*ALL)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STP2))

             CHGVAR     VAR(&MSGQ) VALUE(&WSID)
             IF         COND(&JOBTYPE *EQ '0') THEN(DO)
             CHGVAR     VAR(&MSGQ) VALUE('QSYSOPR')
             GOTO       CMDLBL(STP4)
             ENDDO

 STP1:       SNDPGMMSG  MSG('( G ) IT IS USING AT ANOTHER TV. PLEASE +
                          WAIT FOR A WHILE.') TOMSGQ(&MSGQ) +
                          MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                        MSG(&ANS)

             IF         COND((&ANS *NE 'G') *AND (&ANS *NE 'g')) +
                          THEN(GOTO CMDLBL(STP1))
             GOTO       CMDLBL(END)

 STP2:       CRTDTAARA  DTAARA(&PLIB/FAMASMAK) TYPE(*CHAR) LEN(1) +
                          VALUE('*') AUT(*ALL)

             IF         COND(&JOBTYPE *EQ '0') THEN(DO)
             GOTO       CMDLBL(STP4)
             ENDDO

             /*DISPLAY  SCREEN */
 STP3:       SNDRCVF  DEV(&WSID) RCDFMT(AJDPW401)
             IF         (&IN01 *EQ '1') DO
             DLTDTAARA  DTAARA(&PLIB/FAMASMAK)
             GOTO       CMDLBL(END)
             ENDDO

             IF         (&IN05 *EQ '0') DO
             GOTO       CMDLBL(STP3)
             ENDDO
             /* FA M/F COPY  TO A DISK */
 STP4:
             CLRPFM     FILE(&PLIB/AJSPPBK)
             CPYF       FROMFILE(&PLIB/AJSPP01) +
                          TOFILE(&PLIB/AJSPPBK) MBROPT(*REPLACE) +
                          FMTOPT(*MAP *DROP)
             MONMSG     MSGID(CPF2817)

             /* WORK FILE DELETE */
 STEP4:      DLTF       FILE(&WLIB/AJSWP40)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(&WLIB/AJSWP41)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(&WLIB/AJSWP42)
             MONMSG     MSGID(CPF3261 CPF2105)

             /*CREATE WORK FILE */

             CRTPF      FILE(&WLIB/AJSWP40) RCDLEN(229) TEXT('WORK +
                          FROM FA M/F PLATING KANBAN') +
                          OPTION(*NOLIST) SIZE(10000 3000) +
                          LVLCHK(*NO) AUT(*ALL)
             GRTOBJAUT  OBJ(AJSWP40) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)

             CRTPF      FILE(&WLIB/AJSWP41) RCDLEN(256) TEXT('WORK +
                          FROM FA M/F A-PICS2 KANBAN') +
                          OPTION(*NOLIST) SIZE(10000 3000) +
                          LVLCHK(*NO) AUT(*ALL)
             GRTOBJAUT  OBJ(AJSWP41) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)

             CRTPF      FILE(&WLIB/AJSWP42) RCDLEN(14) TEXT('FA +
                          M/F CHANGE DISKETT WORK') OPTION(*NOLIST) +
                          SIZE(10000 3000) LVLCHK(*NO) AUT(*ALL)
             GRTOBJAUT  OBJ(AJSWP42) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)

          /************************************/
          /* AAFTL06  ->  AJSWP40             */
          /* CADTL04  ->  AJSWP41             */
          /************************************/
             CALL AJSR40

             /* FA M/F UPDATE  */
          /************************************/
          /* AJSWP40,41 -> AJSWP42            */
          /*            -> AJSPL01  UPD,WRT   */
          /************************************/
             CALL AJDR4T


             /*DELETE DATA MAKING OF FA M/F */
             /* PLATING, INSTRUCTION, */
          /************************************/
          /* AJSPL01 -> AJSWP42               */
          /* AAFTL06                          */
          /* CADTL04                          */
          /************************************/
             CALL AJSR44

          /************************************/
          /* DELETE AJSPP01                   */
          /* AJSWP42 <-> AJSPL01              */
          /************************************/
             CALL       PGM(AJSR43)

             DLTDTAARA  DTAARA(&PLIB/FAMASMAK)

             /********************************************/
             /*  FA M/F ALL DATA                         */
             /*    CREATE DATE SEP/24/1997    S.OHTAKE   */
             /********************************************/
             DLTF FILE(&WLIB/AJSWP15)
             MONMSG MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AJSWP15) RCDLEN(512) TEXT('FOR +
                          FA M/F PERSONAL COMPUTER DKT OUTPUT') +
                          OPTION(*NOLIST) SIZE(4000 500) +
                          LVLCHK(*NO) AUT(*ALL)
             GRTOBJAUT  OBJ(AJSWP15) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)

             DLTF       FILE(&WLIB/AJSWP17)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AJSWP17) RCDLEN(145) +
                          TEXT('DACRODIZING M/F DKT OUTPUT') +
                          OPTION(*NOLIST) SIZE(4000 500) +
                          LVLCHK(*NO) AUT(*ALL)
             GRTOBJAUT  OBJ(AJSWP17) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)

             DLTF       FILE(&WLIB/AJSWP19)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AJSWP19) RCDLEN(512) +
                          TEXT('GEOMET M/F DKT OUTPUT') +
                          OPTION(*NOLIST) SIZE(4000 500) +
                          LVLCHK(*NO) AUT(*ALL)
             GRTOBJAUT  OBJ(AJSWP19) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)

             DLTF       FILE(&WLIB/AJSWP13)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AJSWP13) RCDLEN(512) +
                          TEXT('DSM M/F DKT OUTPUT') +
                          OPTION(*NOLIST) SIZE(4000 500) +
                          LVLCHK(*NO) AUT(*ALL)
             GRTOBJAUT  OBJ(AJSWP13) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)

             DLTF       FILE(&WLIB/AJSWP11)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AJSWP11) RCDLEN(145) +
                          TEXT('MAC DERMID M/F DKT OUTPUT') +
                          OPTION(*NOLIST) SIZE(4000 500) +
                          LVLCHK(*NO) AUT(*ALL)
             GRTOBJAUT  OBJ(AJSWP11) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)

             CHGVAR VAR(&TVMENT) VALUE('2')
          /************************************/
          /* AJSPL01  -> AJSWP15 BZ           */
          /*          -> AJSWP17 DACRO        */
          /*          -> AJSWP19 GEOMET       */
          /*          -> AJSWP13 DSM          */
          /*          -> AJSWP11 MAC DERMID   */
          /************************************/
             CALL       PGM(AJSR15) PARM(&TVMENT)

     /**     CALL       PGM(AJSR17) PARM(&TVMENT)  **/
     /**     CALL       PGM(AJSR19) PARM(&TVMENT)  **/
     /**     CALL       PGM(AJSR13) PARM(&TVMENT) **/
     /**     CALL       PGM(AJSR11) PARM(&TVMENT) **/

          /***************************/
          /* OQ MASTER CREATE PROCESS */
          /***************************/
             DLTF       FILE(&WLIB/ADHWP20)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/ADHWP20) RCDLEN(128) +
                          OPTION(*NOLIST) SIZE(10000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)
             CALL       PGM(ADHR20)

          /***************************/
          /* SECOND TREATMENT MASTER */
          /***************************/
             CALL       PGM(AJHC4T)

          /**************************/
          /* COMBINE PARTIAL MASTER */
          /**************************/
             CALL       PGM(AJZC01)

          /**************************/
          /* MATERIAL MASTER (HD)   */
          /**************************/
             CALL       PGM(AJXC01)

          /**************************/
          /* UNIT WEGHIT            */
          /**************************/
             CALL       PGM(AJJC01)

          /**************************/
          /* SB-KRO MASTER          */
          /**************************/
             CALL       PGM(ASBC01)

 END:        CHGJOB     RUNPTY(20)

             ENDPGM
