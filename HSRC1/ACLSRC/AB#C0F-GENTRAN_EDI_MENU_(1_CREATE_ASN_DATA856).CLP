             PGM
             /** AB#C0F ****************************************************/
             /*  EDI(856/810) GENTRAN                                      */
             /*     11/01/02                                               */
             /*                                                            */
             /* JW1   02/19/16 ADD SAVE AB#EP60/61/62 TO 60S/61S/62S       */
             /* %0001 08/04/16 CHANGE LIST TO E-MAIL                       */
             /* JW2   09/23/16 ADD WORK FILE (AB#WL0G)                     */
             /* JW3   01/30/20 MOVE AB#RE9 TO THE LINE AFTER EDSR60        */
             /* JW4   08/19/20 ADD  EDSR61 FOR TTTX ASN                    */
             /* JW5   10/15/20 ADD  AB#WP7A                                */
             /* JW6   01/18/21 ADD  AB#R0F3 FOR TTAI(3556)                 */
             /* JW7   01/20/21 ADD  AB#R0F4 FOR TTAI(3556)                 */
             /* JW8   08/08/22 ADD  AC#EP75/AC#EP76 (0323)                 */
             /* JW9   05/08/25 ADD  AB#R13T UNIVERSAL ASN DATA             */
             /* JWA   08/04/25 ADD  AB#R0F6 ADJ EP62/EP77 FOR FNG5242      */
             /**************************************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&FLAG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PERR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&ENV) TYPE(*CHAR) LEN(1)
             DCLF       FILE(AB#PW0G)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             CHGJOB     SWS(00000000)

             CALL       PGM(UTLR39) PARM(&ENV)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             ALCOBJ     OBJ((AB#EP60 *FILE *EXCLRD)) WAIT(1)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             CALL       PGM(QUILNGTX) PARM('GENTRAN IS WORKING NOW. +
                          PLEASE TRY IT AGAIN IN ONE MINUTE. THANK +
                          YOU. ' X'00000046' '       ' +
                          '                    ' X'00000000')
             CHGVAR     VAR(&FLAG) VALUE('1')
             GOTO END
             ENDDO
   /* GM */
             ALCOBJ     OBJ((AB#EP57 *FILE *EXCLRD)) WAIT(1)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             CALL       PGM(QUILNGTX) PARM('GENTRAN IS WORKING NOW. +
                          PLEASE TRY IT AGAIN IN ONE MINUTE. THANK +
                          YOU. ' X'00000046' '       ' +
                          '                    ' X'00000000')

             CHGVAR     VAR(&FLAG) VALUE('1')
             GOTO END
             ENDDO

 /* CREATE WORK FILES  */
 /*JW7*/     DLTF       FILE(QTEMP/AB#WP61)
 /*JW7*/     MONMSG     MSGID(CPF0000)
 /*JW7*/     CRTDUPOBJ  OBJ(AB#WP61) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
 /*JW7*/                  TOLIB(QTEMP)
 /*JW7*/     MONMSG     MSGID(CPF0000)
 /*JW7*/     CLRPFM QTEMP/AB#WP61

 /*JW7*/     DLTF       FILE(QTEMP/AB#WP62)
 /*JW7*/     MONMSG     MSGID(CPF0000)
 /*JW7*/     CRTDUPOBJ  OBJ(AB#WP62) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
 /*JW7*/                  TOLIB(QTEMP)
 /*JW7*/     MONMSG     MSGID(CPF0000)
 /*JW7*/     CLRPFM QTEMP/AB#WP62

             DLTF       FILE(QTEMP/AB#WL7A)            /*JW5*/
             MONMSG     MSGID(CPF0000)

             DLTF       FILE(QTEMP/AB#WP7A)            /*JW5*/
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(AB#WP7A) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/AB#WP7A                      /*JW5*/
             CRTDUPOBJ  OBJ(AB#WL7A) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             DLTF       FILE(QTEMP/AB#WP0F)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(AB#WP0F) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/AB#WP0F

             CRTDUPOBJ  OBJ(MITANKF) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/MITANKF
             CRTDUPOBJ  OBJ(AB#WP34) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/AB#WP34

             CRTDUPOBJ  OBJ(AB#WP33) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/AB#WP33

/*JW2*/      DLTF       FILE(QTEMP/AB#WL0G)
             MONMSG     MSGID(CPF0000)

             DLTF       FILE(QTEMP/AB#WP0G)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(AB#WP0G) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/AB#WP0G

/*JW2*/      CRTDUPOBJ  OBJ(AB#WL0G) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

/*JW7*/      OVRDBF     FILE(AB#WP61) TOFILE(QTEMP/AB#WP61)
/*JW7*/      OVRDBF     FILE(AB#WP62) TOFILE(QTEMP/AB#WP62)
             OVRDBF     FILE(MITANKF) TOFILE(QTEMP/MITANKF)
             OVRDBF     FILE(AB#WP0F) TOFILE(QTEMP/AB#WP0F)
             OVRDBF     FILE(AB#WP34) TOFILE(QTEMP/AB#WP34)
             OVRDBF     FILE(AB#WP0G) TOFILE(QTEMP/AB#WP0G)
             OVRDBF     FILE(AB#WL0G) TOFILE(QTEMP/AB#WL0G) /*JW2*/
             OVRDBF     FILE(AB#WP7A) TOFILE(QTEMP/AB#WP7A) /*JW5*/
             OVRDBF     FILE(AB#WL7A) TOFILE(QTEMP/AB#WL7A) /*JW5*/

             CALL       PGM(AB#R0F) PARM(&FLAG  &PERR)

        /* JW6 2020.11.03 ADJ EP61 FOR TTAI(3556)  ********/
        /*** CALL       PGM(AB#R0F3)               ********/

        /* JW7 2021.01.20 ADJ EP61/EP62 FOR TTAI(3556)    */
             CALL       PGM(AB#R0F4)

        /* JWA 2025.08.04 ADJ EP62/EP77 FOR FNG (5242)    */
        /*   CALL       PGM(AB#R0F6) */

        /* JW7 2023.11.10 WRT EP61/EP62 FOR AWTX(0493)    */
        /*** CALL       PGM(AB#R0F5)                     **/

        /* JW1 2016.02.19 ADDED: SAVE AB#EP60/61/62       */
             CALL       PGM(EDSR60)

        /* JW  2025.01.21 ADDED: SAVE AB#EP53/54.. (BOCAR)  */
             CALL       PGM(EDSR5B)

        /* JW4 2020.08.19 TRANSFER AB#EP60/61/62 TO AC#EP60/61/62 */
        /*                TTTX(3511) NEEDS NEW FORMAT FOR ASN     */
             CALL       PGM(EDSR61)

        /* JW8 2022.08.08 TRANSFER AB#EP75/76 TO AC#EP75/76           */
          /**CPYF       FROMFILE(HFILE1/AB#EP75) +                   **/
          /**             TOFILE(HFILE1/AC#EP75) MBROPT(*REPLACE) +  **/
          /**             FMTOPT(*MAP *DROP)                         **/
          /**MONMSG     MSGID(CPF0000 CPF2869)                       **/
          /**CPYF       FROMFILE(HFILE1/AB#EP76) +                   **/
          /**             TOFILE(HFILE1/AC#EP76) MBROPT(*REPLACE) +  **/
          /**             FMTOPT(*MAP *DROP)                         **/
          /**MONMSG     MSGID(CPF0000 CPF2869)                       **/
             CALL       PGM(EDSR62)

        /* JW3 POSTING 2020.01.30 */
             OVRDBF     FILE(AB#WP34) TOFILE(QTEMP/AB#WP34)
             CALL       PGM(AB#RE9)

             IF         COND(&FLAG *EQ '9') THEN(GOTO CMDLBL(END))

 /* UNIT PRICE ERROR */
             IF         COND((&PERR *EQ '*') *AND (&ENV *NE 'T')) +
                          THEN(DO)
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(LANPRT50) +
                          FORMTYPE(K6H1) HOLD(*YES) IGCDTA(&PIGCD)
             CALL       PGM(AB#R0D)

 /* %0001R */
             CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT132B) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132B)
             CALL       PGM(AB#RW0)

             SNDDST     TYPE(*FILE) TOINTNET((SalesGroup@iafi.com) +
                          (Accounting@iafi.com *CC)) DSTD('Unit +
                          price not registered') MSG('** PRICE=0 ** +
                          Shipped with Unit Price=0, Please check +
                          the attached report.(AB#C0F).') +
                          DOCFILE(HWFILE1/PRT132B) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD('EDI 856 or Posting +
                          Unit price not registered')

             MONMSG     MSGID(CPF0000)

             DLTOVR     FILE(PRT132)


             ENDDO

 END:
             DLCOBJ     OBJ((AB#EP60 *FILE *EXCLRD))
             MONMSG     MSGID(CPF0000)
             DLCOBJ     OBJ((AB#EP57 *FILE *EXCLRD))
             MONMSG     MSGID(CPF0000)

             IF         COND(&FLAG *NE ' ') THEN(GOTO CMDLBL(SKP))

/* MSG: ASN DATA HAS BEEN CREATED SUCCESSFULLY */
             IF         COND(&FLAG *EQ ' ') THEN(DO)
             SNDRCVF    RCDFMT(W01)
             DLTOVR     FILE(AB#WP0G)
             CPYF       FROMFILE(QTEMP/AB#WP0G) +
                          TOFILE(&WLIB/AB#WP0G) MBROPT(*ADD)
             MONMSG     MSGID(CPF0000)
             ENDDO
/* JW2 SAVE AB#WP0G */
             CPYF       FROMFILE(QTEMP/AB#WP0G) +
                          TOFILE(&WLIB/AB#WP0H) MBROPT(*ADD)
             MONMSG     MSGID(CPF0000)

/* JW3  **** OVRDBF     FILE(AB#WP34) TOFILE(QTEMP/AB#WP34)     **** */
/*      **** CALL       PGM(AB#RE9)                             **** */

             DLTOVR     FILE(*ALL)
             SBMJOB     CMD(CALL PGM(AB#CAR)) USER(EDIUSER)

        /* JW9 2025.05.08 ADDED: UNIVERSAL ASN DATA       */
             CALL       PGM(AB#R13T)
             CALL       PGM(AB#R13S)

  SKP:
             ENDPGM
