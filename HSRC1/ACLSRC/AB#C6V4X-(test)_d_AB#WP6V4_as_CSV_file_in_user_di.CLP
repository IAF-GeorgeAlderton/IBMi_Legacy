             PGM
/** AB#C6V4D **********************************************/
/*  DOWNLOAD AB#WP6V4 AS CSV FILE IN USER DIRECTORY       */
/*  JW1   2020/08/24 ADD UNSCAN DETAILS (AB#WP6V6)        */
/**********************************************************/

             DCL        VAR(&REC)  TYPE(*DEC) LEN(10 0) VALUE(0)
             DCL        VAR(&FNAM) TYPE(*CHAR) LEN(30) +
                          VALUE('TOYOTA CONTAINER (UNSCAN)')

             CLRPFM     FILE(HWFILE1/UEXWP38)
             MONMSG     MSGID(CPF0000)

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
        /**  CALL       PGM(AB#R6V6) **/

             CLRPFM     FILE(UEXWP38 )
             CALL       PGM(AB#R6V7)

      /* TRANSFER.....*/
/**          CALL       PGM(APLC97) PARM('2' 'AB#WP6V6' 'QTEMP' +   **/
/**                       &FNAM 'Y' ' ' 'Y')                        **/
             ENDDO

             DLTOVR     FILE(*ALL)

             ENDPGM
