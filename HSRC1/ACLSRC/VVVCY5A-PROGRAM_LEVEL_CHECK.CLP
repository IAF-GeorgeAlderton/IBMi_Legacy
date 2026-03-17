             PGM
             /** VVVCY5A *********************************/
             /* PROGRAM LEVEL CHECK                      */
             /* JW   2026.02.05                          */
             /********************************************/

             DCL        VAR(&WSID)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS)       TYPE(*CHAR) LEN(2)
             DCL        VAR(&PRT)      TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&IAFWFILE) TYPE(*CHAR) LEN(10) VALUE('HWFILE1   ')
             DCL        VAR(&VVVWPY5)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&REC)      TYPE(*DEC)  LEN(10 0)

             DCL        VAR(&SYS)      TYPE(*CHAR) LEN(10)
             DCL        VAR(&PARM1)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&PARM2)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&PARM3)    TYPE(*CHAR) LEN(8)
             DCL        VAR(&PARM4)    TYPE(*CHAR) LEN(52)
             DCL        VAR(&PARM5)    TYPE(*CHAR) LEN(2)
             DCL        VAR(&PTODI1)   TYPE(*CHAR) LEN(200) +
                          VALUE('C:/AS400/DATA/IAFPGMLEVEL.CSV')


 $STEP01:    /*==================================================*/
             /*         RETRIEVE JOB INFORMATION                 */
             /*==================================================*/
             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 2))

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)


 $STEP02:    /*==================================================*/
             /*         CREATE CSV DATA                          */
             /*==================================================*/
             CHGVAR     VAR(&VVVWPY5) VALUE('VVVWPY5' *CAT &WS)
             DLTF       FILE(&IAFWFILE/&VVVWPY5)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&IAFWFILE/&VVVWPY5) RCDLEN(1024) +
                        IGCDTA(*YES) OPTION(*NOLIST *NOSRC) +
                        SIZE(500 5000 3) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(VVVWPY5) TOFILE(&VVVWPY5)
             CALL       PGM(VVVRY5A) PARM(&
             DLTOVR     FILE(VVVWPY5)

             RTVMBRD    FILE(&IAFWFILE/&VVVWPY5) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(GOTO CMDLBL($STEP99))

 $STEP03:    /*==================================================*/
             /*         CSV DATA TRANSFER < ABHPP01 >            */
             /*==================================================*/
             RTVNETA    SYSNAME(&SYS)
             CHGVAR     VAR(&PARM1) VALUE(&IAFWFILE)
             CHGVAR     VAR(&PARM2) VALUE(&VVVWPY5)
             CHGVAR     VAR(&PARM3) VALUE(&SYS)
             CHGVAR     VAR(&PARM4) VALUE(&PTODI1)
             CHGVAR     VAR(&PARM5) VALUE(' 1')
             CALL       PGM(APLC98) +
                        PARM(&PARM1 &PARM2 &PARM3 &PARM4 &PARM5)

             EDTDTA     FILE(&VVVWPY5)


 $STEP99:
             ENDPGM
