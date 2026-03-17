             PGM        PARM(&PNO1 &PNO2 &JIKN &PNO3 &DATE)
             /** AJCC10 *****************************/
             /*  BACKUP AND POWER DOWN (WEEKLY JOB) */
             /*  ADD HOLD MSG -> QSECOFR            */
             /***************************** AJCC10 **/

             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PNO1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PNO2) TYPE(*CHAR) LEN(1)
             DCL        VAR(&JIKN) TYPE(*CHAR) LEN(6)
             DCL        VAR(&DATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&JDAT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PNO3) TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID)

             CHGMSGQ    MSGQ(QSYSOPR) DLVRY(*BREAK)

             /*-----------------*/
             /*  ..POWER OFF..  */
             /*-----------------*/
             IF         (&PNO1 *EQ '1') DO
             ENDSBS     SBS(*ALL) OPTION(*IMMED)
             PWRDWNSYS  OPTION(*CNTRLD) CONFIRM(*NO)
             ENDDO

             /*--------------------*/
             /*  ..USER LIBRARY..  */
             /*--------------------*/
             IF         (&PNO2 *EQ '1') DO

 STP11:      SNDPGMMSG  MSG('( G.C ) THE FIRST SET BACKUP TAPE FOR +
                          LIBRARY(*NONSYS) <SAVLIB>  (YES=G,NO=C)') +
                          TOMSGQ(&WSID) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *EQ 'G') *OR (&KOTAE *EQ '')) +
                          THEN(GOTO CMDLBL(STP12))
             IF         COND((&KOTAE *EQ 'C') *OR (&KOTAE *EQ '')) +
                          THEN(GOTO CMDLBL(END))
             GOTO       STP11

 STP12:

             CHGMSGQ    MSGQ(&WSID) DLVRY(*HOLD) SEV(00)
             MONMSG     MSGID(CPF0000)
             CHGMSGQ    MSGQ(QSYS/QSYSOPR) DLVRY(*HOLD) SEV(00)
             MONMSG     MSGID(CPF0000)
             CHGMSGQ    MSGQ(QUSRSYS/QSYSOPR) DLVRY(*HOLD) SEV(00)
             MONMSG     MSGID(CPF0000)

             CHGMSGQ    MSGQ(QUSRSYS/QSECOFR) DLVRY(*HOLD) SEV(00)
             MONMSG     MSGID(CPF0000)

             ENDSBS     SBS(QSVCDRCTR) OPTION(*IMMED)
             MONMSG     MSGID(CPF0000)

             CHGJOB     INQMSGRPY(*DFT)
             DLYJOB     DLY(120)


             IF         COND(&DATE *NE '      ') THEN(DO)
   LOOP:
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&JDAT)
             IF         COND(&JDAT *NE &DATE) THEN(DO)
             DLYJOB     DLY(60)
             DLYJOB     RSMTIME(003000)
             GOTO       CMDLBL(LOOP)
             ENDDO
             ENDDO

             IF         COND(&JIKN *NE '      ') THEN(DO)
             DLYJOB     RSMTIME(&JIKN)
             ENDDO

             INZTAP     DEV(TAP01) NEWVOL(IAF) CHECK(*NO) +
                          DENSITY(*ULTRIUM6)
             MONMSG     MSGID(CPF0000 CPA0000) EXEC(DO)
             STRSBS     SBSD(QSVCDRCTR)
             MONMSG     MSGID(CPF0000)
             GOTO       CMDLBL(SKP)
             ENDDO

             ENDSBS     SBS(*ALL) OPTION(*IMMED)
             MONMSG     MSGID(CPF0000)
             DLYJOB     DLY(300)
             MONMSG     MSGID(CPF0000)

             SAVLIB     LIB(*NONSYS) DEV(TAP01) VOL(IAF) +
                          ENDOPT(*UNLOAD) ACCPTH(*YES) DTACPR(*YES)
             MONMSG     MSGID(CPF0000 CPA0000) EXEC(DO)
             STRSBS     SBSD(QSVCDRCTR)
             MONMSG     MSGID(CPF0000)
             GOTO       CMDLBL(SKP)
             ENDDO

             CHGMSGQ    MSGQ(&WSID) DLVRY(*HOLD) SEV(00)
             MONMSG     MSGID(CPF0000)
             CHGMSGQ    MSGQ(QSYS/QSYSOPR) DLVRY(*HOLD) SEV(00)
             MONMSG     MSGID(CPF0000)
             CHGMSGQ    MSGQ(QUSRSYS/QSYSOPR) DLVRY(*HOLD) SEV(40)
             MONMSG     MSGID(CPF0000)

             IF         COND(&PNO3 *EQ 'Y') THEN(DO)
             ENDSBS     SBS(*ALL) OPTION(*IMMED)
             MONMSG     MSGID(CPF0000)
             PWRDWNSYS  OPTION(*CNTRLD) CONFIRM(*NO)
             ENDDO

             IF         COND(&PNO3 *EQ 'N') THEN(DO)
             PWRDWNSYS  OPTION(*CNTRLD) RESTART(*YES) CONFIRM(*NO)
             ENDDO
             ENDDO

             IF         COND((&PNO2 *EQ '2') *OR (&PNO2 *EQ '3') *OR +
                          (&PNO2 *EQ '4')) THEN(DO)

 STPA:       SNDPGMMSG  MSG('( G.C ) DO YOU BACKUP SYSTEM LIB?  +
                          <YES=G,NO=C> ') TOMSGQ(QSYSOPR) +
                          MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *EQ 'G') *OR (&KOTAE *EQ '')) +
                          THEN(GOTO CMDLBL(STPB))
             IF         COND((&KOTAE *EQ 'C') *OR (&KOTAE *EQ '')) +
                          THEN(GOTO CMDLBL(END))
             GOTO       STPA

             /*--------------------------------------------*/
             /* SYSTEM BACKUP ( SAVLIB )..                 */
             /* .. QGPL.QUSRSYS.*IBM                       */
             /* .. QDOCQDSNXQRECOVERYQRPLOBJQSPLQSRV       */
             /* .. QTEMP CAN'T SAVE BY  LIBRARY            */
             /*--------------------------------------------*/
 STPB:       IF         (&PNO2 *EQ '2') DO

 STP21:      SNDPGMMSG  MSG('( G.C ) QGPL.QUSRSYS.*IBM----- SET +
                          BACKUP TAPE <SAVLIB>  (YES=G,NO=C)') +
                          TOMSGQ(QSYSOPR) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *EQ 'G') *OR (&KOTAE *EQ '')) +
                          THEN(GOTO CMDLBL(STP22))
             IF         COND((&KOTAE *EQ 'C') *OR (&KOTAE *EQ '')) +
                          THEN(GOTO CMDLBL(END))
             GOTO       STP21

   STP22:
             CHGMSGQ    MSGQ(&WSID) DLVRY(*HOLD) SEV(00)
             MONMSG     MSGID(CPF0000)
             CHGMSGQ    MSGQ(QSYS/QSYSOPR) DLVRY(*HOLD) SEV(00)
             MONMSG     MSGID(CPF0000)
             CHGMSGQ    MSGQ(QUSRSYS/QSYSOPR) DLVRY(*HOLD) SEV(00)
             MONMSG     MSGID(CPF0000)

             CHGMSGQ    MSGQ(QUSRSYS/QSECOFR) DLVRY(*HOLD) SEV(00)
             MONMSG     MSGID(CPF0000)


             ENDSBS     SBS(QSVCDRCTR) OPTION(*IMMED)
             MONMSG     MSGID(CPF0000)

             DLYJOB     DLY(120)

             IF         COND(&DATE *NE '      ') THEN(DO)
   LOOP2:
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&JDAT)
             IF         COND(&JDAT *NE &DATE) THEN(DO)
             DLYJOB     DLY(60)
             DLYJOB     RSMTIME(003000)
             GOTO       CMDLBL(LOOP2)
             ENDDO
             ENDDO

             IF         COND(&JIKN *NE '      ') THEN(DO)
             DLYJOB     RSMTIME(&JIKN)
             ENDDO

             INZTAP     DEV(TAP01) NEWVOL(IAF) CHECK(*NO) +
                          DENSITY(*ULTRIUM6)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             STRSBS     SBSD(QSVCDRCTR)
             MONMSG     MSGID(CPF0000)
             GOTO       CMDLBL(END)
             ENDDO

             ENDSBS     SBS(*ALL) OPTION(*IMMED)
             MONMSG     MSGID(CPF0000)
             DLYJOB     DLY(300)
             MONMSG     MSGID(CPF0000)

             SAVLIB     LIB(QGPL QPFRDATA QS36F QUSRSYS) DEV(TAP01) +
                          VOL(IAF) ACCPTH(*YES)
             MONMSG     MSGID(CPF0000)
             SAVLIB     LIB(*IBM) DEV(TAP01) VOL(IAF) +
                          ENDOPT(*UNLOAD) ACCPTH(*YES)
             MONMSG     MSGID(CPF0000)

             IF         COND(&PNO3 *EQ 'Y') THEN(DO)
             ENDSBS     SBS(*ALL) OPTION(*IMMED)
             MONMSG     MSGID(CPF0000)
             PWRDWNSYS  OPTION(*CNTRLD) CONFIRM(*NO)
             ENDDO

             IF         COND(&PNO3 *EQ 'N') THEN(DO)
             PWRDWNSYS  OPTION(*CNTRLD) RESTART(*YES) CONFIRM(*NO)
             ENDDO

             ENDDO

             /*--------------------------------*/
             /*  ..DOCUMENTS LIBRARY BACKUP..  */
             /*  ..( SAVDLO )                  */
             /*--------------------------------*/
             IF         (&PNO2 *EQ '3') DO

 STP31:      SNDPGMMSG  MSG('( G.C ) SET BACKUP TAPE FOR DOCUMENTS +
                          LIB<SAVDLO>  (YES=G,NO=C)') +
                          TOMSGQ(QSYSOPR) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *EQ 'G') *OR (&KOTAE *EQ '')) +
                          THEN(GOTO CMDLBL(STP32))
             IF         COND((&KOTAE *EQ 'C') *OR (&KOTAE *EQ '')) +
                          THEN(GOTO CMDLBL(END))
             GOTO       STP31

