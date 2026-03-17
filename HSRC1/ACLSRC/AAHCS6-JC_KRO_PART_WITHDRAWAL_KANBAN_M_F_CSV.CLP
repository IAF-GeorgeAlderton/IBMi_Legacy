             PGM
             /** AAHCS6 ************************************/
             /*  JC/KRO  PART WITHDRAWAL KANBAN M/F.-> CSV */
             /*  JC/KRO  PLATING KANBAN M/F ----> CSV DATA */
             /*  KIRI                            2015.09.24*/
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
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)

             RTVNETA    SYSNAME(&SYS)
             RTVJOBA    JOB(&WSID)

             CHGVAR     VAR(&WT) VALUE(%SST(&WSID 1 3))
             CHGVAR     VAR(&@FILE) VALUE('AAHWPS6   ')

             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

             DLTF       FILE(&WLIB/&@FILE)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&@FILE) RCDLEN(2014) +
                          OPTION(*NOLIST) SIZE(10000 3000) +
                          LVLCHK(*NO) AUT(*ALL)


             OVRDBF     FILE(AAHWPS6) TOFILE(&WLIB/&@FILE)
             CALL       PGM(AAHRS6)
             CALL       PGM(AAFRS6)
             CALL       PGM(CADRS6)
             DLTOVR     FILE(AAHWPS6)

             IF         COND(&WT *NE 'HPI' *AND &WT *NE 'V#I') THEN(DO)
             GOTO       CMDLBL(@END)
             ENDDO

             RTVMBRD    FILE(&WLIB/&@FILE)  NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(GOTO CMDLBL(@END))

             CHGVAR     VAR(&@LIBL) VALUE(&WLIB)
             CHGVAR     VAR(&@HOST) VALUE(&SYS)
             CHGVAR     VAR(&@SAVE) VALUE('C:/AS400/DATA/AAHWPS6.CSV')
             CHGVAR     VAR(&@TYPE) VALUE(' 1')
             CALL       PGM(APLC98) PARM(&@LIBL &@FILE &@HOST &@SAVE +
                          &@TYPE)
@END:
             ENDPGM
