/*= ABBC69 ===============================================*/
/*  PROGRAM    : FORECAST VS SHIP REPORT                  */
/*                                                        */
/*  JW1 2016/01/15 CHG: TANE961  --> ABBR67               */
/*                    : TANE962  --> ABBR68               */
/*                    : TANE961F --> ABBWP68              */
/*                    : TANE962F --> ABBWP69              */
/*  JW2 2018/02/07 REMOVE ABBR69                          */
/*                 ADD    ABBR66                          */
/*========================================================*/
             PGM
             DCL        VAR(&ABADS1) TYPE(*CHAR) LEN(48)
             DCL        VAR(&YYMM)   TYPE(*CHAR) LEN(06)
             DCL        VAR(&D1)     TYPE(*CHAR) LEN(06)

/*JW1*/      DCL        VAR(&DIR)   TYPE(*CHAR) LEN(100)
/*JW1*/      DCL        VAR(&DIR2)  TYPE(*CHAR) LEN(100)
/*JW1*/      DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
/*JW1*/      DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(8)
/*JW1*/      DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
/*JW1*/      DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
/*JW1*/      DCL        VAR(&FIL1)  TYPE(*CHAR) LEN(23) +
                          VALUE('Forecast vs Ship as of ')
/*JW1*/      DCL        VAR(&FILE)  TYPE(*CHAR) LEN(50)
/*JW1*/      DCL        VAR(&DATE6) TYPE(*CHAR) LEN(6)
/*JW1*/      DCL        VAR(&DATE8) TYPE(*CHAR) LEN(8)

             RTVDTAARA  DTAARA(ABADS1) RTNVAR(&ABADS1)
             RTVDTAARA  DTAARA(MCEDS1) RTNVAR(&D1)

             CHGVAR     VAR(&YYMM) VALUE(%SST(&ABADS1 1 6))

  /* CREATE WORK FILE */
             CLRPFM     FILE(ABBWP69)
             CLRPFM     FILE(ABBWP69C)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)
             CRTDUPOBJ  OBJ(ABBWP6A) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(&WLIB/ABBWP68)
             CLRPFM     FILE(&WLIB/ABBWP69)
             CLRPFM     FILE(&WLIB/ABBWP6A)
             CLRPFM     FILE(&WLIB/ABBWP69C)
             CLRPFM     FILE(&WLIB/ABBWP6C)
             OVRDBF     FILE(ABBWP68)  TOFILE(&WLIB/ABBWP68)
             OVRDBF     FILE(ABBWP69)  TOFILE(&WLIB/ABBWP69)
             OVRDBF     FILE(ABBWP6A)  TOFILE(&WLIB/ABBWP6A)
             OVRDBF     FILE(ABBWP69C) TOFILE(&WLIB/ABBWP69C)
             OVRDBF     FILE(ABBWP6C)  TOFILE(&WLIB/ABBWP6C)

 /*JW1*/     CALL       PGM(ABBR67)
 /*JW1*/     CALL       PGM(ABBR68) PARM(&YYMM &D1)
 /*JW2*/     CALL       PGM(ABBR66) PARM(&YYMM &D1)

 /*JW2===========================================================*/
 /* DATA TRANSFER (IFS) AB#WP6A / AB#WP6C                        */
 /*==============================================================*/
             CALL       PGM(APLC94) PARM('2' 'ABBWP6C' &WLIB     +
                          'FORECAST VS SHIP(12M) AS OF' 'Y' ' ' 'Y')

 /*= JW2: KIP TO END ============================================*/
             GOTO       CMDLBL(END)
 /*==============================================================*/

       /*JW2 CLRPFM     FILE(&WLIB/ABBWP69A)                    **/
       /**   OVRDBF     FILE(ABBWP69A) TOFILE(&WLIB/ABBWP69A)   **/
       /**   CALL       PGM(ABBR69) PARM(&YYMM &D1)             **/

 /*JW============================================================*/
 /* DATA TRANSFER  TO QNTC/IAF-AS400-FILE/AS400-TRANS/PC/DOWNLOAD*/
 /*==============================================================*/
         /*  RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&DATE6)                    */
         /*  CHGVAR     VAR(%SUBSTRING(&DATE8 3 6)) VALUE(&DATE6)       */
         /*  CHGVAR     VAR(%SUBSTRING(&DATE8 1 2)) VALUE('20')         */
         /*  CHGVAR     VAR(&FILE) VALUE(&FIL1 *CAT &DATE8 *CAT '.csv') */
         /*                                                             */
         /*  CHGVAR     VAR(&DIR) +                                     */
         /*               VALUE('QNTC/IAF-AS400-FILE/AS400-TRANS/P+     */
         /*               C/Download/' *CAT &USER)                      */
         /* CREATE DIRECTRY                                             */
         /*    CRTDIR     DIR(&DIR )                                    */
         /*    MONMSG     MSGID(CPFA0A0)                                */
         /*    MONMSG     MSGID(CPFA0A9)                                */

         /* COPY 0 RECORD */
         /*    CHGVAR     VAR(&DIR2) VALUE(&DIR *TCAT '/' *TCAT &FILE)  */
         /*    CPYTOIMPF  FROMFILE(QTEMP/ABBWP6A) TOSTMF(&DIR2) +       */
         /*                 MBROPT(*REPLACE) RCDDLM(*CRLF) +            */
         /*                 RMVBLANK(*BOTH) FLDDLM(',') DATFMT(*USA) +  */
         /*                 TIMFMT(*USA)                                */
         /*    MONMSG     MSGID(CPF2817)                                */

         /* COPY.........*/
         /*     CPYF       FROMFILE(*LIBL/ABBWP69) +                     */
         /*                  TOFILE(QTEMP/ABBWP6A) MBROPT(*REPLACE) +    */
         /*                  FMTOPT(*NOCHK)                              */

         /* TRANSFER.....*/
         /*  CPYTOIMPF  FROMFILE(&WLIB/ABBWP6A) TOSTMF(&DIR2) +              */
         /*               MBROPT(*REPLACE) RCDDLM(*CRLF) +                   */
         /*               RMVBLANK(*BOTH) FLDDLM(',') DATFMT(*USA) +         */
         /*               TIMFMT(*USA) ADDCOLNAM(*NONE)                      */
         /*  MONMSG     MSGID(CPF0000)                                       */
         /*                                                                  */
         /*  SNDPGMMSG  MSG('REPORT HAS BEEN CREATED IN YOUR USER +          */
         /*               DIRECTORY (J:) PC\DOWNLOAD\USER-ID\' *CAT  &FILE) +*/
         /*               TOMSGQ(&WSID) MSGTYPE(*INFO)                       */
END:
             DLTOVR     FILE(*ALL)
             ENDPGM
