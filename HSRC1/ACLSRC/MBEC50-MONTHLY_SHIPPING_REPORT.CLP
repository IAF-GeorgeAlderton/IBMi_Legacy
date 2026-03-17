             PGM
             /*** MBEC50 ******************************************/
             /*   MONTHLY SHIPPING REPORT                         */
             /*   KIRI 15.07.14                                   */
             /*   T.SAKAKI 15.07.27  ADD  SENDING MAIL WITH CSV   */
             /*****************************************************/

             DCL        VAR(&WSID)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)      TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS01)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&IAFWFILE) TYPE(*CHAR) LEN(10) +
                                                   VALUE('HWFILE1   ')
             DCL        VAR(&MBEWP50)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&REC)      TYPE(*DEC)  LEN(10 0)

             DCL        VAR(&SYS)      TYPE(*CHAR) LEN(10)
             DCL        VAR(&PARM1)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&PARM2)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&PARM3)    TYPE(*CHAR) LEN(8)
             DCL        VAR(&PARM4)    TYPE(*CHAR) LEN(52)
             DCL        VAR(&PARM5)    TYPE(*CHAR) LEN(2)

        /*SEND MAIL SET */
             DCL        VAR(&TO1)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&SUB)  TYPE(*CHAR) LEN(30)
             DCL        VAR(&FNAME)  TYPE(*CHAR) LEN(30)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&WS01) VALUE(%SST(&WSID 1 1))

             CHGVAR     VAR(&TO1) VALUE('KAZUKI.KOBAYASHI@IAFI.COM')
             CHGVAR     VAR(&SUB) VALUE('MONTHLY SHIPPING REPORT ' +
                          *CAT &USER)
             CHGVAR     VAR(&FNAME) +
                          VALUE('MONTHLY-SHIPPING-REPORT.CSV')

 $STEP01:    /*==================================================*/
             /*    GET JOB INFORMATION                           */
             /*==================================================*/

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             IF         COND(&USER *EQ 'TEST') THEN(DO)
             CHGVAR     VAR(&IAFWFILE) VALUE('TWFILE1')
             ENDDO

 $STEP02:    /*==================================================*/
             /*      CREATE CSV DATA                             */
             /*==================================================*/
             CHGVAR     VAR(&MBEWP50) VALUE('MBEWP50')
             DLTF       FILE(&IAFWFILE/&MBEWP50)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&IAFWFILE/&MBEWP50) RCDLEN(256) +
                        IGCDTA(*YES) OPTION(*NOLIST *NOSRC) +
                        SIZE(9999 5000 3) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(MBEWP50) TOFILE(&MBEWP50)
             CALL       PGM(MBER50) PARM(&TO1)
             DLTOVR     FILE(MBEWP50)

             RTVMBRD    FILE(&IAFWFILE/&MBEWP50) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(GOTO CMDLBL($STEP99))

             CHGVAR     VAR(&PARM1) VALUE(&IAFWFILE)
             CHGVAR     VAR(&PARM2) VALUE(&MBEWP50)

             GOTO       CMDLBL($STEP04)

 $STEP03:    /*==================================================*/
             /*   TRANSFER CSV DATA     < ABHPP01 >            */
             /*==================================================*/
             RTVNETA    SYSNAME(&SYS)
             CHGVAR     VAR(&PARM3) VALUE(&SYS)
             CHGVAR     VAR(&PARM4) +
                          VALUE('C:/AS400/DATA/MBEWP50.CSV')

             CHGVAR     VAR(&PARM5) VALUE(' 1')
             CALL       PGM(APLC98) +
                        PARM(&PARM1 &PARM2 &PARM3 &PARM4 &PARM5)

             /*　FOR P-COM ------------------------------------*/
             IF         COND((&WS01 *EQ 'Y') *OR +
                             (&WS01 *EQ 'W') *OR +
                             (&WS01 *EQ 'Z') *OR +
                             (&WS01 *EQ 'Q')) THEN(DO)
             STRPCO     PCTA(*NO)
             MONMSG     MSGID(CPF0000)
             STRPCCMD   PCCMD('"C:/PROGRAM FILES/PERSONAL +
                          COMMUNICATIONS/PCSFT5.EXE" +
                          C:/AS400/TTO/MBEWP50.TTO') PAUSE(*NO)
             ENDDO

 $STEP04:    /*==================================================*/
             /*     SEND MAIL WITH CSV DATA                      */
             /*==================================================*/
             CALL       PGM(APLC30) PARM(&TO1 &SUB &PARM1 &PARM2 +
                          &FNAME)

 $STEP99:
             ENDPGM
