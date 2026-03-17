 PGM
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NO) TYPE(*DEC) LEN(1) VALUE(0)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PNO) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)

             RTVJOBA    JOB(&WS) USER(&US)

             CALL       PGM(AGAR01) PARM(&WS &PDEVT &PIGCD)

             OVRDBF     FILE(AAFWP49) TOFILE(TSKWP02)

/* TCHK2 */  OVRPRTF    FILE(AAFPR50) DEVTYPE(*SCS) PAGESIZE(66 +
                          132) LPI(6)                 +
                          OUTQ(SAKASITA) FORMTYPE(@972) +
                          MAXRCDS(*NOMAX)

             CALL       PGM(AAFR50)

 ENDPGM
