PGM
             /**** APPC10 *****************************************/
             /* WINMERGE                                          */
             /* T.SAKASHITA                                       */
             /*****************************************************/
             DCLF       FILE(APPPW10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)

             DCL        VAR(&@LIB1) TYPE(*CHAR) LEN(10) VALUE('SRCLIB')
             DCL        VAR(&@SRC1) TYPE(*CHAR) LEN(10) VALUE('TCLSRC ')
             DCL        VAR(&@MBR1) TYPE(*CHAR) LEN(10) VALUE('TPSC20')

             DCL        VAR(&@LIB2) TYPE(*CHAR) LEN(10) VALUE('SRCLIBHON')
             DCL        VAR(&@SRC2) TYPE(*CHAR) LEN(10) VALUE('TCLSRC ')
             DCL        VAR(&@MBR2) TYPE(*CHAR) LEN(10) VALUE('TPSC20')

             DCL        VAR(&LIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&HOST) TYPE(*CHAR) LEN(8)
             DCL        VAR(&SAVE) TYPE(*CHAR) LEN(52)
             DCL        VAR(&SAVE2) TYPE(*CHAR) LEN(52)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SYS) TYPE(*CHAR) LEN(8)

             DCL        VAR(&FLG) TYPE(*CHAR) LEN(2)

             RTVJOBA    JOB(&WSID)
             RTVNETA    SYSNAME(&SYS)
 @DSP1:
             SNDRCVF    DEV(&WSID) RCDFMT(APPPW101)

             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(@EXIT))

             CALL       PGM(APPC01) PARM(&@LIB1 &@SRC1 &@MBR1 &FLG)
             IF         COND(&FLG *EQ 'NG') THEN(GOTO CMDLBL(@DSP1))

             CALL       PGM(APPC01) PARM(&@LIB2 &@SRC2 &@MBR2 &FLG)
             IF         COND(&FLG *EQ 'NG') THEN(GOTO CMDLBL(@DSP1))

             DLTF       FILE(HWFILE1/APPWP01)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/APPWP01) RCDLEN(512) IGCDTA(*YES)

             CPYF       FROMFILE(&@LIB1/&@SRC1) +
                          TOFILE(HWFILE1/APPWP01) FROMMBR(&@MBR1) +
                          MBROPT(*REPLACE) FMTOPT(*CVTSRC)

             CHGVAR     VAR(&LIBL) VALUE('HWFILE1')
             CHGVAR     VAR(&FILE) VALUE('APPWP01')
             CHGVAR     VAR(&HOST) VALUE(&SYS)
             CHGVAR     VAR(&SAVE) VALUE('C:/AS400/DATA/APPWP01.TXT')
             CHGVAR     VAR(&TYPE) VALUE(' 1')

             CALL       PGM(APLC98) PARM(&LIBL &FILE &HOST &SAVE +
                          &TYPE)

             DLTF       FILE(HWFILE1/APPWP02)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/APPWP02) RCDLEN(512) IGCDTA(*YES)

             CPYF       FROMFILE(&@LIB2/&@SRC2) +
                          TOFILE(HWFILE1/APPWP02) FROMMBR(&@MBR2) +
                          MBROPT(*REPLACE) FMTOPT(*CVTSRC)

             CHGVAR     VAR(&LIBL) VALUE('HWFILE1')
             CHGVAR     VAR(&FILE) VALUE('APPWP02')
             CHGVAR     VAR(&HOST) VALUE(&SYS)
             CHGVAR     VAR(&SAVE2) VALUE('C:/AS400/DATA/APPWP02.TXT')
             CHGVAR     VAR(&TYPE) VALUE(' 1')

             CALL       PGM(APLC98) PARM(&LIBL &FILE &HOST &SAVE2 +
                          &TYPE)

             STRPCO     PCTA(*NO)
             MONMSG     MSGID(CPF0000)
             STRPCCMD   PCCMD('"C:/PROGRAM +
                          FILES/WINMERGE/WINMERGEU.EXE"' *BCAT &SAVE +
                          *BCAT &SAVE2) PAUSE(*YES)

             GOTO       CMDLBL(@DSP1)

 @EXIT:
             ENDPGM
