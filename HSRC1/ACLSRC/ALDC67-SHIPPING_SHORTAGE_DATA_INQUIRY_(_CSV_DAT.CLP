             PGM
             /** ALDC67 ********************************************/
             /* SHIPPING SHORTAGE DATA INQUIRY (+ CSV DATA)        */
             /*  KIRI                            2018.02.06        */
             /* ---------------------                              */
             /* JW1     2018.02.07 ADD APLC96 (IFS TRANSFER)       */
             /******************************************************/
             DCL        VAR(&SYS)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WT)    TYPE(*CHAR) LEN(3)
             DCL        VAR(&REC)   TYPE(*DEC)  LEN(10 0)

             DCL        VAR(&@LIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&@FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&@HOST) TYPE(*CHAR) LEN(8)
             DCL        VAR(&@SAVE) TYPE(*CHAR) LEN(52)
             DCL        VAR(&@TYPE) TYPE(*CHAR) LEN(2)

             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&I1  )  TYPE(*CHAR) LEN(1)

             RTVNETA    SYSNAME(&SYS)
             RTVJOBA    JOB(&WSID) USER(&USER)

     /*--------------------------*/
     /*    CHECK ENVIRONMENT     */
     /*--------------------------*/
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

             CHGVAR     VAR(&@FILE) VALUE('ALDWP67' *CAT %SST(&WSID 1 3))

             DLTF       FILE(&WLIB/&@FILE)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&@FILE) RCDLEN(1024) +
                          OPTION(*NOLIST) SIZE(10000 3000) +
                          LVLCHK(*NO) AUT(*ALL)


             OVRDBF     FILE(ALDWP67) TOFILE(&WLIB/&@FILE)
             CALL       PGM(ALDR67)
             DLTOVR     FILE(ALDWP67)

             RTVMBRD    FILE(&WLIB/&@FILE)  NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(GOTO CMDLBL(@END))

             CHGVAR     VAR(&@LIBL) VALUE(&WLIB)
             CHGVAR     VAR(&@HOST) VALUE(&SYS)
             CHGVAR     VAR(&@SAVE) VALUE('C:/AS400/DATA/ALDWP67.CSV')
             CHGVAR     VAR(&@TYPE) VALUE(' 1')

    /* JW1 SKIP IF USER ID IS FOR IAF MEMBER */
             CHGVAR     VAR(&I1) VALUE(%SST(&USER 1 1))
             IF         COND((&I1 *NE 'I') *OR (&USER *EQ 'I0029')) +
                          THEN(DO)
             CALL       PGM(APLC98) PARM(&@LIBL &@FILE &@HOST &@SAVE +
                          &@TYPE)
             ENDDO

    /* JW1 IFS TRANSFER */
             IF         COND((&USER *NE 'I0029')) THEN(DO)
             CPYF       FROMFILE(&@LIBL/&@FILE) TOFILE(&@LIBL/FILE1024) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)
             CALL       PGM(APLC94) PARM('1' 'FILE1024' 'HWFILE1' +
                          'SHIPPING SHORTAGE' 'Y' ' ' 'Y')
             ENDDO

@END:
             ENDPGM
