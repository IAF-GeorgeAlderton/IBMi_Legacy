             PGM
             /** AB#C67 **********************************************/
             /*  ..SPECIAL   ORDERING..                              */
             /*  I-HASADA      97.08.23                              */
             /*  TCH     2000.03.12 ADD TYPE=07,CHANGE PAPER SIZE    */
             /*  TCH     2000.05.16 SET NUMBER OF PAGES              */
             /*  TCH     2000.08.18 CHANGE DEFALT VALUE              */
             /*  TCH     2000.09.11 ADD TYPE=08                      */
             /*  TCH     2001.02.08 CREATE W/F FOR EACH TERMINAL     */
             /*  TCH     2001.03.15 ADD PARAMETER FOR NAME OF COUNTRY*/
             /********************************************** AB#C67 **/
             DCLF       FILE(AB#PW67)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WKSID)   TYPE(*CHAR) LEN(3)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PFLG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PTYPE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PMANI) TYPE(*CHAR) LEN(18)
             DCL        VAR(&PPICK) TYPE(*DEC) LEN(2)
             DCL        VAR(&PCUST) TYPE(*DEC) LEN(2)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&TRAN)  TYPE(*CHAR) LEN(30)
             DCL        VAR(&CTYP)  TYPE(*CHAR) LEN(2)
             DCL        VAR(&PCNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&WKSID) VALUE(%SUBSTRING(&WSID 1 3))
             CHGJOB     SWS(00000000)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHGVAR     VAR(&PWEIG) VALUE(1.07)

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(AB#PW671)

             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN03) VALUE('0')
             CHGVAR     VAR(&IN04) VALUE('0')
             CHGVAR     VAR(&IN06) VALUE('0')
             CHGVAR     VAR(&IN07) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&IN01 *EQ '1') GOTO END

             IF         (&PSIRE *EQ '    ') DO
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT NO. SUPPLIER')
             GOTO       STP1
             ENDDO

             IF         (&PSIRK *EQ ' ') DO
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT NO. SUPPLIER')
             GOTO       STP1
             ENDDO

             IF         (%SUBSTRING(&PNOHZ 1 4) *LT '1997') GOTO STP2
             IF         (%SUBSTRING(&PNOHZ 5 2) *GT '12') GOTO STP2
             IF         (%SUBSTRING(&PNOHZ 5 2) *LT '01') GOTO STP2
             IF         (%SUBSTRING(&PNOHZ 7 2) *GT '31') GOTO STP2
             IF         (%SUBSTRING(&PNOHZ 7 2) *LT '01') GOTO STP2
             GOTO       STP3
 STP2:       CHGVAR     VAR(&IN04) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) +
                          VALUE('DATE (YYMMDD) IS NOT RIGHT')
             GOTO       STP1

 STP3:       IF         (&PODRN *EQ '          ') DO
             CHGVAR     VAR(&IN06) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT NO. ORDER NO.')
             GOTO       STP1
             ENDDO

             IF         (&PWEIG *EQ 0) DO
             CHGVAR     VAR(&IN07) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT NO. CONTAINER WEIGHT')
             GOTO       STP1
             ENDDO

             IF         (&IN05 *EQ '0') GOTO STP1

             DLTF       FILE(QTEMP/AB#WP671)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP671) RCDLEN(256) +
                          OPTION(*NOLIST *NOSRC) LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(QTEMP/AB#WP672)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP672) RCDLEN(256) +
                          OPTION(*NOLIST *NOSRC) LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(QTEMP/AB#WP673)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP673) RCDLEN(256) +
                          OPTION(*NOLIST *NOSRC) LVLCHK(*NO) AUT(*ALL)

             IF         (&PSIRE *EQ '3347') DO
             CLRPFM     FILE(EDI810TK)
             ENDDO

             IF         (&PSIRE *EQ '3503') DO
             CLRPFM     FILE(EDI810TC)
             ENDDO

 /* CREATE 3 WORK FILES */
             CHGVAR     VAR(&PFLG) VALUE(' ')
             CALL       PGM(AB#R67) PARM(&PSIRE &PSIRK &PNOHZ &PODRN +
                          &PFLG)

             IF         (%SWITCH(0XXXXXXX)) DO
 STP4:       SNDPGMMSG  MSG('( G ) THERE IS NO DATA CORRESPONDS TO +
                          FRS.  < G-ENTER >') TOMSGQ(&WSID) +
                          MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE = 'G') *OR (&KOTAE = 'g') +
                            *OR (&KOTAE = 'ｸ')) +
                          THEN(GOTO CMDLBL(END))       /**GA**/
             GOTO       STP4
             ENDDO
/*                                                                      */
/*           DLTF       FILE(AB#WP31)                                   */
/*           MONMSG     MSGID(CPF3261 CPF2105)                          */
/*           CRTPF      FILE(&WLIB/AB#WP31) RCDLEN(100) +               */
/*                        OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)         */


       /*    CHKOBJ     OBJ(AB#WP34) OBJTYPE(*FILE) MBR(&WKSID) */
      /*     MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP34) +
                          MBR(&WKSID))*/
       /*    CLRPFM     FILE(AB#WP34) MBR(&WKSID)  */
       /*    OVRDBF     FILE(AB#WP31) TOFILE(AB#WP34) MBR(&WKSID)*/

             CRTDUPOBJ  OBJ(AB#WP31) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/AB#WP31
             OVRDBF     FILE(AB#WP31) TOFILE(QTEMP/AB#WP31)

 /* GET THE LIST TYPE */
             CHGVAR     VAR(&PTYPE) VALUE('01')
             CALL       PGM(AB#R91) PARM(&PSIRE &PTYPE &PPICK &PCUST +
                          &TRAN &CTYP &PCNAM)

             FMTDTA     INFILE((QTEMP/AB#WP671)) +
                          OUTFILE(QTEMP/AB#WP31) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AB#S30) +
                          OPTION(*NOPRT)

         /*******************************/
         /*   SELECT OF PICK-UP LIST    */
         /*        K.YASUDA  1999.09.14 */
         /*******************************/


             IF         COND((&PTYPE *EQ '01') *OR +
                             (&PTYPE *EQ '07')) THEN(DO)
             CALL       PGM(AB#R3G) PARM(&PWEIG)
             GOTO       STEP3A
             ENDDO

             IF         COND(&PTYPE *EQ '02') THEN(DO)

             /* GET THE MANIFEST NUMBER */
             CALL       PGM(AB#R94) PARM(&USER &PSIRE &PNOHZ &PODRN +
                          &PMANI)
             CALL       PGM(AB#R3B) PARM(&PWEIG &PMANI)
             GOTO       STEP3A
             ENDDO

             IF         COND(&PTYPE *EQ '03') THEN(DO)
             CALL       PGM(AB#R3C) PARM(&PWEIG)
             GOTO       STEP3A
             ENDDO

             IF         COND(&PTYPE *EQ '04') THEN(DO)
             CALL       PGM(AB#R3D) PARM(&PWEIG)
             GOTO       STEP3A
             ENDDO

             IF         COND((&PTYPE *EQ '05') *OR +
                             (&PTYPE *EQ '06')) THEN(DO)
             FMTDTA     INFILE((QTEMP/AB#WP671)) +
                          OUTFILE(QTEMP/AB#WP31) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AB#S31) +
                          OPTION(*NOPRT)
             ENDDO
             DLTF       FILE(AB#WP671)

             IF         COND(&PTYPE *EQ '05') THEN(DO)
             CALL       PGM(AB#R3E) PARM(&PWEIG)
             GOTO       STEP3A
             ENDDO

             IF         COND(&PTYPE *EQ '06') THEN(DO)
             CALL       PGM(AB#R3F) PARM(&PWEIG)
             GOTO       STEP3A
             ENDDO

             IF         COND(&PTYPE *EQ '08') THEN(DO)
             CALL       PGM(AB#R3J) PARM(&PWEIG)
             GOTO       STEP3A
             ENDDO


/* CREATE WORK FILE OF MIXED PALLETE */
STEP3A:      DLTF       FILE(QTEMP/AB#WP44)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP44) RCDLEN(100) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(QTEMP/AB#WP4A)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP4A) RCDLEN(100) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)
             FMTDTA     INFILE((QTEMP/AB#WP31)) +
                          OUTFILE(QTEMP/AB#WP44) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AB#S4A) +
                          OPTION(*NOPRT)
/*           DLTF       FILE(AB#WP31)                                   */
             CALL       PGM(AB#R4A)

             DLTF       FILE(QTEMP/AB#WP4B)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP4B) RCDLEN(100) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)
             FMTDTA     INFILE((QTEMP/AB#WP4A)) +
                          OUTFILE(QTEMP/AB#WP4B) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AB#S4B) +
                          OPTION(*NOPRT)
             CALL       PGM(AB#R4B)

             DLTF       FILE(QTEMP/AB#WP4C)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP4C) RCDLEN(100) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)
             FMTDTA     INFILE((QTEMP/AB#WP4B)) +
                          OUTFILE(QTEMP/AB#WP4C) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AB#S4C) +
                          OPTION(*NOPRT)

 /* PRINT MIXED PALLETE */

             CALL       PGM(AB#R44) PARM(&PSIRE)
             DLTF       FILE(QTEMP/AB#WP44)
             DLTF       FILE(QTEMP/AB#WP4A)
             DLTF       FILE(QTEMP/AB#WP4B)
             DLTF       FILE(QTEMP/AB#WP4C)
             DLTOVR     FILE(*ALL)

 /* WARNING */
             IF         (&PFLG *EQ '*') DO
             SNDPGMMSG  MSG('PLEASE REGISTER UNIT PRICE BEFORE +
                          ISSUING EDI INVOICE DATA AND CANADA +
                          CUSTOM SHEET.') TOMSGQ(&WSID)
             ENDDO

             DLTOVR     FILE(*ALL)
 END:        ENDPGM
