             PGM
             /*** ABAC75 ***************************************/
             /*       内示数異常変動リスト                   */
             /*         MSK.KUNIEDA         1998.02.18         */
             /*************************************** ABAC74 ***/
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&HENDOU) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SHND)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&EHND)   TYPE(*CHAR) LEN(6)
             RTVDTAARA  DTAARA(ABAC74DAT) RTNVAR(&HENDOU)
             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGJOB     OUTQ(&PRTG)

             CHGVAR     VAR(&SHND) VALUE(%SST(&HENDOU 1 3))
             CHGVAR     VAR(&EHND) VALUE(%SST(&HENDOU 4 3))

             DLTF       FILE(APWRKLIB/ABAWP75)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(APWRKLIB/ABAWP75) RCDLEN(128) +
                          TEXT('ﾏｰﾅﾞｰobﾆﾞﾇc eeﾌﾌﾞﾞciﾞ] +
                          kｩｮhﾑcﾎｦbﾓ') OPTION(*NOLIST) SIZE(*NOMAX) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(APWRKLIB/ABAWP76)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(APWRKLIB/ABAWP76) RCDLEN(128) +
                          TEXT('ﾏｰﾅﾞｰobﾆﾞﾇc eeﾌﾌﾞﾞciﾞ] +
                          kｩｮhﾑcﾎｦbﾓ') OPTION(*NOLIST) SIZE(*NOMAX) +
                          LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(ABAR75) PARM(&SHND &EHND)

             FMTDTA     INFILE((ABAWP75)) OUTFILE(ABAWP76) +
                          SRCFILE(SRCLIB/FMTSRC) SRCMBR(ABAS75) +
                          OPTION(*NOPRT)

             CHGJOB     OUTQ(&PRTG)
             OVRPRTF    FILE(ABAPR76) PAGESIZE(66 156) LPI(6) +
                          OVRFLW(62) OUTQ(QPRINT3) HOLD(*YES) +
                          SAVE(*YES)
             CALL       PGM(ABAR76) PARM(&SHND &EHND &USER)

             DLTF       FILE(APWRKLIB/ABAWP75)
             DLTF       FILE(APWRKLIB/ABAWP76)

             DLTOVR     FILE(*ALL)
             ENDPGM
