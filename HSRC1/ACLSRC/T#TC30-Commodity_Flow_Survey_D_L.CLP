             PGM
             /** T#TC30 ************************/
             /* COMMODITY FLOW SURVEY DOWNLOAD */
             /************************ T#TC30 **/
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)
        /*SEND MAIL SET */
             DCL        VAR(&TO1)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&SUB)  TYPE(*CHAR) LEN(30)
             DCL        VAR(&FNAME)  TYPE(*CHAR) LEN(30)

             RTVJOBA    USER(&US)

             CHGVAR     VAR(&TO1) VALUE('USER.NAME@IAFI.COM')
             CHGVAR     VAR(&SUB) VALUE('COMMODITY FLOW SURVEY - ' *CAT &US)
             CHGVAR     VAR(&FNAME) VALUE('SURVEY-DATA.CSV')

             DLTF       FILE(HWFILE1/T#TWP30)
             MONMSG     MSGID(CPF2103 CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/T#TWP30) RCDLEN(512) +
                          OPTION(*NOLIST) SIZE(100000 1000 9) +
                          LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(T#TR30) PARM(&TO1)

             RTVMBRD    FILE(HWFILE1/T#TWP30) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(GOTO CMDLBL(END))

             CALL       PGM(APLC30) PARM(&TO1 &SUB 'HWFILE1' +
                          'T#TWP30' &FNAME)
  END:
             ENDPGM
