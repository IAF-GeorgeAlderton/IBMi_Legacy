             PGM
             /** IBKC90 ************************/
             /*  ..DIE M/F ( AOYAMA-->IAF )..  */
             /*    I-HASADA       97.07.12     */
             /************************ IBKC90 **/
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)

 STP11:      SNDPGMMSG  MSG('( G.C ) THE FIRST SET BACKUP TAPE') +
                          TOMSGQ(QSYSOPR) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *EQ 'G') *OR (&KOTAE *EQ 'g')) +
                          THEN(GOTO CMDLBL(STP12))
             IF         COND((&KOTAE *EQ 'C') *OR (&KOTAE *EQ 'c')) +
                          THEN(GOTO CMDLBL(END))
             GOTO       STP11

 STP12:      DLTF       FILE(FCQWP11)
             MONMSG     MSGID(CPF3261 CPF2105)

             DLTF       FILE(FCQWP21)
             MONMSG     MSGID(CPF3261 CPF2105)

             DLTF       FILE(FCQWP31)
             MONMSG     MSGID(CPF3261 CPF2105)

             DLTF       FILE(GCQWP31)
             MONMSG     MSGID(CPF3261 CPF2105)

             RSTOBJ     OBJ(FCQWP11 FCQWP21 FCQWP31 GCQWP31) +
                          SAVLIB(IAFTRN) DEV(TAP01) ENDOPT(*UNLOAD) +
                          MBROPT(*ALL) RSTLIB(HWFILE1)

             CALL       PGM(IBKR01)
             DLTF       FILE(FCQWP11)

             CALL       PGM(IBKR02)
             DLTF       FILE(FCQWP21)

             CALL       PGM(IBKR03)
             DLTF       FILE(GCQWP31)

             CALL       PGM(IBKR04)
             DLTF       FILE(FCQWP31)

 END:        ENDPGM
