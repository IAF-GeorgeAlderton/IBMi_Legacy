             PGM
             /** AAHCS1 ************************************/
             /*                                            */
             /*               CREATE DATE : 2014.07.22     */
             /*               T.SAKASHITA                  */
             /**********************************************/
             DCL        VAR(&SYS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WT) TYPE(*CHAR) LEN(3)

             DCL        VAR(&@LIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&@FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&@HOST) TYPE(*CHAR) LEN(8)
             DCL        VAR(&@SAVE) TYPE(*CHAR) LEN(52)
             DCL        VAR(&@TYPE) TYPE(*CHAR) LEN(2)

             RTVNETA    SYSNAME(&SYS)
             RTVJOBA    JOB(&WSID)

             CHGVAR     VAR(&WT) VALUE(%SST(&WSID 1 3))

             DLTF       FILE(HWFILE1/AAHWPS1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/AAHWPS1) RCDLEN(2015) +
                          OPTION(*NOLIST) SIZE(10000 3000) +
                          LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(AAHRS1)
             CALL       PGM(AAFRS2)

             IF         COND(&WT *NE 'HPI') THEN(DO)
             GOTO       CMDLBL(@END)
             ENDDO

             CHGVAR     VAR(&@LIBL) VALUE('HWFILE1')
             CHGVAR     VAR(&@FILE) VALUE('AAHWPS1')
             CHGVAR     VAR(&@HOST) VALUE(&SYS)
             CHGVAR     VAR(&@SAVE) VALUE('C:/AS400/DATA/AAHWPS1.CSV')
             CHGVAR     VAR(&@TYPE) VALUE(' 1')
             CALL       PGM(APLC98) PARM(&@LIBL &@FILE &@HOST &@SAVE +
                          &@TYPE)
@END:
             ENDPGM
