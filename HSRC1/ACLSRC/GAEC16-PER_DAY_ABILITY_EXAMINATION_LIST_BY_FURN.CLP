             PGM        PARM(&PARM1)
             /** GAEC16 ************************************/
             /* PER DAY ABILITY EXAMINATION LIST BY FURNACE NO  */
             /*                              87.06.05      */
             /**********************************************/
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&RPY)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PARM1)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PARM2)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&PARM3)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&PARM4)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&PARM5)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&PARM6)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&PARM7)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&PARM8)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&PARM9)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&PARM10) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PARM11) TYPE(*CHAR) LEN(8)
             RTVJOBA    JOB(&WSNO) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSNO &PRT &TYPE &PRTG)

             /*-----------------------------------------------------*/
 STEP02:     CHGJOB     OUTQ(&PRTG)
             CHKOBJ     OBJ(HWFILE1/GAEWP02) OBJTYPE(*FILE)
             MONMSG MSGID(CPF9801) EXEC(GOTO CMDLBL(SP1)) /* +
                          APPLICABLE FILE NO EXIST */
             CLRPFM     FILE(HWFILE1/GAEWP02)
             GOTO       SP2
 SP1:        CRTPF      FILE(HWFILE1/GAEWP02) RCDLEN(59) SIZE(500000 +
                          2000 5) LVLCHK(*NO)

 SP2:        CHKOBJ     OBJ(HWFILE1/GAEWL02) OBJTYPE(*FILE)
             MONMSG MSGID(CPF9801) EXEC(GOTO CMDLBL(SP3)) /* +
                          APPLICABLE FILE NO EXIST */
             CLRPFM     FILE(HWFILE1/GAEWL02)
             GOTO       SP4
 SP3:        CRTPF      FILE(HWFILE1/GAEWL02) RCDLEN(59) SIZE(500000 +
                          2000 5) LVLCHK(*NO)

 SP4:        CHKOBJ     OBJ(HWFILE1/GAEWP03) OBJTYPE(*FILE)
             MONMSG MSGID(CPF9801) EXEC(GOTO CMDLBL(SP5)) /* +
                          APPLICABLE FILE NO EXIST */
             CLRPFM     FILE(HWFILE1/GAEWP03)
             GOTO       SP6
 SP5:        CRTPF      FILE(HWFILE1/GAEWP03) RCDLEN(8) SIZE(10 2 5) +
                          LVLCHK(*NO)

 SP6:        CHGVAR     VAR(&PARM1) VALUE(' ')
             CHGVAR     VAR(&PARM2) VALUE('      ')
             CHGVAR     VAR(&PARM3) VALUE('      ')
             CHGVAR     VAR(&PARM4) VALUE('      ')
             CHGVAR     VAR(&PARM5) VALUE('      ')
             CHGVAR     VAR(&PARM6) VALUE('      ')
             CHGVAR     VAR(&PARM7) VALUE('      ')
             CHGVAR     VAR(&PARM8) VALUE('      ')
             CHGVAR     VAR(&PARM9) VALUE('      ')
             CHGVAR     VAR(&PARM10) VALUE('      ')
             CHGVAR     VAR(&PARM11) VALUE('      ')

             CALL  GAER6A (&PARM1 &PARM2 &PARM3 &PARM4 &PARM5 &PARM6 +
                           &PARM7 &PARM8 &PARM9 &PARM10 &PARM11)

            IF (&PARM1 *EQ  '9') GOTO END
            IF (&PARM1 *EQ  'M') GOTO END

             CALL  GAER16 (&PARM1 &PARM2 &PARM3 &PARM4 &PARM5 &PARM6 +
                           &PARM7 &PARM8 &PARM9 &PARM10 &PARM11)

             FMTDTA     INFILE((HWFILE1/GAEWP02)) +
                          OUTFILE(HWFILE1/GAEWL02) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(GAES16) +
                          OPTION(*NOPRT)

             OVRDBF     FILE(GAEWL02) TOFILE(HWFILE1/GAEWL02)

             OVRPRTF    FILE(GAEPR17) PAGESIZE(66 132) LPI(6) +
                          OVRFLW(64) OUTQ(&PRTG) FORMTYPE(K6H1)
             CALL  GAER17 (&PARM1 &PARM2 &PARM3 &PARM4 &PARM5 &PARM6 +
                           &PARM7 &PARM8 &PARM9 &PARM10 &PARM11)

 ENDMA:      DLTOVR     FILE(*ALL)
 END:        CHGJOB     OUTQ(&PRT)

    /* DLTF FILE(GAEWP02) */
             MONMSG     MSGID(CPF3261 CPF2105)
    /* DLTF FILE(GAEWL02) */
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(GAEWP03)
             MONMSG     MSGID(CPF3261 CPF2105)
             ENDPGM
