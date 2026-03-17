             PGM        PARM(&LIBL &FILE)
             /** EJRC12 *******************************************/
             /* FORD 861(RECEIVING ADVICE) CREATE EB#EP80         */
             /* J.WATANABE  2016.12.16                            */
             /* J.WATANABE  2017.06.22  ADD EB#R0L                */
             /* JW1         2020.11.19  ADD #STOP                 */
             /*****************************************************/
             DCL        VAR(&LIBL)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
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
             CHGVAR     VAR(&RFILE) VALUE('EB#EP80   ')
             DLTF       FILE(&WLIB/&RFILE)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&RFILE) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(&RFILE) OPTION(*NOLIST *NOSRC) +
                          SIZE(10000 3000) LVLCHK(*NO) AUT(*ALL)

     /*----------------------------------------*/
     /* MAIN PROGRAM TO GET CONTAINS FROM EDI  */
     /* WORKFILE -> EB#EP80--ORIGINAL FILE IS AB#EP80 */
     /*----------------------------------------*/
             OVRDBF     FILE(EJRWP12) TOFILE(&LIBL/&FILE)
             CALL       PGM(EJRR12)
             DLTOVR     FILE(*ALL)


     /* %0001 REMOVE AFTER TEST */
     /**********************************/
        /*   CPYF       FROMFILE(&WLIB/EB#EP80) +               */
        /*                TOFILE(&WLIB/EB#EP80S) MBROPT(*ADD) + */
        /*                FMTOPT(*MAP *DROP)                    */
        /*   MONMSG     MSGID(CPF0000)                          */
     /**********************************/

     /* EDI861 PROCESS (JW) ************/

     /**JW1 #STOP B2B*******************/
             CALL       PGM(EB#R0L)


@END:
             ENDPGM
