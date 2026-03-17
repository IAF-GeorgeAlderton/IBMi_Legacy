             PGM
             /** TEST AB#C85 ********************************/
             /****************************** AB#C85 *********/
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(9)
             DCL        VAR(&KEN)   TYPE(*DEC)  LEN(10 0)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&RTN2)  TYPE(*CHAR) LEN(1)

/* CHECK OTHER USER IS USING  (JW1) ================================*/
   /**       CALL       PGM(CHKC45) PARM('AB#C85' 'AB#C85' 'Y' 'CHK' &RTN2) **/
   /**       IF         COND(&RTN2 *NE ' ') THEN(GOTO @ENDP2)               **/
/* =================================================================*/

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGJOB     SWS(00000000)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHGVAR     VAR(&WLIB) VALUE('TWFILE1')

             DLTF       FILE(&WLIB/AB#WP85)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AB#WP85) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(500000 3000) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&WLIB/AB#WP87)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AB#WP87) RCDLEN(256) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)
/* JW1 */
             CLRPFM     FILE(&WLIB/AB#WP8A)

             OVRDBF     FILE(AB#WP8A) TOFILE(&WLIB/AB#WP8A)
             OVRDBF     FILE(AB#WP87) TOFILE(&WLIB/AB#WP87)
             OVRDBF     FILE(AB#WP85) TOFILE(&WLIB/AB#WP85)

             CALL       PGM(TOBJ1/AB#R85)

             IF         COND(%SWITCH(0XXXXXXX)) THEN(DO)
             GOTO       @ENDP1
             ENDDO

             RTVMBRD    FILE(&WLIB/AB#WP87) NBRCURRCD(&KEN)
             IF         COND(&KEN *NE 0) THEN(DO)
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(QPRINT) FORMTYPE(K6H1) +
                          HOLD(*YES) IGCDTA(&PIGCD)

             OVRDBF     FILE(MITANKF) TOFILE(&WLIB/AB#WP87)

             SNDPGMMSG  MSG('UNIT PRICES ARE NOT REGISTERED IN THE +
                          SALES UNIT PRICE MASTER FILES. UNIT PRICE +
                          MUST BE REGISTERED.') TOMSGQ(&WSID)
             ENDDO

             DLTF       FILE(&WLIB/AB#WP86)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AB#WP86) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(500000) LVLCHK(*NO) +
                          AUT(*ALL)

             FMTDTA     INFILE((&WLIB/AB#WP85)) +
                          OUTFILE(&WLIB/AB#WP86) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AB#S85) +
                          OPTION(*NOPRT)

     /**     DLTF       FILE(&WLIB/AB#WP85) **/

             CLRPFM     FILE(&WLIB/AB#WP861)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(&WLIB/AB#WP862)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(&WLIB/AB#WP863)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(&WLIB/AB#WP864)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(&WLIB/AB#WP865)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(&WLIB/AB#WP866)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(AB#WP861) TOFILE(&WLIB/AB#WP861)
             OVRDBF     FILE(AB#WP862) TOFILE(&WLIB/AB#WP862)
             OVRDBF     FILE(AB#WP863) TOFILE(&WLIB/AB#WP863)
             OVRDBF     FILE(AB#WP864) TOFILE(&WLIB/AB#WP864)
             OVRDBF     FILE(AB#WP865) TOFILE(&WLIB/AB#WP865)
             OVRDBF     FILE(AB#WP866) TOFILE(&WLIB/AB#WP866)

             CALL       PGM(AB#R86)

    /*TEMP   DLTF       FILE(AB#WP86)       JW */

@ENDP1:
      /**    CALL       PGM(CHKC45) PARM('AB#C85' 'AB#C85' 'N' '' '')  **/
      /**                                                              **/
      /**    DLTF       FILE(&WLIB/AB#WP85)                            **/
      /**    MONMSG     MSGID(CPF3261 CPF2105)                         **/

      /**JW  DLTF       FILE(&WLIB/AB#WP87)     ****/
      /**    MONMSG     MSGID(CPF3261 CPF2105)  ****/

             DLTOVR     FILE(*ALL)
@ENDP2:
             ENDPGM
