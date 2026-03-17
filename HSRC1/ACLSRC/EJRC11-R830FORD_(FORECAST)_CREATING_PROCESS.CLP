             PGM        PARM(&LIBL &FILE)
             /** EJRC11 ***********************************/
             /* FORD 830(FORECAST) CREATING PROCESS       */
             /*    **ORIGINAL IS JN100C FROM ASJ**        */
             /*                                           */
             /*  *** %0001 CHANGE AFTER MIGRATION ***     */
             /*                                           */
             /*    T.SAKAKI                   2017.01.06  */
             /* JW1  2020.11.19 ADD #STOP                 */
             /*********************************** EJRC11 **/
             DCL        VAR(&LIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&RFILE) TYPE(*CHAR) LEN(10)

     /*--------------------------*/
     /*    CHECK ENVIRONMENT     */
     /*--------------------------*/
             RTVJOBA    USER(&USER)
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

     /*--------------------------*/
     /*    CREATE WORK FILE      */
     /*--------------------------*/
     /*  FILE 1 */
             CHGVAR     VAR(&RFILE) VALUE('EBAEP10   ')
             DLTF       FILE(&WLIB/&RFILE)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(&WLIB/&RFILE) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(&RFILE) OPTION(*NOLIST *NOSRC) +
                          SIZE(100000 3000) LVLCHK(*NO) AUT(*ALL)
     /*  FILE 2 */
             CHGVAR     VAR(&RFILE) VALUE('EBAEP11   ')
             DLTF       FILE(&WLIB/&RFILE)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(&WLIB/&RFILE) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(&RFILE) OPTION(*NOLIST *NOSRC) +
                          SIZE(100000 3000) LVLCHK(*NO) AUT(*ALL)

     /*----------------------------------------*/
     /* MAIN PROGRAM TO GET CONTAINS FROM EDI  */
     /* WORKFILE -> EBAEP10--ORIGINAL FILE IS ABAEP10 */
     /* WORKFILE -> EBAEP11--ORIGINAL FILE IS ABAEP11 */
     /*----------------------------------------*/
             OVRDBF     FILE(EJRWP11) TOFILE(&LIBL/&FILE)
             CALL       PGM(EJRR11)
             DLTOVR     FILE(*ALL)

     /* %0001 REMOVE AFTER TEST */
     /**********************************/
             CPYF       FROMFILE(&WLIB/EBAEP10) +
                          TOFILE(&WLIB/EBAEP10S) MBROPT(*ADD) +
                          CRTFILE(*YES)
             MONMSG     MSGID(CPF0000)
             CPYF       FROMFILE(&WLIB/EBAEP11) +
                          TOFILE(&WLIB/EBAEP11S) MBROPT(*ADD) +
                          CRTFILE(*YES)
             MONMSG     MSGID(CPF0000)
     /**********************************/

     /*------------------------*/
     /* WRITE TO FORECAST FILE */
     /*------------------------*/
     /*** #STOP B2B ************/
             CALL       PGM(ABACP7)

@END:
             ENDPGM