STP32:
             CHGMSGQ    MSGQ(&WSID) DLVRY(*HOLD) SEV(00)
             MONMSG     MSGID(CPF0000)
             CHGMSGQ    MSGQ(QSYS/QSYSOPR) DLVRY(*HOLD) SEV(00)
             MONMSG     MSGID(CPF0000)
             CHGMSGQ    MSGQ(QUSRSYS/QSYSOPR) DLVRY(*HOLD) SEV(00)
             MONMSG     MSGID(CPF0000)

             CHGMSGQ    MSGQ(QUSRSYS/QSECOFR) DLVRY(*HOLD) SEV(00)
             MONMSG     MSGID(CPF0000)

             ENDSBS     SBS(QSVCDRCTR) OPTION(*IMMED)
             MONMSG     MSGID(CPF0000)

             IF         COND(&DATE *NE '      ') THEN(DO)
   LOOP3:
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&JDAT)
             IF         COND(&JDAT *NE &DATE) THEN(DO)
             DLYJOB     DLY(60)
             DLYJOB     RSMTIME(003000)
             GOTO       CMDLBL(LOOP3)
             ENDDO
             ENDDO

             IF         COND(&JIKN *NE '      ') THEN(DO)
             DLYJOB     RSMTIME(&JIKN)
             ENDDO

             INZTAP     DEV(TAP01) NEWVOL(IAF) CHECK(*NO) +
                          DENSITY(*ULTRIUM6)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             STRSBS     SBSD(QSVCDRCTR)
             MONMSG     MSGID(CPF0000)
             GOTO       CMDLBL(END)
             ENDDO

             ENDSBS     SBS(*ALL) OPTION(*IMMED)
             MONMSG     MSGID(CPF0000)
             DLYJOB     DLY(300)

             SAVDLO     DLO(*ALL) DEV(TAP01) VOL(IAF) ENDOPT(*UNLOAD)
             MONMSG     MSGID(CPF0000)

             IF         COND(&PNO3 *EQ 'Y') THEN(DO)
             ENDSBS     SBS(*ALL) OPTION(*IMMED)
             MONMSG     MSGID(CPF0000)
             PWRDWNSYS  OPTION(*CNTRLD) CONFIRM(*NO)
             ENDDO

             IF         COND(&PNO3 *EQ 'N') THEN(DO)
             PWRDWNSYS  OPTION(*CNTRLD) RESTART(*YES) CONFIRM(*NO)
             ENDDO

             ENDDO

             /*---------------------*/
             /*  ..SYSTEM BACKUP..  */
             /*  ..( SAVSYS )       */
             /*---------------------*/
             IF         (&PNO2 *EQ '4') DO

 STP41:      SNDPGMMSG  MSG('( G.C ) QSYS <SAVSYS> SET BACKUP TAPE  +
                          (YES=G,NO=C)') TOMSGQ(QSYSOPR) +
                          MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *EQ 'G') *OR (&KOTAE *EQ '')) +
                          THEN(GOTO CMDLBL(STP42))
             IF         COND((&KOTAE *EQ 'C') *OR (&KOTAE *EQ '')) +
                          THEN(GOTO CMDLBL(END))
             GOTO       STP41
 STP42:
             CHGMSGQ    MSGQ(&WSID) DLVRY(*HOLD) SEV(00)
             MONMSG     MSGID(CPF0000)
             CHGMSGQ    MSGQ(QSYS/QSYSOPR) DLVRY(*HOLD) SEV(00)
             MONMSG     MSGID(CPF0000)
             CHGMSGQ    MSGQ(QUSRSYS/QSYSOPR) DLVRY(*HOLD) SEV(00)
             MONMSG     MSGID(CPF0000)

             CHGMSGQ    MSGQ(QUSRSYS/QSECOFR) DLVRY(*HOLD) SEV(00)
             MONMSG     MSGID(CPF0000)

             ENDSBS     SBS(QSVCDRCTR) OPTION(*IMMED)
             MONMSG     MSGID(CPF0000)

             IF         COND(&DATE *NE '      ') THEN(DO)
   LOOP4:
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&JDAT)
             IF         COND(&JDAT *NE &DATE) THEN(DO)
             DLYJOB     DLY(60)
             DLYJOB     RSMTIME(003000)
             GOTO       CMDLBL(LOOP4)
             ENDDO
             ENDDO

             IF         COND(&JIKN *NE '      ') THEN(DO)
             DLYJOB     RSMTIME(&JIKN)
             ENDDO

             INZTAP     DEV(TAP01) NEWVOL(IAF) CHECK(*NO) +
                          DENSITY(*ULTRIUM6)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             STRSBS     SBSD(QSVCDRCTR)
             MONMSG     MSGID(CPF0000)
             GOTO       CMDLBL(END)
             ENDDO

             ENDSBS     SBS(*ALL) OPTION(*IMMED)
             MONMSG     MSGID(CPF0000)
             DLYJOB     DLY(300)


             SAVSYS     DEV(TAP01) VOL(IAF) ENDOPT(*LEAVE)
             SAVLIB     LIB(*NONSYS) DEV(TAP01) VOL(IAF) +
                          ENDOPT(*UNLOAD) ACCPTH(*YES) DTACPR(*YES)
             MONMSG     MSGID(CPF0000)

 SKP:
             IF         COND(&PNO3 *EQ 'Y') THEN(DO)
             ENDSBS     SBS(*ALL) OPTION(*IMMED)
             MONMSG     MSGID(CPF0000)
             PWRDWNSYS  OPTION(*CNTRLD) CONFIRM(*NO)
             ENDDO

             IF         COND(&PNO3 *EQ 'N') THEN(DO)
             PWRDWNSYS  OPTION(*CNTRLD) RESTART(*YES) CONFIRM(*NO)
             ENDDO

             ENDDO

             ENDDO
 END:
             ENDPGM
