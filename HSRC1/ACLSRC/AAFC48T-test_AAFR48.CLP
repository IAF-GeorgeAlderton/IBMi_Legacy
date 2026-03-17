             PGM
             /** AAFC48T******************************************/
             DCL        VAR(&WS)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&US)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&NO)    TYPE(*DEC)  LEN(1) VALUE(0)
             DCL        VAR(&PNO)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WS) USER(&US)

             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)
             CALL       PGM(AGAR01) PARM(&WS &PDEVT &PIGCD)
             CALL       PGM(ALBC00) PARM(&US &WLIB)

             CHGVAR     VAR(&NO ) VALUE('2')
             CHGVAR     VAR(&PNO) VALUE('1')

      /**    OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +            **/
      /**                 RPLUNPRT(*YES) ALIGN(*YES) OUTQ(&PRTG) +       **/
      /**                 FORMTYPE(@627) MAXRCDS(*NOMAX) IGCDTA(&PIGCD)  **/

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(88 +
                          132) LPI(8) CPI(5) RPLUNPRT(*YES) +
                          ALIGN(*YES) OUTQ(LANPRT03) FORMTYPE(@627) +
                          IGCDTA(&PIGCD)

             OVRPRTF    FILE(QPRINTS) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) ALIGN(*YES) OUTQ(LANPRT03) +
                          FORMTYPE(@972) MAXRCDS(*NOMAX) IGCDTA(&PIGCD)

      /***   OVRDBF     FILE(AAFWP48) TOFILE(HWFILE1/AAFWP48X)   ***/

             OVRDBF     FILE(AAFWP48) TOFILE(TWFILE1/AAFWP48 )

             CALL       PGM(AAFR48O) PARM(&US &NO &PNO)

             DLTOVR     FILE(QPRINT)
             DLTOVR     FILE(QPRINTS)
             DLTOVR     FILE(*ALL)

             ENDPGM
