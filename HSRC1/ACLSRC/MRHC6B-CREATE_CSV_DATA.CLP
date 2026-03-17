             PGM
             /*** MRHC6B ***********************************/
             /* CREATE CSV DATA                          */
             /*  QY.LIU            2024.06.24              */
             /**********************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PUSER1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&OUTQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&USER)     TYPE(*CHAR) LEN(10)

             DCL        VAR(&FLIB)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&SLIB)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&SFILE)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&DDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RTN ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FNAM) TYPE(*CHAR) LEN(30)
             RTVJOBA    JOB(&WSID) USER(&PPUSER) DATE(&DDATE)

             CHGVAR     VAR(&SLIB)  VALUE('HSRC1')
             CHGVAR     VAR(&SFILE) VALUE('ADDSSRC')

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))
             CHGVAR     VAR(&PUSER1) VALUE(%SST(&PPUSER 1 1))

             CHGVAR     VAR(&PRTG) VALUE(&OUTQ)

             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO

 #STP10:
             DLTF       FILE(&WLIB/MRHWP6B)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/MRHWP6B) RCDLEN(1024) +
                          OPTION(*NOLIST *NOSRC) SIZE(50000 10000 +
                          3) LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(MRHR6B) PARM(&RTN)

     /*      IF         COND(&RTN = ' ') THEN(DO)             */
             CHGVAR     VAR(&FNAM) VALUE('POS KANBAN ')
             CALL       PGM(APLC94) PARM('1' 'MRHWP6B' 'HWFILE1' &FNAM +
                          'Y' ' ' 'Y')
          /* CALL       PGM(APLC91) PARM('2' 'MRHWP6B' 'HWFILE1' &FNAM)   */

     /*      ENDDO      */

 END:
             ENDPGM
