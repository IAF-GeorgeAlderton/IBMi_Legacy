             PGM
             /*** MRHC41 ***********************************/
             /*試作かんばん発行　　　                    */
             /*  TR-ITS            2014.02.06              */
             /**********************************************/

             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)

             DCL        VAR(&MRHWP61) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FLIB)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&SLIB)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&SFILE)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3)     TYPE(*CHAR) LEN(3)

             DCL        VAR(&P@KKBN)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&P@FC)    TYPE(*CHAR) LEN(2)

             CHGVAR     VAR(&SLIB)  VALUE('HSRC1')
             CHGVAR     VAR(&SFILE) VALUE('ADDSSRC')
     /*      CHGVAR     VAR(&SLIB)  VALUE('AOYAMA')       */
     /*      CHGVAR     VAR(&SFILE) VALUE('ADDSSRC')      */

             RTVJOBA    JOB(&WSID) USER(&PPUSER) DATE(&DDATE)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&MRHWP61) VALUE('MRHWP61' *CAT &WS3)

             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO

             DLTF       FILE(&WLIB/&MRHWP61)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&MRHWP61) +
                          SRCFILE(&SLIB/&SFILE) SRCMBR(MRHWP61) +
                          OPTION(*NOLIST *NOSRC) SIZE(500 500 +
                          3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(MRHWP61) TOFILE(&WLIB/&MRHWP61)

 #STP10:
             CALL       PGM(MRHR41) PARM(&P@KKBN &P@FC)

             IF         COND(&P@FC *EQ '  ') THEN(DO)
             CALL       PGM(MRHC42) PARM(&P@KKBN)
 /*          GOTO #STP10                   */
             ENDDO
 #STP20:
             DLTOVR     FILE(MRHWP61)

 END:
             ENDPGM
