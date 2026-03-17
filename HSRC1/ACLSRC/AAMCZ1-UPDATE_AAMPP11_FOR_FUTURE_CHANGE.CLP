             PGM
             /** AAMCZ1 ********************************/
             /*  UPDATE AAMPP11 FOR FUTURE CHANGE      */
             /*     K.HAYASHI         11/01/2015       */
             /******************************** AAMCZ1  */
             DCL        VAR(&SYS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&US)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)

             DCL        VAR(&@LIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&@FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&@HOST) TYPE(*CHAR) LEN(8)
             DCL        VAR(&@SAVE) TYPE(*CHAR) LEN(52)
             DCL        VAR(&@TYPE) TYPE(*CHAR) LEN(2)

             RTVJOBA    JOB(&WSID) USER(&USER)

             RTVNETA    SYSNAME(&SYS)
             RTVJOBA    JOB(&WSID) USER(&US)
           /*--------------------------------------------*/
           /*    CHECK ENVIRONMENT                        */
           /*--------------------------------------------*/
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

           /*--------------------------------------------*/
           /*    TAKE A BACKUP                            */
           /*--------------------------------------------*/
             CPYF       FROMFILE(&PLIB/FCEPP01) +
                          TOFILE(&PLIB/FCEPP01SAV) MBROPT(*REPLACE) +
                          CRTFILE(*YES)
             CPYF       FROMFILE(&PLIB/AAMPP11) +
                          TOFILE(&PLIB/AAMPP11SAV) MBROPT(*REPLACE) +
                          CRTFILE(*YES)



             DLTF       FILE(&WLIB/AAMWPZ1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AAMWPZ1) RCDLEN(128) +
                          OPTION(*NOLIST *NOSRC) SIZE(1000 5000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(AAMRZ1)

     /*      SNDDST     TYPE(*FILE) TOINTNET((*NONE) +
                          ('SAKASHITA.TOMOKIYO@AOYAMAGRP.COM')) +
                          DSTD('DSTS') MSG('AAMCZ1') +
                          DOCFILE(AAMWPZ1) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD('AAMCZ1')  */
     /*      MONMSG     MSGID(CPF0000) */

             CALL       PGM(AAMCZ2)

             CHGVAR     VAR(&@LIBL) VALUE('HWFILE1')
             CHGVAR     VAR(&@FILE) VALUE('AAMWPZ1')
             CHGVAR     VAR(&@HOST) VALUE(&SYS)
             CHGVAR     VAR(&@SAVE) VALUE('C:/AS400/DATA/AAMWPZ1.CSV')
             CHGVAR     VAR(&@TYPE) VALUE(' 1')

             CALL       PGM(APLC98) PARM(&@LIBL &@FILE &@HOST &@SAVE +
                          &@TYPE)

             ENDPGM
