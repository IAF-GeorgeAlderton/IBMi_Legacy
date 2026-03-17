             PGM
             /** ATAC95 ************************************/
             DCLF       FILE(ATAPW95)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PARM6) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PARM7) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PARM20) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PARM21) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PARM30) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PARM31) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PARM32) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PARM33) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PGMID)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       AGAR00 PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(ATAPW951)
             IF   (&IN01 *EQ '1' )  GOTO END
             CHGJOB     OUTQ(&PRTG)
             OVRPRTF    FILE(ATAPR95) DEV(PE) PAGESIZE(66 132) LPI(6) +
                          OVRFLW(64) OUTQ(QPRINTE) HOLD(*YES)

             CHGVAR     VAR(&PARM6) VALUE('L')
             CHGVAR     VAR(&PARM7) VALUE('H')
             CHGVAR     VAR(&PARM20) VALUE('20000222')
             CHGVAR     VAR(&PARM21) VALUE('01')
             CHGVAR     VAR(&PARM30) VALUE('00000000')
             CHGVAR     VAR(&PARM31) VALUE('00')
             CHGVAR     VAR(&PARM32) VALUE(' ')
             CHGVAR     VAR(&PARM33) VALUE(' ')
             CHGVAR     VAR(&PGMID)  VALUE('ATAC95')

             CALL       PGM(ATAR95) PARM(&@SHIN1 &@SHIN2 &@SHIN3 +
                          &@HYMD1 &@BIN1 &PARM6 &PARM7 &@HYMD2 +
                          &@BIN2 &PARM20 &PARM21 &PARM30 &PARM31 +
                          &PARM32 &PARM33 &USER &PGMID)

             CHGVAR     VAR(&@HYMD3) VALUE(&PARM20)
             CHGVAR     VAR(&@BIN3)  VALUE(&PARM21)
             CHGVAR     VAR(&@HYMD4) VALUE(&PARM30)
             CHGVAR     VAR(&@BIN4)  VALUE(&PARM31)
             IF   (&PARM33  *NE ' ')  DO
             CHGVAR     VAR(&@ERR) VALUE('納期計算できず')
             CHGVAR     VAR(&IN99) VALUE('1')
             GOTO STP1
             ENDDO
             GOTO STP1

 END:        CHGJOB     OUTQ(&PRT)
             ENDPGM
