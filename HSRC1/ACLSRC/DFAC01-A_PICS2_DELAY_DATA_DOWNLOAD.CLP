             PGM

             /** DFAC01 **********************************************/
             /* 指示かんばん工程納期遅れ照会                       */
             /*  2024.09.20   M.OKUMURA                              */
             /********************************************** DFAC01 **/

             DCL        VAR(&WSID)    TYPE(*CHAR)  LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR)  LEN(10)
             DCL        VAR(&PRNT)    TYPE(*CHAR)  LEN(7)
             DCL        VAR(&TYPE)    TYPE(*CHAR)  LEN(1)
             DCL        VAR(&PRTG)    TYPE(*CHAR)  LEN(10)
             DCL        VAR(&WS3)     TYPE(*CHAR)  LEN(3)

             DCL        VAR(&NDTF)    TYPE(*DEC)   LEN(8 0)
             DCL        VAR(&NDTT)    TYPE(*DEC)   LEN(8 0)
             DCL        VAR(&COND)    TYPE(*CHAR)  LEN(2)
             DCL        VAR(&CNTR)    TYPE(*DEC)   LEN(7 0)
             DCL        VAR(&@RTN)    TYPE(*CHAR)  LEN(1)
             DCL        VAR(&DFAWP02) TYPE(*CHAR)  LEN(10)
             DCL        VAR(&DFAWP03) TYPE(*CHAR)  LEN(10)
             DCL        VAR(&FNAM) TYPE(*CHAR) LEN(30)


 $STEP01:    /*======================================================*/
             /*    処理準備                                        */
             /*======================================================*/
             RTVJOBA    JOB(&WSID)    USER(&USER)
             CALL       PGM(AGAR00)   PARM(&WSID &PRNT &TYPE &PRTG)
             CHGVAR     VAR(&WS3)     VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&NDTF)    VALUE(0)
             CHGVAR     VAR(&NDTT)    VALUE(0)
             CHGVAR     VAR(&COND)    VALUE('00')


 $STEP02:    /*======================================================*/
             /*   条件指定                                         */
             /*======================================================*/
             CALL       PGM(DFAR01)   +
                        PARM(&NDTF &NDTT &COND)

             IF         COND(&COND *EQ '01') THEN(GOTO CMDLBL($STEP99))
             IF         COND(&COND *EQ '05') THEN(GOTO CMDLBL($STEP03))
             GOTO       CMDLBL($STEP02)


 $STEP03:    /*======================================================*/
             /*   対象データ抽出                                   */
             /*======================================================*/
             CHGVAR     VAR(&DFAWP02) VALUE('DFAWP02' *CAT &WS3)
             DLTF       FILE(&DFAWP02)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&DFAWP02) +
                        SRCFILE(HSRC1/ADDSSRC) SRCMBR(DFAWP02) +
                        OPTION(*NOLIST *NOSRC) +
                        SIZE(*NOMAX) LVLCHK(*NO)

             CHGVAR     VAR(&CNTR)    VALUE(0)
             OVRDBF     FILE(DFAWP02) TOFILE(&DFAWP02)
             CALL       PGM(DFAR02)   +
                        PARM(&NDTF &NDTT &CNTR)
             DLTOVR     FILE(DFAWP02)

             IF         COND(&CNTR *EQ 0) +
             THEN(DO)
                 CHGVAR     VAR(&COND)    VALUE('99')
             ENDDO
             IF         COND(&COND *EQ '05') THEN(GOTO CMDLBL($STEP04))
             GOTO       CMDLBL($STEP02)

 $STEP04:    /*======================================================*/
             /*   ＣＳＶデータ作成                                 */
             /*======================================================*/
             CHGVAR     VAR(&DFAWP03) VALUE('DFAWP03' *CAT &WS3)
             DLTF       FILE(&DFAWP03)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&DFAWP03) RCDLEN(1024) +
                        IGCDTA(*YES) OPTION(*NOLIST *NOSRC) +
                        SIZE(10000 1000 3) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(DFAWP02) TOFILE(&DFAWP02)
             OVRDBF     FILE(DFAWP03) TOFILE(&DFAWP03)
             CALL       PGM(DFAR03)   +
                        PARM(&@RTN)
             DLTOVR     FILE(DFAWP02)
             DLTOVR     FILE(DFAWP03)


 $STEP05:    /*======================================================*/
             /*   ＣＳＶデータ転送                                 */
             /*======================================================*/
             CHGVAR     VAR(&FNAM) VALUE('APICS2 DELAY')
             CALL       PGM(APLC94) PARM('1' &DFAWP03 'HWFILE1' &FNAM +
                          'Y' ' ' 'Y')

             GOTO       CMDLBL($STEP02)


 $STEP99:    /*======================================================*/
             /*    終　　了                                        */
             /*======================================================*/
             ENDPGM

