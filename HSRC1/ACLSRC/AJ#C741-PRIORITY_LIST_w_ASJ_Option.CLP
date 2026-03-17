             PGM
             /** AJ#C74 **********************************/
             /* PRIORITY LIST                            */
             /*  ITS.            2015.05.12              */
             /* JW1    2021.06.21 CHG AJ#PP40 TO QTEMP   */
             /********************** COPY FROM AH#C74 ****/
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDEVT)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&AJ#WP74) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&#@OUTQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0) VALUE(0)

             DCL        VAR(&ASJ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)

/* TCHK3 */  OVRDBF     FILE(AGDPP11) TOFILE(HFILE1/A@DPP11)
/* TCHK3 */  OVRDBF     FILE(AGDPL11) TOFILE(HFILE1/A@DPL11)
/* TCHK3 */  OVRDBF     FILE(AGDPL12) TOFILE(HFILE1/A@DPL12)

             RTVJOBA    JOB(&WS) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WS 1 3))

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHGVAR     VAR(&AJ#WP74) VALUE('AJ#WP74' *CAT &WS3)
             CHGVAR     VAR(&WLIB   ) VALUE('TWFILE1 ')

 STP1:       CHGJOB     OUTQ(&PRTG)
        /*               */
             DLTF       FILE(QTEMP/AH#WP30A)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AH#WP30A) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AH#WP30) OPTION(*NOLIST *NOSRC) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(QTEMP/AH#WP30B)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AH#WP30B) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AH#WP30) OPTION(*NOLIST *NOSOURCE) +
                          LVLCHK(*NO) AUT(*ALL)

/* TCHK4 */  CRTDUPOBJ  OBJ(AH#WP70) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
/* TCHK4 */  MONMSG     MSGID(CPF0000)
/* TCHK4 */  CLRPFM QTEMP/AH#WP70
/* TCHK4 */  OVRDBF     FILE(AH#WP70) TOFILE(QTEMP/AH#WP70)

/* TCHK1 */  CRTDUPOBJ  OBJ(AH#WP74) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
/* TCHK1 */  MONMSG     MSGID(CPF0000)
/* TCHK1 */  CLRPFM QTEMP/AH#WP74
/* TCHK1 */  OVRDBF     FILE(AH#WP74) TOFILE(QTEMP/AH#WP74)

       /*    CLRPFM     FILE(TWFILE1/AH#PP70X)    */
/* TCHK2     CRTDUPOBJ  OBJ(AH#PP70X) FROMLIB(&WLIB) OBJTYPE(*FILE) + */
/* TCHK2                  TOLIB(QTEMP)                                */
/* TCHK2     MONMSG     MSGID(CPF0000)                                */
/* TCHK2     CLRPFM QTEMP/AH#PP70X                                    */
/* TCHK2     OVRDBF     FILE(AH#PP70X) TOFILE(QTEMP/AH#PP70X)         */

              DLTF       FILE(TWFILE1/AH#WP74S)
              MONMSG     MSGID(CPF3261 CPF2105)
              CRTPF      FILE(TWFILE1/AH#WP74S) RCDLEN(128) +
                           OPTION(*NOLIST) SIZE(10000 3000) +
                           LVLCHK(*NO) AUT(*ALL)

              DLTF       FILE(TWFILE1/AH#WP74T)
              MONMSG     MSGID(CPF3261 CPF2105)
              CRTPF      FILE(TWFILE1/AH#WP74T) RCDLEN(128) +
                           OPTION(*NOLIST) SIZE(10000 3000) +
                           LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&WLIB/&AJ#WP74)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AJ#WP74) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AJ#WP74) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 5000 3) LVLCHK(*NO) AUT(*ALL)
       /* INVENTORY FILE */
       /*JW1 CLRPFM     FILE(AJ#PP40)          */
       /*JW1*/
             DLTF       FILE(QTEMP/AJ#PP40)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ OBJ(AJ#PP40) FROMLIB(HFILE1) OBJTYPE(*FILE) TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             OVRDBF     FILE(AJ#PP40) TOFILE(QTEMP/AJ#PP40 )

         /*  CALL       PGM(AJ#R40)   */

             OVRPRTF    FILE(QPRINT) SAVE(*YES)

             OVRDBF     FILE(AJ#WP74 ) TOFILE(&WLIB/&AJ#WP74)
             OVRDBF     FILE(AH#WP74T) TOFILE(TWFILE1/AH#WP74T)
             OVRDBF     FILE(AH#WP74S) TOFILE(TWFILE1/AH#WP74S)
         /***CALL       PGM(AJ#R74 ) PARM(&#@OUTQ)***/
             CALL       PGM(AJ#R741) PARM(&#@OUTQ &ASJ)

             RTVMBRD    FILE(&WLIB/&AJ#WP74) NBRCURRCD(&REC)
             IF         COND(&REC *NE 0) THEN(DO)
             OVRDBF     FILE(AJ#WP74) TOFILE(&WLIB/&AJ#WP74)
             CALL       PGM(AJ#C75) PARM(&#@OUTQ)
             ENDDO

 /* SEND REPORT TO ASJ */
             IF         COND(&ASJ *EQ 'Y') THEN(DO)
             CALL       PGM(SNDC10)
             ENDDO

             DLTOVR     FILE(*ALL)


 END:        CHGJOB     RUNPTY(20)

             ENDPGM
