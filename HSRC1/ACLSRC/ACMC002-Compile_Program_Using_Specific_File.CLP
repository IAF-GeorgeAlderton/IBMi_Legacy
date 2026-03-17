             PGM        PARM(&PGMNAM &TOLIB &SRCTYP)

  /** ACMC002   **********************************/
  /* AUTO COMPILE PROGRAMS USING SPECIFIED FILE  */
  /*    LEC       2022.10.06                     */
  /***********************************************/

             DCL        VAR(&PGMNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SRCTYP) TYPE(*CHAR) LEN(8)
             DCL        VAR(&SRCFIL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SRCLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SRCMBR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MODTYP) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OBJATR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&COMPSTS) TYPE(*CHAR) LEN(4)

             DLTDTAARA  DTAARA(QTEMP/RETURNCODE)
             MONMSG     MSGID(CPF0000)

  /**********************************************************************/
  /* retrieve source information...                                     */

             RTVOBJD    OBJ(HOBJ1/&PGMNAM) OBJTYPE(*PGM) +
                          OBJATR(&OBJATR) SRCF(&SRCFIL) +
                          SRCFLIB(&SRCLIB) SRCMBR(&SRCMBR)

             MONMSG     MSGID(CPF9811) EXEC(DO)
             CHGVAR VAR(&COMPSTS) VALUE('SKIP')
             GOTO       CMDLBL(#LOG)
                                       ENDDO

             CHGVAR     VAR(&SRCTYP) VALUE(&OBJATR)

             IF         COND(&OBJATR = 'RPGLE') THEN(DO)
             CALL       PGM(ACMC003) PARM(&PGMNAM 'HOBJ1     ' +
                          &SRCFIL &SRCLIB &SRCMBR &MODTYP)
             CHGVAR     VAR(&SRCTYP) VALUE(&MODTYP)
             ENDDO

  /**********************************************************************/
             IF         COND(&SRCTYP = 'RPG') THEN(DO)
             CRTRPGPGM  PGM(&TOLIB/&PGMNAM) SRCFILE(&SRCLIB/&SRCFIL) +
                          SRCMBR(&SRCMBR) REPLACE(*YES) ALWNULL(*YES)
             ENDDO


             IF         COND(&SRCTYP = 'RPGLE') THEN(DO)
             CRTBNDRPG  PGM(&TOLIB/&PGMNAM) SRCFILE(&SRCLIB/&SRCFIL) +
                          SRCMBR(&SRCMBR) REPLACE(*YES) ALWNULL(*YES)
             ENDDO

  /*******************************************************************/

             RTVDTAARA  DTAARA(QTEMP/RETURNCODE (1 1)) RTNVAR(&RTN)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(#END))

             IF         COND(&RTN = '0') THEN(CHGVAR VAR(&COMPSTS) +
                          VALUE('FAIL'))

             IF         COND(&RTN = '1') THEN(CHGVAR VAR(&COMPSTS) +
                          VALUE('GOOD'))

  /*******************************************************************/
  /* call pgm to log compile status...                               */
 #LOG:       CALL       PGM(ACMR002) PARM(&PGMNAM &SRCLIB &SRCFIL +
                          &SRCMBR &SRCTYP &COMPSTS)
  /*******************************************************************/

 #END:       ENDPGM
