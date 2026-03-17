             PGM
            /** ECSC7X **********************************************/
            /*  PRINT DIE STORE LABEL ( FROM DIE INVENTOTU FILE )   */
            /*          2018.04.04        KIRI                      */
            /********************************************************/
             DCL        VAR(&WSID)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRNT)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&DEVT)     TYPE(*CHAR) LEN(6)
             DCL        VAR(&IGCD)     TYPE(*CHAR) LEN(4)
             DCL        VAR(&WS3)      TYPE(*CHAR) LEN(3)

             DCL        VAR(&OUTR)     TYPE(*DEC)  LEN(5 0)
             DCL        VAR(&FRLB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&FRFL)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&HOST)     TYPE(*CHAR) LEN(8)
             DCL        VAR(&TOFL)     TYPE(*CHAR) LEN(52)
             DCL        VAR(&TOFT)     TYPE(*CHAR) LEN(2)
/*JW1*/      DCL        VAR(&DIR)   TYPE(*CHAR) LEN(100)
/*JW1*/      DCL        VAR(&DIR2)  TYPE(*CHAR) LEN(100)

             DCL        VAR(&ECSWP73)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&REC)      TYPE(*DEC)  LEN(10 0)
/*JW1*/      DCL        VAR(&FILE)  TYPE(*CHAR) LEN(50)

             ADDLIBLE   LIB(TLABARCODE)
             MONMSG     MSGID(CPF0000)

 #STEP01:   /*======================================================*/
            /*    PROCESS PREPARATION                               */
            /*======================================================*/
             RTVJOBA    JOB(&WSID)     USER(&USER)
             CALL       PGM(AGAR01)    PARM(&WSID &DEVT &IGCD)
             CALL       PGM(AGAR00)    PARM(&WSID &PRNT &TYPE &PRTG)

             CHGVAR     VAR(&WS3)     VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&FILE) VALUE('LABELPRINTDATA.TXT')
             CHGVAR     VAR(&DIR) +
                          VALUE('QNTC/IAF-AS400-FILE/AS400-TRANS/P+
                          C/Download/TOOLROOM')
             CHGVAR     VAR(&DIR2) VALUE(&DIR *TCAT '/' *TCAT &FILE)
      /* CREATE DIRECTRY */
             CRTDIR     DIR(&DIR )
             MONMSG     MSGID(CPFA0A0)
             MONMSG     MSGID(CPFA0A9)


 #STEP02:   /*======================================================*/
            /*    PRINT DIE STORE LABEL ( INSTRUCTION )             */
            /*======================================================*/
             CHGVAR     VAR(&ECSWP73) VALUE('ECSWP73' *CAT &WS3)
             DLTF       FILE(&ECSWP73)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&ECSWP73) +
                        SRCFILE(HSRC1/ADDSSRC) SRCMBR(ECSWP73) +
                        OPTION(*NOLIST *NOSRC) +
                        SIZE(*NOMAX) LVLCHK(*NO)

             OVRDBF     FILE(ECSWP73) TOFILE(&ECSWP73)
             CALL       PGM(ECSR7X)
             DLTOVR     FILE(ECSWP73)


             RTVMBRD    FILE(HWFILE1/&ECSWP73) NBRCURRCD(&REC)
             IF         COND(&REC = 0) THEN(GOTO CMDLBL(#STEP99))


 #STEP03:   /*======================================================*/
            /*    PRINT DIE STORE LABEL ( TRANSFER DATA CREATE )    */
            /*======================================================*/
             DLTF       FILE(ECSWP74)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/ECSWP74) RCDLEN(256) +
                        OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO)

             OVRDBF     FILE(ECSWP73) TOFILE(&ECSWP73)
             CALL       PGM(ECSR74)
             DLTOVR     FILE(ECSWP73)


 #STEP04:   /*======================================================*/
            /*    DATA TRANSFER                                     */
            /*======================================================*/

      /* COPY 0 RECORD */
             CPYTOIMPF  FROMFILE(HWFILE1/ECSWP74) TOSTMF(&DIR2) +
                          MBROPT(*REPLACE) FROMCCSID(5026) +
                          STMFCCSID(*STDASCII) RCDDLM(*CRLF) +
                          STRDLM(*NONE) RMVBLANK(*BOTH)
             MONMSG     MSGID(CPF2817)

            /* CALL PROGRAM TO PRINT LABELS VIA TL ASHFORD                 */
             CALL       PGM(RPRR74)


 #STEP99:   /*======================================================*/
            /*    FINAL PROCESSING                                  */
            /*======================================================*/

             RMVLIBLE   LIB(TLABARCODE)
             MONMSG     MSGID(CPF0000)

             ENDPGM

