             PGM
             /** ABDC05 *************************************/
             /*  REFLECT IT TO A-PICS KANBAN   */
             /* A-PICS1                                   */
             /*          KOHHY.           90.12.03          */
             /************************************* ABDC05 **/
             DCLF       FILE(ABDPW05)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             CHGJOB     SWS(00000000)
             RTVJOBA    JOB(&WSID)

 STEP01:     SNDRCVF    DEV(&WSID) RCDFMT(ABDPW051)
             IF         (&IN01 *EQ '1') GOTO END
             IF         (&IN02 *EQ '1') GOTO END
             IF         (&IN05 *EQ '0') GOTO STEP01

             CALL       PGM(ABDR05)

 STEP02:     SNDPGMMSG  MSG('( G.C ) SETTING NUMBER AUTOMATIC +
                          HANDLING A-PICS1 ACCUMMULATION DATA +
                          (AU#PP51) PUT CACKUP TAPE ON') +
                          TOMSGQ(QSYS/QSYSOPR) MSGTYPE(*INQ) +
                          KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *EQ 'G') *OR (&KOTAE *EQ 'g')) +
                          THEN(GOTO CMDLBL(STEP03))
             IF         COND((&KOTAE *EQ 'C') *OR (&KOTAE *EQ 'c')) +
                          THEN(GOTO CMDLBL(END))
             GOTO       STEP02

 STEP03:     INZTAP     DEV(TAP01) NEWVOL(AOYAMA) CHECK(*NO) +
                          DENSITY(*ULTRIUM6)
             SAVOBJ     OBJ(AU#PP51) LIB(HFILE1) DEV(TAP01) +
                          OBJTYPE(*FILE) VOL(AOYAMA) +
                          ENDOPT(*UNLOAD) CLEAR(*ALL) PRECHK(*YES)
             CLRPFM     FILE(AU#PP51)

 STEP04:     SNDPGMMSG  MSG('( G ) TAKE OUT BACKUP TAPE.') +
                          TOMSGQ(QSYS/QSYSOPR) MSGTYPE(*INQ) +
                          KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *EQ 'G') *OR (&KOTAE *EQ 'g')) +
                          THEN(GOTO CMDLBL(END))
             GOTO STEP04

 END:        ENDPGM
