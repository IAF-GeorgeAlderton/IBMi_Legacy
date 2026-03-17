             PGM        PARM(&LIBL &FILE)
             /** EJRC13 ***********************************/
             /* FORD 856(CONTAINER ASN) CREATING PROCESS  */
             /*                                           */
             /*  *** %0001 CHANGE AFTER MIGRATION ***     */
             /*                                           */
             /*    T.SAKAKI                   2017.02.08  */
             /* JW1  2020.11.19 ADD #STOP                 */
             /*********************************** EJRC13 **/
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
             CHGVAR     VAR(&RFILE) VALUE('EB#EP41   ')
             DLTF       FILE(&WLIB/&RFILE)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(&WLIB/&RFILE) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(&RFILE) OPTION(*NOLIST *NOSRC) +
                          SIZE(10000 3000) LVLCHK(*NO) AUT(*ALL)

     /*----------------------------------------*/
     /* MAIN PROGRAM TO GET CONTAINS FROM EDI  */
     /* WORKFILE -> EB#EP41--ORIGINAL FILE IS AB#EP41 */
     /*----------------------------------------*/
             OVRDBF     FILE(EJRWP13) TOFILE(&LIBL/&FILE)
             CALL       PGM(EJRR13)

     /* %0001 REMOVE AFTER TEST */
     /**********************************/
             CPYF       FROMFILE(&WLIB/EB#EP41) +
                          TOFILE(&WLIB/EB#EP41S) MBROPT(*ADD) +
                          CRTFILE(*YES)
             MONMSG     MSGID(CPF0000)
     /**********************************/

     /*--------------------------*/
     /* EB#EP41 -> ABFPP41       */
     /*--------------------------*/

     /*** #STOP B2B ************/
             CALL       PGM(EBFR41)

             DLTOVR     FILE(*ALL)

@END:
             ENDPGM
