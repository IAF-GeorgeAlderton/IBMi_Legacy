             PGM        PARM(&P@NTYM &PRTG@)
             /** ABMC34 ************************/
             /*設定数変更リストNON A-PICS          */
             /*   HOTTA.           2018.09.14  */
             /*つるべST ONEWAY 対応　改善シート21061 */
             /*   Y.MAEDA          2021.09.24  */
             /**********************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&FLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&DDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&P@NTYM) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&P@ERR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&ABMWP32) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ABMWP34C) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ABMWP34E) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ABMWP34A) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ABMWP34B) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ABMWP343) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ABMWP34T) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&FNAM)  TYPE(*CHAR) LEN(30)
             DCL        VAR(&FNAMC) TYPE(*CHAR) LEN(30) VALUE('ST +
                          KANBAN SET# CHANGE LIST')
             DCL        VAR(&FNAME) TYPE(*CHAR) LEN(30) VALUE('WITHD +
                          KANBAN SET# CHANGE LIST')
             DCL        VAR(&FNAMA) TYPE(*CHAR) LEN(30) VALUE('PROD +
                          KANBAN SET# CHECK LIST')
             DCL        VAR(&FNAMB) TYPE(*CHAR) LEN(30) VALUE('OQ +
                          KANBAN SET# CHANGE LIST')
             DCL        VAR(&FNAM3) TYPE(*CHAR) LEN(30) +
                          VALUE('WASEHR KANBAN SET# CHECK LIST')
             DCL        VAR(&FNAMT) TYPE(*CHAR) LEN(30) VALUE('ST +
                          ONEWAY SET# CHANGE LIST')
             DCL        VAR(&PRTG@) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ABMWPI8) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID) USER(&PPUSER) DATE(&DDATE)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO
             CHGVAR     VAR(&ABMWP32) VALUE('ABMWP32')
             CHGVAR     VAR(&ABMWP34C) VALUE('ABMWP34C')
             CHGVAR     VAR(&ABMWP34E) VALUE('ABMWP34E')
             CHGVAR     VAR(&ABMWP34A) VALUE('ABMWP34A')
             CHGVAR     VAR(&ABMWP34B) VALUE('ABMWP34B')
             CHGVAR     VAR(&ABMWP343) VALUE('ABMWP343')
             CHGVAR     VAR(&ABMWP34T) VALUE('ABMWP34T')
             CHGVAR     VAR(&ABMWPI8) VALUE('ABMWPI8')

 STP10:
         /*設定数変更リストA-PICS  */
             DLTF       FILE(&WLIB/&ABMWP32)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&ABMWP32) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ABMWP32) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 5000 20) LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&WLIB/&ABMWPI8)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&ABMWPI8) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ABMWPI8) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 5000 20) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(ABMWP32) TOFILE(&WLIB/&ABMWP32)
             CALL       PGM(ABMR32) PARM(&P@NTYM '0' &FNAM)
             CPYF       FROMFILE(&ABMWP32) TOFILE(&ABMWPI8) +
                          MBROPT(*REPLACE) FMTOPT(*MAP *DROP)

     /*メッキ*/
             DLTF       FILE(&ABMWP34C)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&ABMWP34C) RCDLEN(0256) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)
             OVRDBF     FILE(ABMWP32) TOFILE(&WLIB/&ABMWP32)
             OVRDBF     FILE(ABMWP34) TOFILE(&WLIB/&ABMWP34C)
             CALL       PGM(ABMR34) PARM('C')
             CALL       PGM(APLC96) PARM('1' &ABMWP34C &WLIB +
                          &FNAMC 'Y' ' ')
             OVRDBF     FILE(ABMWP32) TOFILE(&WLIB/&ABMWP32)
             OVRPRTF    FILE(ABMPRI4) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&PRTG@) FORMTYPE(K6H1) IGCDTA(&PIGCD)
             CALL       PGM(ABMRI9) PARM('C' &FNAMC)
     /*メッキつるべ*/
             DLTF       FILE(&ABMWP34T)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&ABMWP34T) RCDLEN(0256) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)
             OVRDBF     FILE(ABMWP32) TOFILE(&WLIB/&ABMWP32)
             OVRDBF     FILE(ABMWP34) TOFILE(&WLIB/&ABMWP34T)
             CALL       PGM(ABMR39) PARM('C')
             CALL       PGM(APLC96) PARM('1' &ABMWP34T &WLIB +
                          &FNAMT 'Y' ' ')
             OVRDBF     FILE(ABMWP32) TOFILE(&WLIB/&ABMWP32)
             OVRPRTF    FILE(ABMPRI4) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&PRTG@) FORMTYPE(K6H1) IGCDTA(&PIGCD)
             CALL       PGM(ABMRI9) PARM('T' &FNAMT)

     /*工程内*/
             DLTF       FILE(&ABMWP34A)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&ABMWP34A) RCDLEN(0256) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)
             OVRDBF     FILE(ABMWP32) TOFILE(&WLIB/&ABMWP32)
             OVRDBF     FILE(ABMWP34) TOFILE(&WLIB/&ABMWP34A)
             CALL       PGM(ABMR34) PARM('A')
             CALL       PGM(APLC96) PARM('1' &ABMWP34A &WLIB +
                          &FNAMA 'Y' ' ')
             OVRDBF     FILE(ABMWP32) TOFILE(&WLIB/&ABMWP32)
             OVRPRTF    FILE(ABMPRI4) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&PRTG@) FORMTYPE(K6H1) IGCDTA(&PIGCD)
             CALL       PGM(ABMRI4) PARM('A' &FNAMA)

     /*焼入れ*/
             DLTF       FILE(&ABMWP34B)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&ABMWP34B) RCDLEN(0256) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)
             OVRDBF     FILE(ABMWP32) TOFILE(&WLIB/&ABMWP32)
             OVRDBF     FILE(ABMWP34) TOFILE(&WLIB/&ABMWP34B)
             CALL       PGM(ABMR34) PARM('B')
             CALL       PGM(APLC96) PARM('1' &ABMWP34B &WLIB +
                          &FNAMB 'Y' ' ')
             OVRDBF     FILE(ABMWP32) TOFILE(&WLIB/&ABMWP32)
             OVRPRTF    FILE(ABMPRI4) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&PRTG@) FORMTYPE(K6H1) IGCDTA(&PIGCD)
             CALL       PGM(ABMRI4) PARM('B' &FNAMB)

     /*構成品*/
             DLTF       FILE(&ABMWP343)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&ABMWP343) RCDLEN(0256) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)
             OVRDBF     FILE(ABMWPI8) TOFILE(&WLIB/&ABMWPI8)
             OVRDBF     FILE(ABMWP34) TOFILE(&WLIB/&ABMWP343)
             CALL       PGM(ABMR38)
             CALL       PGM(APLC96) PARM('1' &ABMWP343 &WLIB +
                          &FNAM3 'Y' ' ')
             OVRDBF     FILE(ABMWPI8) TOFILE(&WLIB/&ABMWPI8)
             OVRPRTF    FILE(ABMPRI8) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&PRTG@) FORMTYPE(K6H1) IGCDTA(&PIGCD)
             CALL       PGM(ABMRI8)
 #END:
 END:        ENDPGM
