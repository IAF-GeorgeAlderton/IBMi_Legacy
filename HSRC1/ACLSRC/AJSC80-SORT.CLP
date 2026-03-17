         PGM
         /*------------------------------------------------*/
         /*BZ OF FA PLATING HANDLING                     */
         /* MSK: K.KUNIEDA                                 */
         /* 91.01.28          VER. 1.0                     */
         /*------------------------------------------------*/
         DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
         DCL        VAR(&WSNO)  TYPE(*CHAR) LEN(10)
         DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
         DCL        VAR(&RPY)   TYPE(*CHAR) LEN(1)
         DCL        VAR(&PGMNO) TYPE(*CHAR) LEN(6)
         DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
         DCL        VAR(&MBAN)  TYPE(*CHAR) LEN(4)
         DCL        VAR(&TYPE)  TYPE(*CHAR)  LEN(1)
         DCL        VAR(&CAN1)  TYPE(*CHAR)  LEN(1)
         DCL        VAR(&CAN)   TYPE(*CHAR)  LEN(1)
         DCL        VAR(&GOKEI) TYPE(*CHAR)  LEN(1)
         DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
         DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)

         RTVJOBA    JOB(&WSNO) USER(&USER)

         CALL       PGM(AGAR01) PARM(&WSNO &PDEVT &PIGCD)
         CALL       AGAR00 PARM(&WSNO &PRT &TYPE &PRTG)

         CHGJOB     OUTQ(&PRTG) RUNPTY(40)

         CHKOBJ     OBJ(AJSWP81) OBJTYPE(*FILE)
         MONMSG MSGID(CPF9801) EXEC(GOTO CMDLBL(STEP01)) /* +
                        APPLICABLE FILE NO EXIST */
         CLRPFM     FILE(AJSWP81)
         GOTO       STEP02

 STEP01: CRTPF      FILE(HWFILE1/AJSWP81) RCDLEN(064) +
                          SIZE(*NOMAX) LVLCHK(*NO)

 STEP02: CHKOBJ     OBJ(AJSWP82) OBJTYPE(*FILE)
         MONMSG MSGID(CPF9801) EXEC(GOTO CMDLBL(STEP03)) /* +
                        APPLICABLE FILE NO EXIST */
         CLRPFM     FILE(AJSWP82)
         GOTO       STEP04

 STEP03: CRTPF      FILE(HWFILE1/AJSWP82) RCDLEN(128) +
                          SIZE(*NOMAX) LVLCHK(*NO)

 STEP04: CHGVAR     VAR(&CAN) VALUE('9')
         CHGVAR     VAR(&CAN1) VALUE('9')
         CALL       PGM(AJSR80) PARM(&USER &CAN &CAN1 &GOKEI)
    /*   IF (&CAN1 *EQ '9') GOTO MEISAI                           */

        /* ERROR LIST */
     /*      OVRPRTF    FILE(AJSPR81) PAGESIZE(66 132) LPI(6) +
                                  OVRFLW(64) OUTQ(&PRTG) +
                          FORMTYPE(K6H1) LVLCHK(*NO)               */

    /* 93.10.04 MAKE COMMENTS BY IMPROVEMENT SEAT. REQUEST FROM EDP DEPT.  */
    /* CALL PGM(AJSR81) PARM(&USER) */

 MEISAI:     CHKOBJ    OBJ(AJSWL81) OBJTYPE(*FILE)
             MONMSG MSGID(CPF9801) EXEC(GOTO CMDLBL(STEP1X)) /* +
                           APPLICABLE FILE NO EXIST */
             CLRPFM     FILE(AJSWL81)
             GOTO       STEP2X

 STEP1X:     CRTPF      FILE(HWFILE1/AJSWL81) RCDLEN(064) +
                          SIZE(*NOMAX) LVLCHK(*NO)

 STEP2X:     IF (&CAN *EQ '9') GOTO END
             IF (&GOKEI *EQ 'G')  GOTO SHUKEI
             /* SORT */
             FMTDTA     INFILE((HWFILE1/AJSWP81)) +
                          OUTFILE(HWFILE1/AJSWL81) SRCFILE(FMTSRC) +
                          SRCMBR(AJSS82) OPTION(*NOPRT)

             /* TOTALIZATION LIST */
             OVRPRTF    FILE(AJSPR82) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(64) OUTQ(&PRTG) +
                          FORMTYPE(K6H1) IGCDTA(&PIGCD) LVLCHK(*NO)

             CALL       PGM(AJSR82) PARM(&USER)
             GOTO   END
SHUKEI:      CLRPFM     AJSWL81
             FMTDTA     INFILE((HWFILE1/AJSWP81)) +
                          OUTFILE(HWFILE1/AJSWL81) SRCFILE(FMTSRC) +
                          SRCMBR(AJSS83) OPTION(*NOPRT)

             /* TOTALIZATION LIST */
             OVRPRTF    FILE(AJSPR83) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(60) OUTQ(&PRTG) +
                          FORMTYPE(K6H1) IGCDTA(&PIGCD) LVLCHK(*NO)

             CALL       PGM(AJSR83) PARM(&USER)

END:     CHGJOB     OUTQ(&PRT)
         DLTOVR *ALL

         CHGJOB     RUNPTY(20)

         ENDPGM
