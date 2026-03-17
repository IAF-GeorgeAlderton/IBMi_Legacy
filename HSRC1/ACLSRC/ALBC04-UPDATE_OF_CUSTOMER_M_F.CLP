             PGM
             /** ALBC04 ********************/
             /* UPDATE OF CUSTOMER M/F     */
             /*     A.IDOTA   90.09.22     */
             /******************** ALBC04 **/
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PM) TYPE(*CHAR) LEN(2)
             DCL        VAR(&ABADS1) TYPE(*CHAR) LEN(48)
             DCL        VAR(&FLA4) TYPE(*CHAR) LEN(9)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WS) USER(&US)
             RTVDTAARA  DTAARA(ABADS1) RTNVAR(&ABADS1)
             CHGVAR     VAR(&PM) VALUE(%SST(&ABADS1 5 2))

             CALL       PGM(AGAR01) PARM(&WS &PDEVT &PIGCD)

             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)

             CALL       PGM(ALBC00) PARM(&US &WLIB)

 /* ﾝｰhﾎｦbﾓ ﾉ ﾅhﾈb */
             CHGVAR     VAR(&FLA4) VALUE('ALBWPA4' *CAT (%SST(&WS 1 +
                          2)))

             DLTF       FILE(&FLA4)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FLA4) RCDLEN(100) +
                          OPTION(*NOLIST *NOSRC) SIZE(5000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)


 /* f]ﾌﾞ]uﾇjｰ & kｩｮhuﾇjｰ ﾅhﾈb */
             OVRDBF     FILE(ALBWPA4) TOFILE(&FLA4)
             CALL       PGM(ALBR04)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) OVRFLW(60) +
                          OUTQ(&PRTG) FORMTYPE(K6S1) HOLD(*YES) +
                          IGCDTA(&PIGCD)
             CALL       PGM(ALBR05) PARM(&US &PM)
             DLTOVR     FILE(*ALL)

   /*        DLTF       FILE(&FLA4)   */

             ENDPGM
