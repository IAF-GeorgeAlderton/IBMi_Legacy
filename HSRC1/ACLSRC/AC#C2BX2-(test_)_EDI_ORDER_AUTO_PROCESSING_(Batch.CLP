             PGM
             /** AC#C2B *******************************************/
             /*  HONDA EDI ORDER AUTO PROCESSING (BATCH)          */
             /*  J.WATANABE 2018.11.26                            */
             /*                                                   */
             /*****************************************************/
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)

             DCL        VAR(&DATE1) TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&TODAY) TYPE(*CHAR) LEN(8)
             DCL        VAR(&RTN0 ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SIGN ) TYPE(*CHAR) LEN(1) VALUE('+')
             DCL        VAR(&DAYS ) TYPE(*CHAR) LEN(4) VALUE('0001')
             DCL        VAR(&IAF  ) TYPE(*CHAR) LEN(1) VALUE('Y')

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

   /**       DLTF       FILE(QTEMP/AB#WP46)                                  */
   /**       MONMSG     MSGID(CPF3261 CPF2105)                               */
   /**  CRTDUPOBJ  OBJ(AB#WP46) FROMLIB(HWFILE1) OBJTYPE(*FILE) TOLIB(QTEMP) */
   /**  OVRDBF     FILE(AB#WP46 ) TOFILE(QTEMP/AB#WP46)                      */

/* TEST */
             CLRPFM     FILE(HWFILE1/AB#WP55)
             MONMSG     MSGID(CPF3261 CPF2105)

             CPYF       FROMFILE(HFILE1/AB#PPCT) +
                          TOFILE(TFILE1/AB#PPCT) MBROPT(*REPLACE) +
                          FMTOPT(*NOCHK)
             OVRDBF     FILE(AB#PPCT ) TOFILE(TFILE1/AB#PPCT)

             CLRPFM     FILE(TWFILE1/AB#WP2B )
             MONMSG     MSGID(CPF3261 CPF2105)
/* PROCESS ORDER */
             CHGVAR     VAR(&TODAY) VALUE('        ')
             OVRDBF     FILE(AB#WP2B ) TOFILE(TWFILE1/AB#WP2B)

             CALL       PGM(AC#R2BT) PARM(&TODAY &RTN0)

             CPYF       FROMFILE(*LIBL/AB#WP55) +
                          TOFILE(*LIBL/AB#WP55S) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)
             MONMSG     MSGID(CPC2957)

 END:        ENDPGM
