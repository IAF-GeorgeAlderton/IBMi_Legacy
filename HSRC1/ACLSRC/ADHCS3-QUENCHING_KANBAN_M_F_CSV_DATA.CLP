             PGM
             /** ADHCS3 ************************************/
             /* QUENCHING KANBAN M/F  ----> CSV DATA       */
             /*  2015.09.15                                */
             /* JW1   2020.08.14 CHG TO USE QTEMP  FOR WORK FILES */
             /**********************************************/
             DCL        VAR(&SYS)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WT)    TYPE(*CHAR) LEN(3)
             DCL        VAR(&REC)   TYPE(*DEC)  LEN(10 0)

             DCL        VAR(&@LIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WPS3)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WPS4)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&@HOST) TYPE(*CHAR) LEN(8)
             DCL        VAR(&@SAVE) TYPE(*CHAR) LEN(52)
             DCL        VAR(&@TYPE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)

             RTVNETA    SYSNAME(&SYS)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

             CHGVAR     VAR(&WT) VALUE(%SST(&WSID 1 3))
             CHGVAR     VAR(&WPS3) VALUE('ADHWPS3   ')
             CHGVAR     VAR(&WPS4) VALUE('ADHWPS4   ')

     /*JW1** DLTF       FILE(&WLIB/&WPS3)      ***/
             DLTF       FILE(QTEMP/&WPS3)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/&WPS3) RCDLEN(2048) +
                          OPTION(*NOLIST) SIZE(10000 3000) +
                          LVLCHK(*NO) AUT(*ALL)

     /*JW1** DLTF       FILE(&WLIB/&WPS4)      ***/
             DLTF       FILE(QTEMP/&WPS4)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/&WPS4) RCDLEN(2048) +
                          OPTION(*NOLIST) SIZE(10000 3000) +
                          LVLCHK(*NO) AUT(*ALL)

      /** ADHWPS3 **/
      /*JW1* OVRDBF     FILE(ADHWPS3) TOFILE(&WLIB/&WPS3) **/
             OVRDBF     FILE(ADHWPS3) TOFILE(QTEMP/&WPS3)
             CALL       PGM(ADHRS3)
             CALL       PGM(ADHRS4)
             CALL       PGM(CADRS7)
             DLTOVR     FILE(ADHWPS3)

      /** ADHWPS4 **/
      /*JW1* OVRDBF     FILE(ADHWPS3) TOFILE(&WLIB/&WPS4)  ***/
             OVRDBF     FILE(ADHWPS3) TOFILE(QTEMP/&WPS4)
             CALL       PGM(ADHRS5)
             CALL       PGM(ADHRS6)
             CALL       PGM(CADRS8)
             DLTOVR     FILE(ADHWPS3)

             /*JW1 SAVE WORK FILES TO TWFILE1 **/
             CPYF       FROMFILE(QTEMP/ADHWPS3) +
                          TOFILE(HWFILE1/ADHWPS3) MBROPT(*REPLACE) +
                          FMTOPT(*NOCHK)
             CPYF       FROMFILE(QTEMP/ADHWPS3) +
                          TOFILE(TWFILE1/ADHWPS3) MBROPT(*REPLACE) +
                          FMTOPT(*NOCHK)

             CPYF       FROMFILE(QTEMP/ADHWPS4) +
                          TOFILE(HWFILE1/ADHWPS4) MBROPT(*REPLACE) +
                          FMTOPT(*NOCHK)
             CPYF       FROMFILE(QTEMP/ADHWPS4) +
                          TOFILE(TWFILE1/ADHWPS4) MBROPT(*REPLACE) +
                          FMTOPT(*NOCHK)

             IF         COND(&WT *NE 'HPI' *AND &WT *NE 'V#I') THEN(DO)
             GOTO       CMDLBL(@END)
             ENDDO

             RTVMBRD    FILE(HWFILE1/&WPS3)  NBRCURRCD(&REC)
             IF         COND(&REC *NE 0) THEN(DO)

             CHGVAR     VAR(&@LIBL) VALUE('HWFILE1')
             CHGVAR     VAR(&@HOST) VALUE(&SYS)
             CHGVAR     VAR(&@SAVE) VALUE('C:/AS400/DATA/ADHWPS3.CSV')
             CHGVAR     VAR(&@TYPE) VALUE(' 1')
             CALL       PGM(APLC98) PARM(&@LIBL &WPS3 &@HOST &@SAVE +
                          &@TYPE)
             ENDDO

             RTVMBRD    FILE(HWFILE1/&WPS4)  NBRCURRCD(&REC)
             IF         COND(&REC *NE 0) THEN(DO)

             CHGVAR     VAR(&@LIBL) VALUE('HWFILE1')
             CHGVAR     VAR(&@HOST) VALUE(&SYS)
             CHGVAR     VAR(&@SAVE) VALUE('C:/AS400/DATA/ADHWPS4.CSV')
             CHGVAR     VAR(&@TYPE) VALUE(' 1')
             CALL       PGM(APLC98) PARM(&@LIBL &WPS4 &@HOST &@SAVE +
                          &@TYPE)
             ENDDO

@END:
             ENDPGM
