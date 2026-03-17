             PGM        PARM(&LIBL &FILE)
             /** EJRC10 ***********************************/
             /* FORD 862(ORDER)  CREATING PROCESS         */
             /*                                           */
             /*  *** %0001 CHANGE AFTER MIGRATION ***     */
             /*                                           */
             /*    T.SAKAKI                   2016.10.13  */
             /*********************************** EJRC10 **/
             DCL        VAR(&LIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&RFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)

     /*--------------------------*/
     /*    CHECK ENVIRONMENT     */
     /*--------------------------*/
             RTVJOBA    USER(&USER)
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

     /*--------------------------*/
     /*    CREATE WORK FILE      */
     /*--------------------------*/
             CHGVAR     VAR(&RFILE) VALUE('EB#EP50   ')
             DLTF       FILE(&WLIB/&RFILE)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(&WLIB/&RFILE) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(&RFILE) OPTION(*NOLIST *NOSRC) +
                          SIZE(100000 3000) LVLCHK(*NO) AUT(*ALL)

             CHGVAR     VAR(&RFILE) VALUE('EJRWP1N   ')
             DLTF       FILE(&WLIB/&RFILE)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(&WLIB/&RFILE) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(&RFILE) OPTION(*NOLIST *NOSRC) +
                          SIZE(100000 3000) LVLCHK(*NO) AUT(*ALL)

     /*----------------------------------------*/
     /* MAIN PROGRAM TO GET CONTAINS FROM EDI  */
     /* WORKFILE -> EB#EP50--ORIGINAL FILE IS AB#EP50 */
     /*----------------------------------------*/
             OVRDBF     FILE(EJRWP10) TOFILE(&LIBL/&FILE)
             CALL       PGM(EJRR10)
             DLTOVR     FILE(*ALL)

             RTVMBRD    FILE(EJRWP1N) NBRCURRCD(&REC)
             IF         COND(&REC *GT 0) THEN(DO)
             CPYF       FROMFILE(EJRWP1N) TOFILE(&WLIB/EJRWP1NS) +
                          MBROPT(*ADD) CRTFILE(*YES)

             SNDMSG     MSG('**FORD 862 is duplicated.Check +
                          EJRWP1NS') TOMSGQ(V#IS1)
             ENDDO

             RTVMBRD    FILE(EB#EP50) NBRCURRCD(&REC)
             IF         COND(&REC = 0) THEN(GOTO CMDLBL(@END))

     /* %0001 REMOVE AFTER TEST */
     /**********************************/
             CPYF       FROMFILE(&WLIB/EB#EP50) +
                          TOFILE(&WLIB/EB#EP50S) MBROPT(*ADD) +
                          CRTFILE(*YES)
             MONMSG     MSGID(CPF0000)
     /**********************************/

     /*--------------------------*/
     /* MAIN PROGRAM             */
     /*--------------------------*/
             CALL       PGM(EB#C0B)

@END:
             ENDPGM
