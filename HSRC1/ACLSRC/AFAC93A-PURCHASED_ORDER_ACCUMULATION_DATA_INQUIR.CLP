             PGM
             /***AFAC93A ***************************************/
             /* PURCHASED ORDER ACCUMULATION DATA INQUIRY      */
             /*  ( PRODUCTE)                                   */
             /* MSK KUNIEDA   2000.12.12                       */
             /*---------------------------                     */
             /* TCHK1 04/24/06 ADD DOWNLOAD FILE(MULTI MENBER) */
             /* JW    2025.02.14 D DOWNLOAD FILE(QTEMP)        */
             /**************************************************/
             DCL        VAR(&MODE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&HIN1)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&HIN2)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&HIN3)  TYPE(*CHAR) LEN(2)
             DCL        VAR(&SDAT)  TYPE(*CHAR) LEN(8)

             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3)   TYPE(*CHAR) LEN(3)
             DCL        VAR(&FNAM ) TYPE(*CHAR) LEN(30)
             DCL        VAR(&REC  ) TYPE(*DEC ) LEN(10 0)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CHGVAR     VAR(&WS3) VALUE(%SUBSTRING(&WSID 1 3))

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

/* AFAWP93 */
             CHKOBJ     OBJ(HWFILE1/AFAWP93) OBJTYPE(*FILE) MBR(&WS3)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM +
                          FILE(HWFILE1/AFAWP93) MBR(&WS3))
             CLRPFM     FILE(HWFILE1/AFAWP93) MBR(&WS3)

/* AFAWP93A */
             DLTF       FILE(QTEMP/AFAWP93A )
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTDUPOBJ  OBJ(AFAWP93A) FROMLIB(HWFILE1) +
                          OBJTYPE(*FILE) TOLIB(QTEMP)
             CLRPFM     FILE(QTEMP/AFAWP93A)

             OVRDBF     FILE(AFAWP93)  TOFILE(HWFILE1/AFAWP93) MBR(&WS3)
             OVRDBF     FILE(AFAWP93A) TOFILE(QTEMP/AFAWP93A)

             CALL  PGM(AFAR93A) PARM(&USER &MODE &HIN1 &HIN2 &HIN3 &SDAT)

 /* DOWNLOAD TO CSV */
             RTVMBRD    FILE(QTEMP/AFAWP93A) NBRCURRCD(&REC)
             IF         COND(&REC *NE 0) THEN(DO)
             CHGVAR     VAR(&FNAM) VALUE('PURCHASE ORDER DATA')
             CALL       PGM(APLC94) PARM('2' 'AFAWP93A' 'QTEMP' &FNAM +
                          'Y' ' ' 'Y')
             ENDDO

             ENDPGM
