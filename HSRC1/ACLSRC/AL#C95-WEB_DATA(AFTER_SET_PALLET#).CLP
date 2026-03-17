             PGM
             /** AL#C95 *********************************************/
             /*  WEB DATA((AFTER SET PALLET#)                       */
             /*  ITS.  2015.05.29                                   */
             /*  JW1   2021.10.12 CHG OUTOUT TO DIRECTORY J:        */
             /*******************************************************/
             DCL        VAR(&WSID)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPUSER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)    TYPE(*CHAR) LEN(10)
         /***DCL        VAR(&PDEVT)   TYPE(*CHAR) LEN(6)    ***/
         /***DCL        VAR(&PIGCD)   TYPE(*CHAR) LEN(4)    ***/
             DCL        VAR(&REC)     TYPE(*DEC) LEN(10 0)
             DCL        VAR(&WLIB)    TYPE(*CHAR) LEN(8)
             DCL        VAR(&FLIB)    TYPE(*CHAR) LEN(8)
             DCL        VAR(&DDATE)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&PCMD)    TYPE(*CHAR) LEN(2)
             DCL        VAR(&AL#WP96) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3)     TYPE(*CHAR) LEN(3)
             DCL        VAR(&P1ISS1)  TYPE(*DEC) LEN(8 0)
             DCL        VAR(&P1ISS2)  TYPE(*DEC) LEN(8 0)
             DCL        VAR(&P1SHI1)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&P1SHI2)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&P1SURT)  TYPE(*CHAR) LEN(9)
             DCL        VAR(&MSGTXT)  TYPE(*CHAR) LEN(256)
             DCL        VAR(&PKINP)   TYPE(*CHAR) LEN(5)
             DCL        VAR(&PKOUT)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&AL#WP9A) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FNAME)   TYPE(*CHAR) LEN(30)

             RTVJOBA    JOB(&WSID) USER(&PPUSER) DATE(&DDATE)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO

             CHGVAR     VAR(&AL#WP96) VALUE('AL#WP96' *CAT &WS3)
             CHGVAR     VAR(&AL#WP9A) VALUE('AL#WP9A' *CAT &WS3)
             CHGJOB     OUTQ(&PRTG)
 #STP10:
             CALL       PGM(AL#R90) PARM(&P1ISS1 &P1ISS2 &P1SHI1 +
                          &P1SHI2 &P1SURT &PCMD)

             IF         COND(&PCMD *EQ '01') THEN(DO)
             GOTO       CMDLBL(ENDP)
             ENDDO
/* STEP2 */
             DLTF       FILE(&WLIB/&AL#WP96)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AL#WP96) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AL#WP96) OPTION(*NOLIST *NOSRC) +
                          SIZE(1000000 5000 3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AL#WP96) TOFILE(&WLIB/&AL#WP96)

             CALL       PGM(AL#R96) PARM(&P1ISS1 &P1ISS2 &P1SHI1 +
                          &P1SHI2 &P1SURT &PCMD)
             RTVMBRD    FILE(&WLIB/&AL#WP96) NBRCURRCD(&REC)

             IF         COND(&REC *EQ 0) THEN(DO)
             CHGVAR     VAR(&MSGTXT) VALUE('THERE ARE NO INQ DATA (G)')
             CHGVAR     VAR(&PKINP) VALUE('G    ')
             CHGVAR     VAR(&PKOUT) VALUE(' ')
             CALL       PGM(APLR90) PARM(&MSGTXT &PKINP &WSID &PKOUT)
             GOTO       CMDLBL(#STP10)
             ENDDO

             IF         COND(&PCMD *EQ '07') THEN(DO)
             GOTO       CMDLBL(#STP40)
             ENDDO
 /* STEP3 */
             CALL       PGM(AL#R97) PARM(&PCMD)
             GOTO       CMDLBL(#STP10)

 /* F7: DOWNLOAD */
 #STP40:
             DLTF       FILE(&WLIB/&AL#WP9A)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AL#WP9A) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AL#WP9A) OPTION(*NOLIST *NOSRC) +
                          SIZE(1000000 5000 3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AL#WP9A) TOFILE(&WLIB/&AL#WP9A)
             CALL       PGM(AL#R9A)

             STRPCO     PCTA(*NO)
             MONMSG     MSGID(CPF0000 IWS4010)
             STRPCCMD   PCCMD('"C:/PROGRAM FILES/IBM/CLIENT +
                          ACCESS/RTOPCB.EXE" +
                          C:/AS400/TTO/TOYOTAORDER.DTF') PAUSE(*NO)

 /* JW1 ADD */
             DLTF       FILE(QTEMP/AL#WP9B)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AL#WP9B) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AL#WP9B) OPTION(*NOLIST *NOSRC) +
                          SIZE(1000000 5000 3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AL#WP9B) TOFILE(QTEMP/AL#WP9B)
             CALL       PGM(AL#R9C)
             CHGVAR     VAR(&FNAME) VALUE('WEB DATA (AFT SET PALLET#)')
             CALL       PGM(APLC94) PARM('2' AL#WP9B QTEMP &FNAME +
                          'Y' ' ' 'Y')

        /*** GOTO       CMDLBL(#STP10) ***/
             GOTO       CMDLBL(ENDP)

 ENDP:
             ENDPGM
