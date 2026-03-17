             PGM        PARM(&JOB &USR &NBR &FIL &SF# &OUT &EDT &BCH +
                          &MSG)
       /* SPLC02 *********************************************/
       /* <BATCH> CONVERT SPOOL FILE TO TEXT OR PDF          */
       /* JW      2023.10.17                                 */
       /*--------------------------------------              */
       /* (PARAMETER)                                        */
       /* IN 1. &FIL  10A SPOOL FILE NAME                    */
       /* IN 2. &JOB  10A JOB NAME                           */
       /* IN 3. &USR  10A USER NAME                          */
       /* IN 4. &NBR   6A NUMBER                             */
       /* IN 5. &SF#   6A SPOOL FILE NUMBER                  */
       /* IN 6. &OUT   1A 1=TEXT, 2=PDF                      */
       /* IN 7. &EDT   1A Y=DELETE HEADER, N=KEEP HEADER     */
       /* IN 8. &BCH   1A Y=DELETE BATCH#, N=KEEP BATCH#     */
       /* IN 9. &MSG   1A Y=BREAK MSG, N=NO MSG              */
       /******************************************************/
             DCL        VAR(&FIL)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USR)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&SF#)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&OUT)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&EDT)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&BCH)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSG)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&DIR3) TYPE(*CHAR) LEN(100)

             DCL        VAR(&JOB2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USR2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR2) TYPE(*CHAR) LEN(6)

             RTVJOBA    JOB(&JOB2) USER(&USR2) NBR(&NBR2)

             DLTF       FILE(QTEMP/TXT200 )
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(TXT200) FROMLIB(HFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/TXT200)

             DLTF       FILE(QTEMP/TXT200SV)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(TXT200SV) FROMLIB(HFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/TXT200SV)

             DLTF       FILE(QTEMP/TXTP200 )
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(TXTP200 ) FROMLIB(HFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/TXTP200 )

/* CONVERT SPOOL FILE =============================================*/

             CPYSPLF    FILE(&FIL) TOFILE(QTEMP/TXT200) +
                          JOB(&NBR/&USR/&JOB) SPLNBR(&SF#)

             CPYF       FROMFILE(QTEMP/TXT200  ) +
                          TOFILE(QTEMP/TXT200SV) MBROPT(*REPLACE) +
                          FMTOPT(*NOCHK)
/* EDIT=Y */
             IF         COND(&EDT = 'Y') THEN(DO)
             CALL       PGM(SPLC04)

             CPYF       FROMFILE(QTEMP/TXTP200) +
                          TOFILE(QTEMP/TXT200SV) MBROPT(*REPLACE) +
                          FMTOPT(*NOCHK)
             CPYF       FROMFILE(QTEMP/TXTP200) +
                          TOFILE(QTEMP/TXT200  ) MBROPT(*REPLACE) +
                          FMTOPT(*NOCHK)
             ENDDO

/* BATCH = Y */
             IF         COND(&BCH = 'Y') THEN(DO)
             CALL       PGM(SPLC05)

             CPYF       FROMFILE(QTEMP/TXTP200) +
                          TOFILE(QTEMP/TXT200SV) MBROPT(*REPLACE) +
                          FMTOPT(*NOCHK)
             ENDDO

/* &OUT=1 : EMAIL BY TEXT =========================================*/

             IF         COND(&OUT = '1') THEN(DO)

             OVRDBF     FILE(TXT200) TOFILE(QTEMP/TXT200SV)
             CALL       PGM(AB#RW2)

             IF         COND(&USR2 = 'I0777') THEN(DO)
             SNDDST     TYPE(*FILE) +
                          TOINTNET((KAZ.WATANABE@IAFI.COM)) +
                          DSTD('(D) CONVERT SPOOL') MSG('(M) +
                          CONVERT SPOOL. (SPLC02)') +
                          DOCFILE(QTEMP/TXT200SV) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD('(DD): CONVERT SPOOL') +
                          DOCDATE(*CURRENT) CRTDATE(*CURRENT) +
                          CMPDATE(*CURRENT)
             ENDDO

             IF         COND(&USR2 *EQ 'I0778') THEN(DO)
             SNDDST     TYPE(*FILE) TOINTNET((LARRY.COX@IAFI.COM)) +
                          DSTD('(D) CONVERT SPOOL') MSG('(M) +
                          CONVERT SPOOL. (SPLC02)') +
                          DOCFILE(QTEMP/TXT200SV) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD('(DD): CONVERT SPOOL') +
                          DOCDATE(*CURRENT) CRTDATE(*CURRENT) +
                          CMPDATE(*CURRENT)
             ENDDO

             GOTO       CMDLBL(ENDP)
             ENDDO

/* &OUT=2 : DOWNLOAD TO PDF  ==========================================*/

             IF         COND(&OUT = '2') THEN(DO)
             CHGVAR     VAR(&DIR3) +
                          VALUE('PC(J:)/DOWNLOAD/AS400/SPOOL/SPOOL.PDF')
             RMVLNK     OBJLNK('/QNTC/IAF-AS400-FILE/AS400-TRANS/PC+
                          /DOWNLOAD/AS400/SPOOL/SPOOL.PDF')
             MONMSG     MSGID(CPFA0D4 CPFA0A9)

             OVRDBF     FILE(TXT200 ) TOFILE(QTEMP/TXT200SV)
             CALL       PGM(SPLR06)

             CPYSPLF    FILE(QPRINT) TOFILE(*TOSTMF) +
                          JOB(&NBR2/&USR2/&JOB2) SPLNBR(*LAST) +
                          TOSTMF('/QNTC/IAF-AS400-FILE/AS400-TRANS/PC+
                          /DOWNLOAD/AS400/SPOOL/SPOOL.PDF') +
                          WSCST(*PDF) STMFOPT(*REPLACE)

        /**  CPYSPLF    FILE(&FIL) TOFILE(*TOSTMF) +                     **/
        /**               JOB(&NBR/&USR/&JOB) SPLNBR(&SF#) +             **/
        /**               TOSTMF('/QNTC/IAF-AS400-FILE/AS400-TRANS/PC+   **/
        /**               /DOWNLOAD/AS400/SPOOL/SPOOL.PDF') +            **/
        /**               WSCST(*PDF) STMFOPT(*REPLACE)                  **/

    /*MSG*/
             IF         COND(&MSG *EQ 'Y') THEN(DO)
             SNDBRKMSG  MSG('REPORT HAS BEEN CREATED IN YOUR USER +
                          DIRECTORY' *BCAT &DIR3) TOMSGQ(&JOB2)
             ENDDO
             GOTO       CMDLBL(ENDP)
             ENDDO

ENDP:
             ENDPGM
