             PGM        PARM(&PAM1 &PAM2 &PAM3 &PAM4 &PAM5 &PAM6)
         /**            ABHC01    ACLSRC   *PGM   CL  */
         /**            AAAR01    ARPGSRC  *PGM   RPG */
         /**            AHBPW02   ADSPSRC  *FILE  DSP */
         /**            ABHPP01   ADDSSRC  *FILE  DDS */
         /**            AADS3A    FMTSRC   *NONE  FMT */
             /** AXAC02 ********************/
             /* TEST SAKAKI                */
             /*                2016.07.15  */
             /******************** AXXC01 **/
             DCL        VAR(&PAM1) TYPE(*CHAR) LEN(10)  /*MBR*/
             DCL        VAR(&PAM2) TYPE(*CHAR) LEN(10)  /*SRCF*/
             DCL        VAR(&PAM3) TYPE(*CHAR) LEN(5)  /*TYPE*/
             DCL        VAR(&PAM4) TYPE(*CHAR) LEN(3)  /*ATTR*/
             DCL        VAR(&PAM5) TYPE(*CHAR) LEN(1)  /*CPYO*/
             DCL        VAR(&PAM6) TYPE(*CHAR) LEN(1)  /*CPYS*/
             DCL        VAR(&PAMX) TYPE(*CHAR) LEN(10)

             IF         COND((&PAM4 *EQ 'CL ') *OR (&PAM4 *EQ 'RPG') +
                          *OR (&PAM4 *EQ 'DSP')) THEN(DO)
             CRTDUPOBJ  OBJ(&PAM1) FROMLIB(HOBJ1) OBJTYPE(&PAM3) +
                          TOLIB(IAFFCE)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             CHGVAR     VAR(&PAM5) VALUE('E')
             ENDDO
             ENDDO

          /* ELSE DO         */
          /*  CPYF BY MANUAL */
          /* ENDDO           */


             CHGVAR     VAR(&PAMX) VALUE('Q' *TCAT &PAM4 *TCAT 'SRC')

             CPYSRCF    FROMFILE(HSRC1/&PAM2) TOFILE(IAFFCE/&PAMX) +
                          FROMMBR(&PAM1) TOMBR(&PAM1)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             CHGVAR     VAR(&PAM6) VALUE('E')
             ENDDO

 END:        ENDPGM
