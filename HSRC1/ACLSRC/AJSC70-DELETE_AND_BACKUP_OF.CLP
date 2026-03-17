             PGM
             /** AJSC70 *************************************/
             /* DELETE AND BACKUP OF                        */
             /*    PLATING / DACRODIZING PLATING ADMITTED   */
             /*    PLATING / DACRODIZING PLATING DISCHARGED */
             /*    PLATING / DACRODIZING PLATING BREAKDOWN  */
             /*    PLATING / DACRODIZING PLATING OPERATION  */
             /*                CREATE DATE : 1997/MAR/19.   */
             /*                AUTHOR      : S.OHTAKE.      */
             /***********************************************/
             DCLF       FILE(AJSPW70)
             DCL        VAR(&REC71)  TYPE(*DEC)  LEN(10 0) VALUE(0)
             DCL        VAR(&REC73)  TYPE(*DEC)  LEN(10 0) VALUE(0)
             DCL        VAR(&REC75)  TYPE(*DEC)  LEN(10 0) VALUE(0)
             DCL        VAR(&REC77)  TYPE(*DEC)  LEN(10 0) VALUE(0)
             DCL        VAR(&REC79)  TYPE(*DEC)  LEN(10 0) VALUE(0)
             DCL        VAR(&REC81)  TYPE(*DEC)  LEN(10 0) VALUE(0)
             DCL        VAR(&REC83)  TYPE(*DEC)  LEN(10 0) VALUE(0)
             DCL        VAR(&REC85)  TYPE(*DEC)  LEN(10 0) VALUE(0)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)    VALUE(QPRINT)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&SWITCH) TYPE(*CHAR) LEN(8)
             DCL        VAR(&US)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&IN99)   TYPE(*LGL)  LEN(1)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)

             RTVJOBA    JOB(&WSID)   USER(&US)   SWS(&SWITCH)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CALL       PGM(AGAR00)  PARM(&WSID &PRT &TYPE &PRTG)

             /********************************************/
             /* PROCESSED NUMBER RECEIVED FROM  SCREEN 1 */
             /********************************************/
 STEP1:      CHGVAR   VAR(&IN03) VALUE('0')
             CHGVAR   VAR(&IN05) VALUE('0')
             CHGVAR   VAR(&TVBAN) VALUE(' ')
 DSP1:       SNDRCVF  DEV(&WSID) RCDFMT(AJSPW701)
             IF         (&IN01 *EQ '1') GOTO END
             CHGVAR   VAR(&IN99) VALUE('0')

             IF COND(&TVBAN *EQ '1') THEN(GOTO STEP2) /* SCREEN 2*/
             IF COND(&TVBAN *EQ '2') THEN(GOTO STEP3) /* SCREEN 3*/
             IF COND(&TVBAN *EQ '3') THEN(GOTO STEP4) /* SCREEN 4*/
             IF COND(&TVBAN *EQ '4') THEN(GOTO STEP5) /* SCREEN 5*/
             IF COND(&TVBAN *EQ '5') THEN(GOTO STEP2) /* SCREEN 2*/
             CHGVAR   VAR(&IN99) VALUE('1')
             GOTO DSP1

             /***************************************************/
             /* DELETE DATE OF ADMISSION RECEIVED FROM SCREEN 2 */
             /***************************************************/
 STEP2:      CHGVAR   VAR(&IN03) VALUE('0')
             CHGVAR   VAR(&IN05) VALUE('0')
             CHGVAR   VAR(&TVTOHZ) VALUE('        ')
 DSP2:       SNDRCVF  DEV(&WSID) RCDFMT(AJSPW702)
             CHGVAR   VAR(&IN99) VALUE('0')
             CHGVAR   VAR(&IN91) VALUE('0')
             CHGVAR   VAR(&IN92) VALUE('0')
             IF   (&IN03 *EQ '1') GOTO STEP1

             /* ERROR CHECK (BLANK) */
             IF   (&TVTOHZ *EQ '        ') +
             DO
             CHGVAR   VAR(&IN99) VALUE('1')
             CHGVAR   VAR(&IN91) VALUE('1')
             CHGVAR     VAR(&ER702) VALUE('DATE ISN')
             GOTO DSP2
             ENDDO

             /* ERROR CHECK (MONTH) */
             IF         ('12' < (%SST(&TVTOHZ 5 2)) *OR  +
                         '01' > (%SST(&TVTOHZ 5 2)))  +
             DO
             CHGVAR   VAR(&IN99) VALUE('1')
             CHGVAR   VAR(&IN91) VALUE('1')
             CHGVAR     VAR(&ER702) +
                          VALUE('CHANGE "MONTH" OF DATE.')
             GOTO DSP2
             ENDDO

             /* ERROR CHECK (DAY) */
             IF  (('31' < (%SST(&TVTOHZ 7 2))) *OR +
                  ('01' > (%SST(&TVTOHZ 7 2)))) +
             DO
             CHGVAR   VAR(&IN99) VALUE('1')
             CHGVAR   VAR(&IN91) VALUE('1')
             CHGVAR     VAR(&ER702) +
                          VALUE('CHANGE "DAY" OF DATE.')
             GOTO DSP2
             ENDDO

             /* ERROR CHECK (TAPE SEQ) */
             IF         COND(&TVTOJN *EQ 0) THEN(DO)
             CHGVAR   VAR(&IN99) VALUE('1')
             CHGVAR   VAR(&IN92) VALUE('1')
             CHGVAR     VAR(&ER702) +
                          VALUE('INPUT ORDER NUMBER OF TAPE.')
             GOTO DSP2
             ENDDO

             IF         COND(&TVTOJN *EQ  1 ) THEN(GOTO CMDLBL(GOOD1))
             IF         COND(&TVTOJN *EQ  3 ) THEN(GOTO CMDLBL(GOOD1))
             IF         COND(&TVTOJN *EQ  5 ) THEN(GOTO CMDLBL(GOOD1))
             IF         COND(&TVTOJN *EQ  7 ) THEN(GOTO CMDLBL(GOOD1))
             IF         COND(&TVTOJN *EQ  9 ) THEN(GOTO CMDLBL(GOOD1))
             IF         COND(&TVTOJN *EQ  11) THEN(GOTO CMDLBL(GOOD1))
             IF         COND(&TVTOJN *EQ  13) THEN(GOTO CMDLBL(GOOD1))
             IF         COND(&TVTOJN *EQ  15) THEN(GOTO CMDLBL(GOOD1))
             IF         COND(&TVTOJN *EQ  17) THEN(GOTO CMDLBL(GOOD1))
             IF         COND(&TVTOJN *EQ  19) THEN(GOTO CMDLBL(GOOD1))
             IF         COND(&TVTOJN *EQ  21) THEN(GOTO CMDLBL(GOOD1))
             IF         COND(&TVTOJN *EQ  23) THEN(GOTO CMDLBL(GOOD1))
             CHGVAR   VAR(&IN99) VALUE('1')
             CHGVAR   VAR(&IN92) VALUE('1')
             CHGVAR     VAR(&ER702) VALUE('ORDER NUMBER OF TAPE IS +
                          1,3,5,7...17,19,21,23.')
             GOTO DSP2

             /* CMD-5 CHECK */
 GOOD1:      IF   (&IN05 *EQ '0') GOTO DSP2
             /* &TVBAN JUMP */
             IF   (&TVBAN *EQ '1') GOTO TOFIL

             /**************************************************/
             /* DISCHARGED DELETE DATE RECIEVED FROM  SCREEN 3 */
             /**************************************************/
 STEP3:      CHGVAR   VAR(&IN03) VALUE('0')
             CHGVAR   VAR(&IN05) VALUE('0')
             CHGVAR   VAR(&TVHIHZ) VALUE('        ')
 DSP3:       SNDRCVF  DEV(&WSID) RCDFMT(AJSPW703)
             CHGVAR   VAR(&IN99) VALUE('0')
             IF   (&IN03 *EQ '1') GOTO DSP2

             /* ERROR CHECK (BLANK) */
             IF   (&TVHIHZ *EQ '        ') +
             DO
             CHGVAR     VAR(&ER703) VALUE('DATE IS NOT INPUT.')
             CHGVAR   VAR(&IN99) VALUE('1')
             GOTO DSP3
             ENDDO

             /* ERROR CHECK (MONTH) */
             IF  ('12' < (%SST(&TVHIHZ 5 2)) *OR +
                  '01' > (%SST(&TVHIHZ 5 2))) +
             DO
             CHGVAR   VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&ER703) +
                          VALUE('CHANGE "MONTH" OF DATE.')
             GOTO DSP3
             ENDDO

             /* ERROR CHECK (DAY) */
             IF  ('31' < (%SST(&TVHIHZ 7 2)) *OR +
                  '01' > (%SST(&TVHIHZ 7 2))) +
             DO
             CHGVAR   VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&ER703) +
                          VALUE('CHANGE "DAY" OF DATE.')
             GOTO DSP3
             ENDDO

             /* ERROR CHECK (TAPE SEQ) */
             IF         COND(&TVHIJN *EQ 0 ) THEN(DO)
             CHGVAR   VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&ER703) +
                          VALUE('INPUT ORDER NUMBER OF TAPE.')
             GOTO DSP3
             ENDDO

             IF         COND(&TVHIJN *EQ  1  ) THEN(GOTO CMDLBL(GOOD2))
             IF         COND(&TVHIJN *EQ  4  ) THEN(GOTO CMDLBL(GOOD2))
             IF         COND(&TVHIJN *EQ  7  ) THEN(GOTO CMDLBL(GOOD2))
             IF         COND(&TVHIJN *EQ  10 ) THEN(GOTO CMDLBL(GOOD2))
             IF         COND(&TVHIJN *EQ  13 ) THEN(GOTO CMDLBL(GOOD2))
             IF         COND(&TVHIJN *EQ  16 ) THEN(GOTO CMDLBL(GOOD2))
             IF         COND(&TVHIJN *EQ  19 ) THEN(GOTO CMDLBL(GOOD2))
             IF         COND(&TVHIJN *EQ  22 ) THEN(GOTO CMDLBL(GOOD2))
             IF         COND(&TVHIJN *EQ  25 ) THEN(GOTO CMDLBL(GOOD2))
             IF         COND(&TVHIJN *EQ  28 ) THEN(GOTO CMDLBL(GOOD2))
             IF         COND(&TVHIJN *EQ  31 ) THEN(GOTO CMDLBL(GOOD2))
             IF         COND(&TVHIJN *EQ  34 ) THEN(GOTO CMDLBL(GOOD2))
             CHGVAR   VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&ER703) VALUE('ORDER NUMBER OF TAPE IS +
                          1,4,7,10...25,28,31,34.')
             GOTO DSP3

             /* CMD-5 CHECK */
 GOOD2:      IF   (&IN05 *EQ '0') GOTO DSP3

             /* * * * * * * * * * * * * * * */
             /* &TVBAN JUMP */
             /* * * * * * * * * * * * * * * */
             IF   (&TVBAN *EQ '2') GOTO HIFIL

             /***************************************************/
             /* DELETE DATE OF BREAKDOWN RECEIVED FROM SCREEN 4 */
             /***************************************************/
 STEP4:      CHGVAR   VAR(&IN03) VALUE('0')
             CHGVAR   VAR(&IN05) VALUE('0')
             CHGVAR   VAR(&TVBRHZ) VALUE('        ')
 DSP4:       SNDRCVF  DEV(&WSID) RCDFMT(AJSPW704)
             CHGVAR   VAR(&IN99) VALUE('0')
             CHGVAR   VAR(&IN91) VALUE('0')
             CHGVAR   VAR(&IN92) VALUE('0')
             IF   (&IN03 *EQ '1') GOTO STEP4

             /* ERROR CHECK (BLANK) */
             IF   (&TVBRHZ *EQ '        ') +
             DO
             CHGVAR   VAR(&IN99) VALUE('1')
             CHGVAR   VAR(&IN91) VALUE('1')
             CHGVAR     VAR(&ER704) VALUE('DATE ISN')
             GOTO DSP4
             ENDDO

             /* ERROR CHECK (MONTH) */
             IF         ('12' < (%SST(&TVBRHZ 5 2)) *OR  +
                         '01' > (%SST(&TVBRHZ 5 2)))  +
             DO
             CHGVAR   VAR(&IN99) VALUE('1')
             CHGVAR   VAR(&IN91) VALUE('1')
             CHGVAR     VAR(&ER704) +
                          VALUE('CHANGE "MONTH" OF DATE.')
             GOTO DSP4
             ENDDO

             /* ERROR CHECK (DAY) */
             IF  (('31' < (%SST(&TVBRHZ 7 2))) *OR +
                  ('01' > (%SST(&TVBRHZ 7 2)))) +
             DO
             CHGVAR   VAR(&IN99) VALUE('1')
             CHGVAR   VAR(&IN91) VALUE('1')
             CHGVAR     VAR(&ER704) +
                          VALUE('CHANGE "DAY" OF DATE.')
             GOTO DSP4
             ENDDO

             /* ERROR CHECK (TAPE SEQ) */
             IF         COND(&TVBRJN *EQ 0) THEN(DO)
             CHGVAR   VAR(&IN99) VALUE('1')
             CHGVAR   VAR(&IN92) VALUE('1')
             CHGVAR     VAR(&ER704) +
                          VALUE('INPUT ORDER NUMBER OF TAPE.')
             GOTO DSP4
             ENDDO

             IF         COND(&TVBRJN *EQ  1 ) THEN(GOTO CMDLBL(GOOD3))
             IF         COND(&TVBRJN *EQ  3 ) THEN(GOTO CMDLBL(GOOD3))
             IF         COND(&TVBRJN *EQ  5 ) THEN(GOTO CMDLBL(GOOD3))
             IF         COND(&TVBRJN *EQ  7 ) THEN(GOTO CMDLBL(GOOD3))
             IF         COND(&TVBRJN *EQ  9 ) THEN(GOTO CMDLBL(GOOD3))
             IF         COND(&TVBRJN *EQ  11) THEN(GOTO CMDLBL(GOOD3))
             IF         COND(&TVBRJN *EQ  13) THEN(GOTO CMDLBL(GOOD3))
             IF         COND(&TVBRJN *EQ  15) THEN(GOTO CMDLBL(GOOD3))
             IF         COND(&TVBRJN *EQ  17) THEN(GOTO CMDLBL(GOOD3))
             IF         COND(&TVBRJN *EQ  19) THEN(GOTO CMDLBL(GOOD3))
             IF         COND(&TVBRJN *EQ  21) THEN(GOTO CMDLBL(GOOD3))
             IF         COND(&TVBRJN *EQ  23) THEN(GOTO CMDLBL(GOOD3))
             CHGVAR   VAR(&IN99) VALUE('1')
             CHGVAR   VAR(&IN92) VALUE('1')
             CHGVAR     VAR(&ER702) VALUE('ORDER NUMBER OF TAPE IS +
                          1,3,5,7...17,19,21,23.')
             GOTO DSP4

             /* CMD-5 CHECK */
 GOOD3:      IF   (&IN05 *EQ '0') GOTO DSP4
             /* &TVBAN JUMP */
             IF   (&TVBAN *EQ '3') GOTO BRFIL

             /*************************************************/
             /* OPERATION DELETE DATE RECIEVED FROM  SCREEN 3 */
             /*************************************************/
 STEP5:      CHGVAR   VAR(&IN03) VALUE('0')
             CHGVAR   VAR(&IN05) VALUE('0')
             CHGVAR   VAR(&TVOPHZ) VALUE('        ')
 DSP5:       SNDRCVF  DEV(&WSID) RCDFMT(AJSPW705)
             CHGVAR   VAR(&IN99) VALUE('0')
             IF   (&IN03 *EQ '1') GOTO DSP5

             /* ERROR CHECK (BLANK) */
             IF   (&TVOPHZ *EQ '        ') +
             DO
             CHGVAR     VAR(&ER705) VALUE('DATE IS NOT INPUT.')
             CHGVAR   VAR(&IN99) VALUE('1')
             GOTO DSP5
             ENDDO

             /* ERROR CHECK (MONTH) */
             IF  ('12' < (%SST(&TVOPHZ 5 2)) *OR +
                  '01' > (%SST(&TVOPHZ 5 2))) +
             DO
             CHGVAR   VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&ER705) +
                          VALUE('CHANGE "MONTH" OF DATE.')
             GOTO DSP5
             ENDDO

             /* ERROR CHECK (DAY) */
             IF  ('31' < (%SST(&TVOPHZ 7 2)) *OR +
                  '01' > (%SST(&TVOPHZ 7 2))) +
             DO
             CHGVAR   VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&ER705) +
                          VALUE('CHANGE "DAY" OF DATE.')
             GOTO DSP5
             ENDDO

             /* ERROR CHECK (TAPE SEQ) */
             IF         COND(&TVOPJN *EQ 0 ) THEN(DO)
             CHGVAR   VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&ER703) +
                          VALUE('INPUT ORDER NUMBER OF TAPE.')
             GOTO DSP5
             ENDDO

             IF         COND(&TVOPJN *EQ  1  ) THEN(GOTO CMDLBL(GOOD4))
             IF         COND(&TVOPJN *EQ  4  ) THEN(GOTO CMDLBL(GOOD4))
             IF         COND(&TVOPJN *EQ  7  ) THEN(GOTO CMDLBL(GOOD4))
             IF         COND(&TVOPJN *EQ  10 ) THEN(GOTO CMDLBL(GOOD4))
             IF         COND(&TVOPJN *EQ  13 ) THEN(GOTO CMDLBL(GOOD4))
             IF         COND(&TVOPJN *EQ  16 ) THEN(GOTO CMDLBL(GOOD4))
             IF         COND(&TVOPJN *EQ  19 ) THEN(GOTO CMDLBL(GOOD4))
             IF         COND(&TVOPJN *EQ  22 ) THEN(GOTO CMDLBL(GOOD4))
             IF         COND(&TVOPJN *EQ  25 ) THEN(GOTO CMDLBL(GOOD4))
             IF         COND(&TVOPJN *EQ  28 ) THEN(GOTO CMDLBL(GOOD4))
             IF         COND(&TVOPJN *EQ  31 ) THEN(GOTO CMDLBL(GOOD4))
             IF         COND(&TVOPJN *EQ  34 ) THEN(GOTO CMDLBL(GOOD4))
             CHGVAR   VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&ER705) VALUE('ORDER NUMBER OF TAPE IS +
                          1,4,7,10...25,28,31,34.')
             GOTO DSP5

             /* CMD-5 CHECK */
 GOOD4:      IF   (&IN05 *EQ '0') GOTO DSP5

             /* * * * * * * * * * * * * * * */
             /* &TVBAN JUMP */
             /* * * * * * * * * * * * * * * */
             IF   (&TVBAN *EQ '4') GOTO OPFIL

             /*******************************************/
             /* DELETE AND MAKING  OF ADMISSION WORK    */
             /*******************************************/
 TOFIL:      DLTF       FILE(HWFILE1/AJSWP70)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(HWFILE1/AJSWP71)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(HWFILE1/AJSWP72)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(HWFILE1/AJSWP73)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTPF      FILE(HWFILE1/AJSWP70) RCDLEN(167) +
                          TEXT('AJSPP10 LIVE') OPTION(*NOLIST) +
                          SIZE(500000 30000 10) LVLCHK(*NO) AUT(*ALL)
             CRTPF      FILE(HWFILE1/AJSWP71) RCDLEN(167) +
                          TEXT('AJSPP50 MT COPY') OPTION(*NOLIST) +
                          SIZE(500000 30000 10) LVLCHK(*NO) AUT(*ALL)
             CRTPF      FILE(HWFILE1/AJSWP72) RCDLEN(167) +
                          TEXT('AJSPP10 LIVE') OPTION(*NOLIST) +
                          SIZE(500000 30000 10) LVLCHK(*NO) AUT(*ALL)
             CRTPF      FILE(HWFILE1/AJSWP73) RCDLEN(167) +
                          TEXT('AJSPP50 MT COPY') OPTION(*NOLIST) +
                          SIZE(500000 30000 10) LVLCHK(*NO) AUT(*ALL)

             GRTOBJAUT  OBJ(AJSWP70) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)
             GRTOBJAUT  OBJ(AJSWP71) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)
             GRTOBJAUT  OBJ(AJSWP72) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)
             GRTOBJAUT  OBJ(AJSWP73) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)

             /****************************************************/
             /* DELETE AND MAKING OF DUMMY FILE THAT HAS NO DATA */
             /****************************************************/
             DLTF       FILE(HWFILE1/AJSWP7A)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/AJSWP7A) RCDLEN(123) TEXT('DAMY +
                          FILE') OPTION(*NOLIST) SIZE(1 1 1) +
                          LVLCHK(*NO) AUT(*ALL)
             GRTOBJAUT  OBJ(AJSWP7A) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)

             CALL AJSR75
             /* * * * * * * * * * * * * * * * * * * * * * * */
             /*  ADMISSION DATA  DIVIDED  */
             /* * * * * * * * * * * * * * * * * * * * * * * */
             /* AJSPP10 */
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(*N +
                          158) CPI(12) OUTQ(&PRTG) HOLD(*YES) +
                          IGCDTA(&PIGCD)
             CALL       PGM(AJSR70) PARM(&TVTOHZ)
             DLTOVR QPRINT
             /* AJSPP50 */
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(*N +
                          158) CPI(12) OUTQ(&PRTG) HOLD(*YES) +
                          IGCDTA(&PIGCD)
             CALL       PGM(AJSR71) PARM(&TVTOHZ)
             DLTOVR QPRINT
             /* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
             /*ADMITTED DELETE DATA PRESENCE CHECK */
             /* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
             RTVMBRD    FILE(HWFILE1/AJSWP71) NBRCURRCD(&REC71)
             RTVMBRD    FILE(HWFILE1/AJSWP73) NBRCURRCD(&REC73)
             /* PLATING ADMITTED */
             IF   (&REC71 = 0 ) +
             DO
 STEPC1:     SNDPGMMSG  MSG('( G.C ) THERE ARE NO ACTUAL PLATING +
                          ADMITTED DELETE DATA. IF IT RUNS THESE +
                          STATUS, DUMMY RECORD WILL BE WRITTN.') +
                          TOMSGQ(QSYSOPR) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *EQ 'G') *OR (&KOTAE *EQ 'g')) +
                          THEN(GOTO CMDLBL(STEPC2))
             IF         COND((&KOTAE *EQ 'C') *OR (&KOTAE *EQ 'c')) +
                          THEN(GOTO CMDLBL(END))
             GOTO STEPC1
             ENDDO
             /* DACRODIZING PLATING ADMITTED */
 STEPC2:     IF   (&REC73 = 0 ) +
             DO
 STEPC3:     SNDPGMMSG  MSG('( G.C ) THERE ARE NO ACTUAL DACRODIZING +
                          PLATING ADMITTED DELETE DATA. IF IT RUNS +
                          THESE STATUS, DUMMY RECORD WILL BE +
                          WRITTN.') TOMSGQ(QSYSOPR) MSGTYPE(*INQ) +
                          KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *EQ 'G') *OR (&KOTAE *EQ 'g')) +
                          THEN(GOTO CMDLBL(STEPA1))
             IF         COND((&KOTAE *EQ 'C') *OR (&KOTAE *EQ 'c')) +
                          THEN(GOTO CMDLBL(END))
             GOTO STEPC3
             ENDDO
             /************************************/
             /*  ADMITTED DELETE DATA MT BACKUP */
             /************************************/
 STEPA1:     SNDPGMMSG  MSG('( G.C ) SET BACK UP TAPE FOR ACTUAL +
                          PLATING / DACRODIZING PLATING ADMITTED +
                          DELETE DATA.') TOMSGQ(QSYSOPR) +
                          MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *EQ 'G') *EQ (&KOTAE *EQ 'g')) +
                          THEN(GOTO CMDLBL(STEPA2))
             IF         COND((&KOTAE *EQ 'C') *OR (&KOTAE *EQ 'c')) +
                          THEN(GOTO CMDLBL(END))
             GOTO STEPA1
             /* AJSPP10 DELETE DATA COPY */
 STEPA2:     IF   (&REC71 *NE 0 ) +
             DO
             CPYTOTAP   FROMFILE(AJSWP71) TOFILE(QTAPE) +
                          FROMMBR(AJSWP71) TOSEQNBR(&TVTOJN) +
                          TODEV(TAP01) TOENDOPT(*LEAVE) TOVOL(AOYAMA)
             ENDDO
             ELSE +
             DO
             CPYTOTAP   FROMFILE(AJSWP7A) TOFILE(QTAPE) +
                          FROMMBR(AJSWP7A) TOSEQNBR(&TVTOJN) +
                          TODEV(TAP01) TOENDOPT(*LEAVE) TOVOL(AOYAMA)
             ENDDO
             /* ORDER NUMBER +1*/
             CHGVAR     VAR(&TVTOJN) VALUE(&TVTOJN+1)

             /* AJSPP50 DELETE DATA COPY */
             IF   (&REC73 *NE 0 ) +
             DO
             CPYTOTAP   FROMFILE(AJSWP73) TOFILE(QTAPE) +
                          FROMMBR(AJSWP73) TOSEQNBR(&TVTOJN) +
                          TODEV(TAP01) TOENDOPT(*UNLOAD) TOVOL(AOYAMA)
             ENDDO
             ELSE +
             DO
             CPYTOTAP   FROMFILE(AJSWP7A) TOFILE(QTAPE) +
                          FROMMBR(AJSWP7A) TOSEQNBR(&TVTOJN) +
                          TODEV(TAP01) TOENDOPT(*LEAVE) TOVOL(AOYAMA)
             ENDDO
             /* MSG */
 STEPA3:     SNDPGMMSG  MSG('( G ) TAKE OUT BACK UP TAPE FOR ACTUAL +
                          PLATING / DACRODIZING PLATING ADMITTED +
                          DELETE DATA.') TOMSGQ(QSYSOPR) +
                          MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *EQ 'G') *OR (&KOTAE *EQ 'g')) +
                          THEN(GOTO CMDLBL(STEPA4))
             GOTO STEPA3
             /* CLEAR AND COPY ADMISSION DATA */
 STEPA4:     CLRPFM     FILE(AJSPP10)
             CPYF       FROMFILE(HWFILE1/AJSWP70) TOFILE(AJSPP10) +
                          FROMMBR(AJSWP70) MBROPT(*REPLACE) +
                          FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817)
             CLRPFM     FILE(AJSPP50)
             CPYF       FROMFILE(HWFILE1/AJSWP72) TOFILE(AJSPP50) +
                          FROMMBR(AJSWP72) MBROPT(*REPLACE) +
                          FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817)

             /* WORK FILE DELETE */
             DLTF       AJSWP70
             DLTF       AJSWP71
             DLTF       AJSWP72
             DLTF       AJSWP73
             DLTF       AJSWP7A
             /* TVBAN JUMP */
             IF   (&TVBAN *EQ '1') GOTO END

             /**************************/
             /* DISCHARGE WORK MAKING  */
             /**************************/
 HIFIL:      DLTF       FILE(HWFILE1/AJSWP74)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(HWFILE1/AJSWP75)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(HWFILE1/AJSWP76)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(HWFILE1/AJSWP77)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTPF      FILE(HWFILE1/AJSWP74) RCDLEN(167) +
                          TEXT('AJSPP20 LIVE') OPTION(*NOLIST) +
                          SIZE(500000 30000 10) LVLCHK(*NO) AUT(*ALL)
             CRTPF      FILE(HWFILE1/AJSWP75) RCDLEN(167) +
                          TEXT('AJSPP20 MT COPY') OPTION(*NOLIST) +
                          SIZE(500000 30000 10) LVLCHK(*NO) AUT(*ALL)
             CRTPF      FILE(HWFILE1/AJSWP76) RCDLEN(167) +
                          TEXT('AJSPP60 LIVE') OPTION(*NOLIST) +
                          SIZE(500000 30000 10) LVLCHK(*NO) AUT(*ALL)
             CRTPF      FILE(HWFILE1/AJSWP77) RCDLEN(167) +
                          TEXT('AJSPP60 MT COPY') OPTION(*NOLIST) +
                          SIZE(500000 30000 10) LVLCHK(*NO) AUT(*ALL)

             GRTOBJAUT  OBJ(AJSWP74) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)
             GRTOBJAUT  OBJ(AJSWP75) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)
             GRTOBJAUT  OBJ(AJSWP76) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)
             GRTOBJAUT  OBJ(AJSWP77) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)

             /****************************************************/
             /* DELETE AND MAKING OF DUMMY FILE THAT HAS NO DATA */
             /****************************************************/
             DLTF       FILE(HWFILE1/AJSWP7A)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/AJSWP7A) RCDLEN(123) TEXT('DAMY +
                          FILE') OPTION(*NOLIST) SIZE(1 1 1) +
                          LVLCHK(*NO) AUT(*ALL)
             GRTOBJAUT  OBJ(AJSWP7A) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)
             CALL AJSR75
             /* * * * * * * * * * * * * * * * * * * * * * * */
             /* DISCHARGE DATA DIVIDED */
             /* * * * * * * * * * * * * * * * * * * * * * * */
             /* AJSPP20 */
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) OUTQ(&PRTG) +
                          HOLD(*YES) IGCDTA(&PIGCD)
             CALL       PGM(AJSR72) PARM(&TVHIHZ)
             DLTOVR QPRINT
             /* AJSPP60 */
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(*N +
                          158) CPI(12) OUTQ(&PRTG) HOLD(*YES) +
                          IGCDTA(&PIGCD)
             CALL       PGM(AJSR73) PARM(&TVHIHZ)
             DLTOVR QPRINT
             /* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
             /* DISCHARGED DELETE DATA PRESENCE CHECK */
             /* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
             RTVMBRD    FILE(HWFILE1/AJSWP75) NBRCURRCD(&REC75)
             RTVMBRD    FILE(HWFILE1/AJSWP77) NBRCURRCD(&REC77)
             /* PLATING DISCHARGED */
             IF   (&REC75 = 0 ) +
             DO
 STEPD1:     SNDPGMMSG  MSG('( G.C ) THERE ARE NO ACTUAL PLATING +
                          DISCHARGE DELETE DATA. IF IT RUNS THESE +
                          STATUS, DUMMY RECORD WILL BE WRITTEN.') +
                          TOMSGQ(QSYSOPR) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *EQ 'G') *EQ (&KOTAE *EQ 'g')) +
                          THEN(GOTO CMDLBL(STEPD2))
             IF         COND((&KOTAE *EQ 'C') *OR (&KOTAE *EQ 'c')) +
                          THEN(GOTO CMDLBL(END))
             GOTO STEPD1
             ENDDO
             /* DACRODIZING PLATING DISCHARGED */
 STEPD2:     IF   (&REC77 = 0 ) +
             DO
 STEPD3:     SNDPGMMSG  MSG('( G.C ) THERE ARE NO ACTUAL DACRODIZING +
                          PLATING DISCHARGE DELETE DATA. IF IT RUNS +
                          THESE STATUS, DUMMY RECORD WILL BE +
                          WRITTEN.') TOMSGQ(QSYSOPR) MSGTYPE(*INQ) +
                          KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *EQ 'G') *OR (&KOTAE *EQ 'g')) +
                          THEN(GOTO CMDLBL(STEPB1))
             IF         COND((&KOTAE *EQ 'C') *OR (&KOTAE *EQ 'c')) +
                          THEN(GOTO CMDLBL(END))
             GOTO STEPD3
             ENDDO
             /************************************/
             /* DISCHARGED DELETE DATA MT BACKUP */
             /************************************/
 STEPB1:     SNDPGMMSG  MSG('( G.C ) SET BACK UP TAPE FOR ACTUAL +
                          PLATING / DACRODIZING PLATING DISCHARGE +
                          DELETE DATA.') TOMSGQ(QSYSOPR) +
                          MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *EQ 'G') *OR (&KOTAE *EQ 'g')) +
                          THEN(GOTO CMDLBL(STEPB2))
             IF         COND((&KOTAE *EQ 'C') *OR (&KOTAE *EQ 'c')) +
                          THEN(GOTO CMDLBL(END))
             GOTO STEPB1
             /*AJSPP20 DELETE DATA COPY */
 STEPB2:     IF   (&REC75 *NE 0 ) +
             DO
             CPYTOTAP   FROMFILE(AJSWP75) TOFILE(QTAPE) +
                          FROMMBR(AJSWP75) TOSEQNBR(&TVHIJN) +
                          TODEV(TAP01) TOENDOPT(*LEAVE) TOVOL(AOYAMA)
             ENDDO
             ELSE +
             DO
             CPYTOTAP   FROMFILE(AJSWP7A) TOFILE(QTAPE) +
                          FROMMBR(AJSWP7A) TOSEQNBR(&TVHIJN) +
                          TODEV(TAP01) TOENDOPT(*LEAVE) TOVOL(AOYAMA)
             ENDDO
             /* ORDER NUMBER +1*/
             CHGVAR     VAR(&TVHIJN) VALUE(&TVHIJN+1)

             /*AJSPP60 DELETE DATA COPY */
             IF   (&REC77 *NE 0 ) +
             DO
             CPYTOTAP   FROMFILE(AJSWP77) TOFILE(QTAPE) +
                          FROMMBR(AJSWP77) TOSEQNBR(&TVHIJN) +
                          TODEV(TAP01) TOENDOPT(*LEAVE) TOVOL(AOYAMA)
             ENDDO
             ELSE +
             DO
             CPYTOTAP   FROMFILE(AJSWP7A) TOFILE(QTAPE) +
                          FROMMBR(AJSWP7A) TOSEQNBR(&TVHIJN) +
                          TODEV(TAP01) TOENDOPT(*LEAVE) TOVOL(AOYAMA)
             ENDDO
             /* ORDER NUMBER +1*/
             CHGVAR     VAR(&TVHIJN) VALUE(&TVHIJN+1)

             /* MSG */
 STEPB3:     SNDPGMMSG  MSG('( G ) TAKE OUT BACK UP TAPE FOR ACTUAL +
                          PLATING / DACRODIZING PLATING DISCHARGE +
                          DELETE DATA.') TOMSGQ(QSYSOPR) +
                          MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *EQ 'G') *OR (&KOTAE *EQ 'g')) +
                          THEN(GOTO CMDLBL(STEPB4))
             GOTO STEPB3
             /* DISCHARGE DATA CLEAR AND COPY */
 STEPB4:     CLRPFM     FILE(AJSPP20)
             CPYF       FROMFILE(HWFILE1/AJSWP74) TOFILE(AJSPP20) +
                          FROMMBR(AJSWP74) MBROPT(*REPLACE) +
                          FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817)
             CLRPFM     FILE(AJSPP60)
             CPYF       FROMFILE(HWFILE1/AJSWP76) TOFILE(AJSPP60) +
                          FROMMBR(AJSWP76) MBROPT(*REPLACE) +
                          FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817)

             /* WORK FILE DELETE */
             DLTF       AJSWP74
             DLTF       AJSWP75
             DLTF       AJSWP76
             DLTF       AJSWP77
             DLTF       AJSWP7A
             /* TVBAN JUMP */
             IF   (&TVBAN *EQ '2') GOTO END

             /**************************/
             /* BREAKDOWN WORK MAKING  */
             /**************************/
 BRFIL:      DLTF       FILE(HWFILE1/AJSWP78)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(HWFILE1/AJSWP79)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(HWFILE1/AJSWP80)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(HWFILE1/AJSWP81)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTPF      FILE(HWFILE1/AJSWP78) RCDLEN(87) +
                          TEXT('AJSPP30 LIVE') OPTION(*NOLIST) +
                          SIZE(500000 30000 10) LVLCHK(*NO) AUT(*ALL)
             CRTPF      FILE(HWFILE1/AJSWP79) RCDLEN(87) +
                          TEXT('AJSPP30 MT COPY') OPTION(*NOLIST) +
                          SIZE(500000 30000 10) LVLCHK(*NO) AUT(*ALL)
             CRTPF      FILE(HWFILE1/AJSWP80) RCDLEN(87) +
                          TEXT('AJSPP70 LIVE') OPTION(*NOLIST) +
                          SIZE(500000 30000 10) LVLCHK(*NO) AUT(*ALL)
             CRTPF      FILE(HWFILE1/AJSWP81) RCDLEN(87) +
                          TEXT('AJSPP70 MT COPY') OPTION(*NOLIST) +
                          SIZE(500000 30000 10) LVLCHK(*NO) AUT(*ALL)

             GRTOBJAUT  OBJ(AJSWP78) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)
             GRTOBJAUT  OBJ(AJSWP79) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)
             GRTOBJAUT  OBJ(AJSWP80) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)
             GRTOBJAUT  OBJ(AJSWP81) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)

             /****************************************************/
             /* DELETE AND MAKING OF DUMMY FILE THAT HAS NO DATA */
             /****************************************************/
             DLTF       FILE(HWFILE1/AJSWP7A)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/AJSWP7A) RCDLEN(123) TEXT('DAMY +
                          FILE') OPTION(*NOLIST) SIZE(1 1 1) +
                          LVLCHK(*NO) AUT(*ALL)
             GRTOBJAUT  OBJ(AJSWP7A) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)
             CALL AJSR75
             /* * * * * * * * * * * * * * * * * * * * * * * */
             /* BREAKDOWN DATA DIVIDED */
             /* * * * * * * * * * * * * * * * * * * * * * * */
             /* AJSPP30 */
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) OUTQ(&PRTG) +
                          HOLD(*YES) IGCDTA(&PIGCD)
             CALL       PGM(AJSR74) PARM(&TVBRHZ)
             DLTOVR QPRINT
             /* AJSPP70 */
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(*N +
                          158) CPI(12) OUTQ(&PRTG) HOLD(*YES) +
                          IGCDTA(&PIGCD)
             CALL       PGM(AJSR76) PARM(&TVBRHZ)
             DLTOVR QPRINT
             /* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
             /* BREAKDOWN  DELETE DATA PRESENCE CHECK */
             /* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
             RTVMBRD    FILE(HWFILE1/AJSWP79) NBRCURRCD(&REC79)
             RTVMBRD    FILE(HWFILE1/AJSWP81) NBRCURRCD(&REC81)
             /* PLATING BREAKDOWN */
             IF   (&REC79 = 0 ) +
             DO
 STEPE1:     SNDPGMMSG  MSG('( G.C ) THERE ARE NO ACTUAL PLATING +
                          BREAKDOWN DELETE DATA. IF IT RUNS THESE +
                          STATUS, DUMMY RECORD WILL BE WRITTEN.') +
                          TOMSGQ(QSYSOPR) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *EQ 'G') *OR (&KOTAE *EQ 'g')) +
                          THEN(GOTO CMDLBL(STEPE2))
             IF         COND((&KOTAE *EQ 'C') *OR (&KOTAE *EQ 'c')) +
                          THEN(GOTO CMDLBL(END))
             GOTO STEPE1
             ENDDO
             /* DACRODIZING PLATING BREAKDOWN */
 STEPE2:     IF   (&REC81 = 0 ) +
             DO
 STEPE3:     SNDPGMMSG  MSG('( G.C ) THERE ARE NO ACTUAL DACRODIZING +
                          PLATING BREAKDOWN DELETE DATA. IF IT RUNS +
                          THESE STATUS, DUMMY RECORD WILL BE +
                          WRITTEN.') TOMSGQ(QSYSOPR) MSGTYPE(*INQ) +
                          KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *EQ 'G') *OR (&KOTAE *EQ 'g')) +
                          THEN(GOTO CMDLBL(STEPG1))
             IF         COND((&KOTAE *EQ 'C') *OR (&KOTAE *EQ 'c')) +
                          THEN(GOTO CMDLBL(END))
             GOTO STEPE3
             ENDDO
             /************************************/
             /* BREAKDOWN  DELETE DATA MT BACKUP */
             /************************************/
 STEPG1:     SNDPGMMSG  MSG('( G.C ) SET BACK UP TAPE FOR ACTUAL +
                          PLATING / DACRODIZING PLATING BREAKDOWN +
                          DELETE DATA.') TOMSGQ(QSYSOPR) +
                          MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *EQ 'G') *EQ (&KOTAE *EQ 'g')) +
                          THEN(GOTO CMDLBL(STEPG2))
             IF         COND((&KOTAE *EQ 'C') *OR (&KOTAE *EQ 'c')) +
                          THEN(GOTO CMDLBL(END))
             GOTO STEPG1
             /*AJSPP30 DELETE DATA COPY */
 STEPG2:     IF   (&REC79 *NE 0 ) +
             DO
             CPYTOTAP   FROMFILE(AJSWP79) TOFILE(QTAPE) +
                          FROMMBR(AJSWP79) TOSEQNBR(&TVBRJN) +
                          TODEV(TAP01) TOENDOPT(*LEAVE) TOVOL(AOYAMA)
             ENDDO
             ELSE +
             DO
             CPYTOTAP   FROMFILE(AJSWP7A) TOFILE(QTAPE) +
                          FROMMBR(AJSWP7A) TOSEQNBR(&TVBRJN) +
                          TODEV(TAP01) TOENDOPT(*LEAVE) TOVOL(AOYAMA)
             ENDDO
             /* ORDER NUMBER +1*/
             CHGVAR     VAR(&TVBRJN) VALUE(&TVBRJN+1)

             /*AJSPP70 DELETE DATA COPY */
             IF   (&REC81 *NE 0 ) +
             DO
             CPYTOTAP   FROMFILE(AJSWP81) TOFILE(QTAPE) +
                          FROMMBR(AJSWP81) TOSEQNBR(&TVBRJN) +
                          TODEV(TAP01) TOENDOPT(*LEAVE) TOVOL(AOYAMA)
             ENDDO
             ELSE +
             DO
             CPYTOTAP   FROMFILE(AJSWP7A) TOFILE(QTAPE) +
                          FROMMBR(AJSWP7A) TOSEQNBR(&TVBRJN) +
                          TODEV(TAP01) TOENDOPT(*LEAVE) TOVOL(AOYAMA)
             ENDDO
             /* ORDER NUMBER +1*/
             CHGVAR     VAR(&TVBRJN) VALUE(&TVBRJN+1)

             /* MSG */
 STEPG3:     SNDPGMMSG  MSG('( G ) TAKE OUT BACK UP TAPE FOR ACTUAL +
                          PLATING / DACRODIZING PLATING BREAKDOWN +
                          DELETE DATA.') TOMSGQ(QSYSOPR) +
                          MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *EQ 'G') *OR (&KOTAE *EQ 'g')) +
                          THEN(GOTO CMDLBL(STEPG4))
             GOTO STEPG3
             /* BREAKDOWN DATA CLEAR AND COPY */
 STEPG4:     CLRPFM     FILE(AJSPP30)
             CPYF       FROMFILE(HWFILE1/AJSWP78) TOFILE(AJSPP30) +
                          FROMMBR(AJSWP78) MBROPT(*REPLACE) +
                          FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817)
             CLRPFM     FILE(AJSPP70)
             CPYF       FROMFILE(HWFILE1/AJSWP80) TOFILE(AJSPP70) +
                          FROMMBR(AJSWP80) MBROPT(*REPLACE) +
                          FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817)

             /* WORK FILE DELETE */
             DLTF       AJSWP78
             DLTF       AJSWP79
             DLTF       AJSWP80
             DLTF       AJSWP81
             DLTF       AJSWP7A
             /* TVBAN JUMP */
             IF   (&TVBAN *EQ '3') GOTO END

             /**************************/
             /* OPERATION WORK MAKING  */
             /**************************/
 OPFIL:      DLTF       FILE(HWFILE1/AJSWP82)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(HWFILE1/AJSWP83)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(HWFILE1/AJSWP84)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(HWFILE1/AJSWP85)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTPF      FILE(HWFILE1/AJSWP82) RCDLEN(75) +
                          TEXT('AJSPP40 LIVE') OPTION(*NOLIST) +
                          SIZE(500000 30000 10) LVLCHK(*NO) AUT(*ALL)
             CRTPF      FILE(HWFILE1/AJSWP83) RCDLEN(75) +
                          TEXT('AJSPP40 MT COPY') OPTION(*NOLIST) +
                          SIZE(500000 30000 10) LVLCHK(*NO) AUT(*ALL)
             CRTPF      FILE(HWFILE1/AJSWP84) RCDLEN(75) +
                          TEXT('AJSPP80 LIVE') OPTION(*NOLIST) +
                          SIZE(500000 30000 10) LVLCHK(*NO) AUT(*ALL)
             CRTPF      FILE(HWFILE1/AJSWP85) RCDLEN(75) +
                          TEXT('AJSPP80 MT COPY') OPTION(*NOLIST) +
                          SIZE(500000 30000 10) LVLCHK(*NO) AUT(*ALL)

             GRTOBJAUT  OBJ(AJSWP82) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)
             GRTOBJAUT  OBJ(AJSWP83) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)
             GRTOBJAUT  OBJ(AJSWP84) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)
             GRTOBJAUT  OBJ(AJSWP85) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)

             /****************************************************/
             /* DELETE AND MAKING OF DUMMY FILE THAT HAS NO DATA */
             /****************************************************/
             DLTF       FILE(HWFILE1/AJSWP7A)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/AJSWP7A) RCDLEN(123) TEXT('DAMY +
                          FILE') OPTION(*NOLIST) SIZE(1 1 1) +
                          LVLCHK(*NO) AUT(*ALL)
             GRTOBJAUT  OBJ(AJSWP7A) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)
             CALL AJSR75
             /* * * * * * * * * * * * * * * * * * * * * * * */
             /* OPERATION DATA DIVIDED */
             /* * * * * * * * * * * * * * * * * * * * * * * */
             /* AJSPP40 */
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) OUTQ(&PRTG) +
                          HOLD(*YES) IGCDTA(&PIGCD)
             CALL       PGM(AJSR77) PARM(&TVOPHZ)
             DLTOVR QPRINT
             /* AJSPP60 */
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(*N +
                          158) CPI(12) OUTQ(&PRTG) HOLD(*YES) +
                          IGCDTA(&PIGCD)
             CALL       PGM(AJSR78) PARM(&TVOPHZ)
             DLTOVR QPRINT
             /* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
             /* OPERATION  DELETE DATA PRESENCE CHECK */
             /* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
             RTVMBRD    FILE(HWFILE1/AJSWP83) NBRCURRCD(&REC83)
             RTVMBRD    FILE(HWFILE1/AJSWP85) NBRCURRCD(&REC85)
             /* PLATING OPERATION */
             IF   (&REC83 = 0 ) +
             DO
 STEPF1:     SNDPGMMSG  MSG('( G.C ) THERE ARE NO ACTUAL PLATING +
                          OPERATION DELETE DATA. IF IT RUNS THESE +
                          STATUS, DUMMY RECORD WILL BE WRITTEN.') +
                          TOMSGQ(QSYSOPR) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *EQ 'G') *EQ (&KOTAE *EQ 'g')) +
                          THEN(GOTO CMDLBL(STEPF2))
             IF         COND((&KOTAE *EQ 'C') *OR (&KOTAE *EQ 'c')) +
                          THEN(GOTO CMDLBL(END))
             GOTO STEPF1
             ENDDO
             /* DACRODIZING PLATING OPERATION */
 STEPF2:     IF   (&REC85 = 0 ) +
             DO
 STEPF3:     SNDPGMMSG  MSG('( G.C ) THERE ARE NO ACTUAL DACRODIZING +
                          PLATING OPERATION DELETE DATA. IF IT RUNS +
                          THESE STATUS, DUMMY RECORD WILL BE +
                          WRITTEN.') TOMSGQ(QSYSOPR) MSGTYPE(*INQ) +
                          KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *EQ 'G') *OR (&KOTAE *EQ 'g')) +
                          THEN(GOTO CMDLBL(STEPH1))
             IF         COND((&KOTAE *EQ 'C') *OR (&KOTAE *EQ 'c')) +
                          THEN(GOTO CMDLBL(END))
             GOTO STEPF3
             ENDDO
             /************************************/
             /* OPERATION  DELETE DATA MT BACKUP */
             /************************************/
 STEPH1:     SNDPGMMSG  MSG('( G.C ) SET BACK UP TAPE FOR ACTUAL +
                          PLATING / DACRODIZING PLATING OPERATION +
                          DELETE DATA.') TOMSGQ(QSYSOPR) +
                          MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *EQ 'G') *OR (&KOTAE *EQ 'g')) +
                          THEN(GOTO CMDLBL(STEPH2))
             IF         COND((&KOTAE *EQ 'C') *OR (&KOTAE *EQ 'c')) +
                          THEN(GOTO CMDLBL(END))
             GOTO STEPH1
             /*AJSPP40 DELETE DATA COPY */
 STEPH2:     IF   (&REC83 *NE 0 ) +
             DO
             CPYTOTAP   FROMFILE(AJSWP83) TOFILE(QTAPE) +
                          FROMMBR(AJSWP83) TOSEQNBR(&TVOPJN) +
                          TODEV(TAP01) TOENDOPT(*LEAVE) TOVOL(AOYAMA)
             ENDDO
             ELSE +
             DO
             CPYTOTAP   FROMFILE(AJSWP7A) TOFILE(QTAPE) +
                          FROMMBR(AJSWP7A) TOSEQNBR(&TVOPJN) +
                          TODEV(TAP01) TOENDOPT(*LEAVE) TOVOL(AOYAMA)
             ENDDO
             /* ORDER NUMBER +1*/
             CHGVAR     VAR(&TVOPJN) VALUE(&TVOPJN+1)

             /*AJSPP80 DELETE DATA COPY */
             IF   (&REC85 *NE 0 ) +
             DO
             CPYTOTAP   FROMFILE(AJSWP85) TOFILE(QTAPE) +
                          FROMMBR(AJSWP85) TOSEQNBR(&TVOPJN) +
                          TODEV(TAP01) TOENDOPT(*LEAVE) TOVOL(AOYAMA)
             ENDDO
             ELSE +
             DO
             CPYTOTAP   FROMFILE(AJSWP7A) TOFILE(QTAPE) +
                          FROMMBR(AJSWP7A) TOSEQNBR(&TVOPJN) +
                          TODEV(TAP01) TOENDOPT(*LEAVE) TOVOL(AOYAMA)
             ENDDO
             /* ORDER NUMBER +1*/
             CHGVAR     VAR(&TVOPJN) VALUE(&TVOPJN+1)

             /* MSG */
 STEPH3:     SNDPGMMSG  MSG('( G ) TAKE OUT BACK UP TAPE FOR ACTUAL +
                          PLATING / DACRODIZING PLATING OPERATION +
                          DELETE DATA.') TOMSGQ(QSYSOPR) +
                          MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *EQ 'G') *OR (&KOTAE *EQ 'g')) +
                          THEN(GOTO CMDLBL(STEPH4))
             GOTO STEPH3
             /* OPERATION DATA CLEAR AND COPY */
 STEPH4:     CLRPFM     FILE(AJSPP40)
             CPYF       FROMFILE(HWFILE1/AJSWP82) TOFILE(AJSPP40) +
                          FROMMBR(AJSWP82) MBROPT(*REPLACE) +
                          FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817)
             CLRPFM     FILE(AJSPP80)
             CPYF       FROMFILE(HWFILE1/AJSWP84) TOFILE(AJSPP80) +
                          FROMMBR(AJSWP84) MBROPT(*REPLACE) +
                          FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817)

             /* WORK FILE DELETE */
             DLTF       AJSWP82
             DLTF       AJSWP83
             DLTF       AJSWP84
             DLTF       AJSWP85
             DLTF       AJSWP7A

 END:        ENDPGM
