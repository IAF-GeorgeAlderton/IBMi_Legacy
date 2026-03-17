             PGM
             /** ADHCS3 ************************************/
             /* QUENCHING KANBAN M/F  ----> CSV DATA       */
             /*                                            */
             /*  2015.09.15                                */
             /**********************************************/
             DCL        VAR(&SYS)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WT)    TYPE(*CHAR) LEN(3)
             DCL        VAR(&REC)   TYPE(*DEC)  LEN(10 0)

             DCL        VAR(&@LIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&@FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&@HOST) TYPE(*CHAR) LEN(8)
             DCL        VAR(&@SAVE) TYPE(*CHAR) LEN(52)
             DCL        VAR(&@TYPE) TYPE(*CHAR) LEN(2)

             RTVNETA    SYSNAME(&SYS)
             RTVJOBA    JOB(&WSID)

             CHGVAR     VAR(&WT) VALUE(%SST(&WSID 1 3))
             CHGVAR     VAR(&@FILE) VALUE('ADHWPS3   ')

             DLTF       FILE(HWFILE1/&@FILE)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&@FILE) RCDLEN(2014) +
                          OPTION(*NOLIST) SIZE(10000 3000) +
                          LVLCHK(*NO) AUT(*ALL)


             OVRDBF     FILE(ADHWPS3) TOFILE(HWFILE1/&@FILE)
             CALL       PGM(ADHRS3)
             DLTOVR     FILE(ADHWPS3)


             RTVMBRD    FILE(HWFILE1/&@FILE)  NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(GOTO CMDLBL(@END))

             CHGVAR     VAR(&@LIBL) VALUE('HWFILE1')
             CHGVAR     VAR(&@HOST) VALUE(&SYS)
             CHGVAR     VAR(&@SAVE) VALUE('C:/AS400/DATA/ADHWPS3.CSV')
             CHGVAR     VAR(&@TYPE) VALUE(' 1')
             CALL       PGM(APLC98) PARM(&@LIBL &@FILE &@HOST &@SAVE +
                          &@TYPE)
@END:
             ENDPGM
