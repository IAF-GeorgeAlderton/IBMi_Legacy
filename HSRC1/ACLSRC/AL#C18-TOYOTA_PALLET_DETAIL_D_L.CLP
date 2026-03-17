  PGM        PARM(&NONY &FROM &TO)
/** AL#C18 ************************************************/
/* TOYOTA PALLET DETAIL D/L                               */
/*                                                        */
/*  KIRI 2019/10/25                                       */
/**********************************************************/
             DCL        VAR(&WSID)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&NONY)     TYPE(*CHAR) LEN(4)
             DCL        VAR(&FROM)     TYPE(*DEC ) LEN(8 0)
             DCL        VAR(&TO  )     TYPE(*DEC ) LEN(8 0)

             DCL        VAR(&AL#WP182) TYPE(*CHAR) LEN(10)
             DCL        VAR(&REC     ) TYPE(*DEC ) LEN(10 0)
             DCL        VAR(&FNAM) TYPE(*CHAR) LEN(30) +
                          VALUE('TOYOTA_PALLET_DETAIL         ')

             RTVJOBA    JOB(&WSID) USER(&USER)
             /*--------------------------------------------*/
             /*    CHECK ENVIRONMENT                        */
             /*--------------------------------------------*/
               CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

             CHGVAR     VAR(&AL#WP182) +
                         VALUE('AL#WP18' *CAT %SST(&WSID 1 3))
             DLTF       FILE(&WLIB/&AL#WP182)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AL#WP182) RCDLEN(256) +
                          OPTION(*NOLIST *NOSRC) LVLCHK(*NO) AUT(*ALL)


             DLTF       FILE(QTEMP/AL#WP18)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(AL#WP18) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/AL#WP18)

             OVRDBF     FILE(AL#WP18) TOFILE(QTEMP/AL#WP18)
             OVRDBF     FILE(AL#WP182) TOFILE(&WLIB/&AL#WP182)
             CALL       PGM(AL#R18) PARM(&NONY &FROM &TO)

             RTVMBRD    FILE(&WLIB/&AL#WP182) NBRCURRCD(&REC)
             IF         COND(&REC *NE 0) THEN(DO)

                 /*転送処理*/
             CALL       PGM(APLC94) PARM('1' &AL#WP182 &WLIB +
                          &FNAM 'Y' ' ' 'Y')

             ENDDO

             ENDPGM
