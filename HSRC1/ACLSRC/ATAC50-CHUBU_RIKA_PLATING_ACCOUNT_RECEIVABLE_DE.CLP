             PGM
             /** ATAC50 ************************************/
             /* CHUBU RIKA PLATING ACCOUNT RECEIVABLE DETAILS */
             /*                              86.11.07      */
             /* UPDATE            : MAY.17.'1994.          */
             /* AUTHOR.           : SHINICHIRO.OHTAKE */
             /* USER SECTION. : PLAYTING FACTORY */
             /**********************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CODE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&FIL)  TYPE(*CHAR) LEN(9)
             DCL        VAR(&FIL1) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FIL2) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FIL3) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FIL4) TYPE(*CHAR) LEN(9)
             DCL        VAR(&PARM1) TYPE(*CHAR) LEN(8)
             DCL        VAR(&@SHAKO) TYPE(*CHAR) LEN(1)
             DCL        VAR(&@TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ERLST) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)

             RTVJOBA    JOB(&WSNO) USER(&USER)
      /*     CALL       KZZR00 PARM(&WSNO &PRT &TYPE &PRTG)       */
             CALL       PGM(AGAR01) PARM(&WSNO &PDEVT &PIGCD)
             CALL       AGAR00 PARM(&WSNO &PRT &TYPE &PRTG)
             CHGJOB     RUNPTY(40)

 STEP02:     CHGJOB     OUTQ(&PRTG)
             CHGVAR     VAR(&CODE) VALUE(%SST(&WSNO 1 2))
             CHGVAR     VAR(&FIL)  VALUE(&CODE *CAT 'ATAWP50')
             CHGVAR     VAR(&FIL1) VALUE(&CODE *CAT 'ATAWP52')
             CHGVAR     VAR(&FIL2) VALUE(&CODE *CAT 'ATAWL52')
             CHGVAR     VAR(&FIL3) VALUE(&CODE *CAT 'AJSWP81')
             CHGVAR     VAR(&FIL4) VALUE(&CODE *CAT 'AJSWP86')

             DLTF       FILE(&FIL)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FIL) SRCFILE(ADDSSRC) +
                          SRCMBR(ATAWP50) OPTION(*NOSRC *NOLIST) +
                          SIZE(20000 5000) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(ATAWP50) TOFILE(&FIL)
             CALL       PGM(ATAR50) PARM(&PARM1 &@SHAKO &@TYPE)
             IF  (&@SHAKO  *EQ '9')  DO
       /*    DLTF FILE(&FIL) */
             DLTOVR *ALL
             GOTO       END
             ENDDO

             IF         COND((&@TYPE *EQ '1') *OR (&@TYPE *EQ '3')) +
                          THEN(DO)

             OVRPRTF    FILE(ATAPR51) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(66) OUTQ(QPRINTE) +
                          FORMTYPE(D994) IGCDTA(&PIGCD)
             CALL       PGM(ATAR51) PARM(&PARM1 &@SHAKO)

             ENDDO

             IF         COND((&@TYPE *EQ '2') *OR (&@TYPE *EQ '3')) +
                          THEN(DO)

             DLTF       FILE(&FIL1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FIL1) RCDLEN(128) +
                          OPTION(*NOSRC *NOLIST) SIZE(60000 6000 5) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&FIL2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FIL2) RCDLEN(128) +
                          OPTION(*NOSRC *NOLIST) SIZE(60000 6000 5) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&FIL3)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FIL3) RCDLEN(128) +
                          OPTION(*NOSRC *NOLIST) SIZE(25000 5000) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&FIL4)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FIL4) RCDLEN(128) +
                          OPTION(*NOSRC *NOLIST) SIZE(25000 5000) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(ATAWP52) TOFILE(&FIL1)
             OVRDBF     FILE(AJSWP81) TOFILE(&FIL3)
             OVRDBF     FILE(AJSWP86) TOFILE(&FIL4)

             /* PLATING DISCHARGE DATA RECEIVING INSPECTION DATE MAINTNANCE +
                                              J5UKNY <=(99) */
             /* PLATING MACHINE NO 11 12 13   J5UKNM <=(99) */
             /*            BESIDES 14 15 16   J5UKND <=(99) */
             CALL       PGM(ATAR52) PARM(&PARM1 &@SHAKO &ERLST)

             IF   (&ERLST   *EQ  '1')  DO
                /* PLATING CREDIT SALES DETAILS FOR ERROR  */
                OVRDBF     FILE(AJSWP82) TOFILE(&FIL3)
             OVRPRTF    FILE(AJSPR81) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(64) OUTQ(&PRTG) +
                          FORMTYPE(K6H1) LVLCHK(*NO)

    /* 93.10.04 MAKE COMMENTS  BY IMPROVEMENT SEAT. REQUEST FROM EDP DEPT. */
            /* CALL PGM(AJSR81) PARM(&USER) */
             ENDDO

             FMTDTA     INFILE((HWFILE1/&FIL1)) +
                          OUTFILE(HWFILE1/&FIL2) SRCFILE(FMTSRC) +
                          SRCMBR(ATAS52) OPTION(*NOPRT)
     /***********************************************/
     /* *WORK FILE CREATE FOR UNIT PRICE NO INPUT LIST **/
     /** UPDATE 1994.05.17 S.OHTAKE                **/
     /***********************************************/
             DLTF       FILE(ATAWP55)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/ATAWP55) RCDLEN(100) +
                          OPTION(*NOLIST *NOSRC) LVLCHK(*NO) AUT(*ALL)

             OVRPRTF    FILE(ATAPR53) DEVTYPE(*AFPDS) PAGESIZE(88 +
                          198) LPI(8) CPI(15) OVRFLW(82) +
                          OUTQ(QPRINTA) FORMTYPE(K8H1) COPIES(2)

             OVRDBF     FILE(ATAWL52) TOFILE(&FIL2)
             CALL       PGM(STAR53) PARM(&PARM1 &@SHAKO)
     /**********************************************************/
     /** WORK FILE CREATE FOR UNIT PRICE NO INPUT LIST(AFTER SORT) **/
     /* *                                           * */
     /* * UNIT PRICE NO INPUT LIST CREATE                   * */
     /** UPDATE 1994.05.17 S.OHTAKE                           * */
     /**********************************************************/
             DLTF       FILE(ATAWP56)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/ATAWP56) RCDLEN(100) +
                          OPTION(*NOLIST *NOSRC) LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((HWFILE1/ATAWP55)) +
                          OUTFILE(HWFILE1/ATAWP56) SRCFILE(FMTSRC) +
                          SRCMBR(ATAS56) OPTION(*NOPRT)
             DLTF       FILE(ATAWP55)

             OVRPRTF    FILE(ATAPR55) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(60) OUTQ(&PRTG) +
                          FORMTYPE(K6H1) IGCDTA(&PIGCD)
             CALL       PGM(ATAR55)

             OVRPRTF    FILE(ATAPR56) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(60) OUTQ(QPRINTA) +
                          FORMTYPE(K6H1)
             CALL       PGM(ATAR56)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(64) OUTQ(&PRTG) +
                          FORMTYPE(K6H1) IGCDTA(&PIGCD)
             /*AJSR86 IS CANCELLED BECAUSE AJSR88 WAS CHANGED 94.01.12*/
         /* CALL PGM(AJSR86) PARM(&USER) */
             DLTOVR QPRINT
             /* NEW INSERT 93.04.07 */
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(64) OUTQ(QPRINTQ) +
                          FORMTYPE('ADMITAGAIN') IGCDTA(&PIGCD)
             CALL       PGM(AJSR88) PARM(&USER)
             DLTOVR QPRINT

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(64) OUTQ(&PRTG) +
                          FORMTYPE(K6H1) IGCDTA(&PIGCD)
             CALL       PGM(AJSR87) PARM(&PARM1)
             DLTOVR QPRINT
             ENDDO

    /* DLTF FILE(&FIL) */
             DLTOVR *ALL

 END:        CHGJOB     RUNPTY(20)

             ENDPGM
