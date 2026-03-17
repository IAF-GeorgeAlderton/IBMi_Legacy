             PGM
             /** GCQC85 **********************************************/
             /*  DIE SETTING# INQUIRY                                */
             /*----------+-----+---------+---------------------------*/
             /*2022.05.12|TEC. |T.MITSUI | 22047  INITIAL VERSION.   */
             /********************************************** GCQC85 **/
             DCL        VAR(&WSID)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3)      TYPE(*CHAR) LEN(3)
             DCL        VAR(&USER)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRNT)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&DEVT)     TYPE(*CHAR) LEN(6)
             DCL        VAR(&IGCD)     TYPE(*CHAR) LEN(4)

             DCL        VAR(&DARA)     TYPE(*CHAR) LEN(8)
             DCL        VAR(&BASE)     TYPE(*DEC)  LEN(6 0)
             DCL        VAR(&EXTR)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&DISP)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&CND1)     TYPE(*CHAR) LEN(2)
             DCL        VAR(&CND2)     TYPE(*CHAR) LEN(2)

             DCL        VAR(&WLIB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&SLIB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&SRCF)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&GCQWP86)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&GCQWP87)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&GCQWP88)  TYPE(*CHAR) LEN(10)

 #STEP01:    /*======================================================*/
             /*    PROCESSING PREPARATION                            */
             /*======================================================*/
             RTVJOBA    JOB(&WSID)     USER(&USER)
             CHGVAR     VAR(&WS3)      VALUE(%SST(&WSID 1 3))
             CALL       PGM(AGAR01)    PARM(&WSID &DEVT &IGCD)
             CALL       PGM(AGAR00)    PARM(&WSID &PRNT &TYPE &PRTG)
             CHGVAR     VAR(&WLIB)     VALUE('HWFILE1   ')
             CHGVAR     VAR(&SLIB)     VALUE('HSRC1     ')
             CHGVAR     VAR(&SRCF)     VALUE('ADDSSRC   ')

             RTVDTAARA  DTAARA(MCEDP01 (1 8)) RTNVAR(&DARA)
             CHGVAR     VAR(&BASE)     VALUE(0)
             CHGVAR     VAR(&EXTR)     VALUE(' ')
             CHGVAR     VAR(&DISP)     VALUE(' ')
             CHGVAR     VAR(&CND1)     VALUE('00')

 #STEP02:    /*======================================================*/
             /*    SPECIFY CONDITIONS                                */
             /*======================================================*/
             CALL       PGM(GCQR85) +
                        PARM(&DARA &BASE &EXTR &DISP &CND1)

             IF         COND(&CND1 *EQ '01') THEN(GOTO CMDLBL(#STEP99))
             IF         COND(&CND1 *EQ '00') THEN(GOTO CMDLBL(#STEP03))
             GOTO       CMDLBL(#STEP02)

 #STEP03:    /*======================================================*/
             /*    DIE INFORMATION DATA CREATE (1)                   */
             /*======================================================*/
             CHGVAR     VAR(&GCQWP86) VALUE('GCQWP86' *CAT &WS3)
             DLTF       FILE(&WLIB/&GCQWP86)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&GCQWP86) +
                        SRCFILE(&SLIB/&SRCF) SRCMBR(GCQWP86) +
                        OPTION(*NOLIST *NOSRC) +
                        SIZE(*NOMAX) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(GCQWP86) TOFILE(&WLIB/&GCQWP86)
             CALL       PGM(GCQR86) +
                        PARM(&BASE &EXTR &DISP)
             DLTOVR     FILE(GCQWP86)

 #STEP04:    /*======================================================*/
             /*    DIE INFORMATION DATA CREATE (2)                   */
             /*======================================================*/
             CHGVAR     VAR(&GCQWP87) VALUE('GCQWP87' *CAT &WS3)
             DLTF       FILE(&WLIB/&GCQWP87)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&GCQWP87) +
                        SRCFILE(&SLIB/&SRCF) SRCMBR(GCQWP87) +
                        OPTION(*NOLIST *NOSRC) +
                        SIZE(*NOMAX) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(GCQWP86) TOFILE(&WLIB/&GCQWP86)
             OVRDBF     FILE(GCQWP87) TOFILE(&WLIB/&GCQWP87)
             CALL       PGM(GCQR87) +
                        PARM(&BASE &EXTR &DISP)
             DLTOVR     FILE(GCQWP86)
             DLTOVR     FILE(GCQWP87)

 #STEP05:    /*======================================================*/
             /*    CALCULATE THE NUMBER OF SHEETS                    */
             /*======================================================*/
             CHGVAR     VAR(&GCQWP88) VALUE('GCQWP88' *CAT &WS3)
             DLTF       FILE(&WLIB/&GCQWP88)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&GCQWP88) +
                        SRCFILE(&SLIB/&SRCF) SRCMBR(GCQWP88) +
                        OPTION(*NOLIST *NOSRC) +
                        SIZE(*NOMAX) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(GCQWP87) TOFILE(&WLIB/&GCQWP87)
             OVRDBF     FILE(GCQWP88) TOFILE(&WLIB/&GCQWP88)
             CALL       PGM(GCQR88) +
                        PARM(&BASE &EXTR &DISP)
             DLTOVR     FILE(GCQWP87)
             DLTOVR     FILE(GCQWP88)

 #STEP06:    /*======================================================*/
             /*    INQUIRY DISPLAY                                   */
             /*======================================================*/
             OVRDBF     FILE(GCQWP88) TOFILE(&WLIB/&GCQWP88)
             CALL       PGM(GCQR89) +
                        PARM(&BASE &EXTR &DISP &CND2)
             DLTOVR     FILE(GCQWP88)

             IF         COND(&CND2 *EQ '01') THEN(GOTO CMDLBL(#STEP99))
             IF         COND(&CND2 *EQ '03') THEN(GOTO CMDLBL(#STEP02))
             GOTO       CMDLBL(#STEP06)

 #STEP99:    /*======================================================*/
             /*    END OF JOB                                        */
             /*======================================================*/
             ENDPGM

