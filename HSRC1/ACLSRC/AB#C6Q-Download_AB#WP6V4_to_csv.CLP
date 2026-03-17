             PGM        PARM(&GRP)
/** AB#C6Q ************************************************/
/*  DOWNLOAD AB#WP6V4 TO CSV                              */
/*  JW    2021/11/05                                      */
/**********************************************************/

             DCL        VAR(&GRP)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&REC)  TYPE(*DEC)  LEN(10 0) VALUE(0)
             DCL        VAR(&FNAM) TYPE(*CHAR) LEN(30)

             IF         COND(&GRP *EQ '1') THEN(DO)
             CHGVAR     VAR(&FNAM) VALUE('TOYOTA CONTAINER (UNSCAN)')
             GOTO       CMDLBL(SKIP1)
             ENDDO
             IF         COND(&GRP *EQ '2') THEN(DO)
             CHGVAR     VAR(&FNAM) VALUE('HONDA CONTAINER (UNSCAN)')
             GOTO       CMDLBL(SKIP1)
             ENDDO
             IF         COND(&GRP *EQ '3') THEN(DO)
             CHGVAR     VAR(&FNAM) VALUE('FORD CONTAINER (UNSCAN)')
             GOTO       CMDLBL(SKIP1)
             ENDDO
             IF         COND(&GRP *EQ '4') THEN(DO)
             CHGVAR     VAR(&FNAM) VALUE('USER CONTAINER (UNSCAN)')
             GOTO       CMDLBL(SKIP1)
             ENDDO

             CHGVAR     VAR(&FNAM) VALUE('GROUP X CONTAINER (UNSCAN)')
SKIP1:
             DLTF       FILE(QTEMP/AB#WP6V6)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(AB#WP6V6) FROMLIB(HWFILE1) +
                          OBJTYPE(*FILE) TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(QTEMP/AB#WP6V6)
             MONMSG     MSGID(CPF2103 CPF3261 CPF2105)

             DLTF       FILE(QTEMP/AB#WL6V6)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(AB#WL6V6) FROMLIB(HWFILE1) +
                          OBJTYPE(*FILE) TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             DLTF       FILE(QTEMP/AB#WP6V7)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(AB#WP6V7) FROMLIB(HWFILE1) +
                          OBJTYPE(*FILE) TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(QTEMP/AB#WP6V7)
             MONMSG     MSGID(CPF2103 CPF3261 CPF2105)

             RTVMBRD    FILE(QTEMP/AB#WP6V4) NBRCURRCD(&REC)
             IF         COND(&REC *NE 0) THEN(DO)
             DLTF       FILE(QTEMP/UEXWP38 )
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(UEXWP38 ) FROMLIB(HWFILE1) +
                          OBJTYPE(*FILE) TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(QTEMP/UEXWP38 )
             MONMSG     MSGID(CPF2103 CPF3261 CPF2105)

             CALL       PGM(AB#R6Q) PARM(&GRP)

 /** JW2 =========================================================**/

      /* TRANSFER.....*/
             CALL       PGM(APLC97) PARM('2' 'AB#WP6V6' 'QTEMP' +
                          &FNAM 'Y' ' ' 'Y')
             ENDDO

             DLTOVR     FILE(*ALL)

             ENDPGM
