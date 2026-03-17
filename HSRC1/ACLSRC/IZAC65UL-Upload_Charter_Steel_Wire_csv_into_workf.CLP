/** IZAC65UL  *********************************************/
/*  UPLOAD CHARTER STEEL WIRE .CSV INTO WORK FILE         */
/*                                                        */
/* LEC   09/18/2025   CREATE                              */
/**********************************************************/

             PGM

             DCL        VAR(&PATH) TYPE(*CHAR) LEN(150)
             DCL        VAR(&FPATH) TYPE(*CHAR) LEN(150)
             DCL        VAR(&APATH) TYPE(*CHAR) LEN(150)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(20) +
                          VALUE('CSWIRE')
             DCL        VAR(&NEWNAME) TYPE(*CHAR) LEN(40)
             DCL        VAR(&CDATE) TYPE(*CHAR) LEN(20)
             DCL        VAR(&LMSG) TYPE(*CHAR) LEN(150)
             DCL        VAR(&RCDS) TYPE(*DEC) LEN(10 0)

             DCL        VAR(&HOSTN) TYPE(*CHAR) LEN(20) VALUE('CHARTERMFG')
             DCL        VAR(&DAY) TYPE(*CHAR) LEN(02) VALUE('00')
             DCL        VAR(&MONTH) TYPE(*CHAR) LEN(02) VALUE('00')
             DCL        VAR(&CPYPATH) TYPE(*CHAR) LEN(150)
             DCL        VAR(&FILEN) TYPE(*CHAR) LEN(100)
             DCL        VAR(&NEWFILE) TYPE(*CHAR) LEN(100)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(200)
             DCL        VAR(&LOOP) TYPE(*CHAR) LEN(01) VALUE('Y')
             DCL        VAR(&PATHFILE) TYPE(*CHAR) LEN(50)


             ADDLIBLE SFTPLIB *FIRST
             MONMSG     MSGID(CPF2103)

             /* Attempt to Download files from the host */
             call sftpgetc parm(&HOSTN &DAY &MONTH)

   #LOOP:
             /* Request an unprocessed fle from the SFTPLOGPF file */
             CHGVAR VAR(&FILEN) VALUE(' ')

             /* Get eligible unprocessed files for this host */
             CALL SFTPGETIFS PARM(&HOSTN &MSG &FILEN 'G')

             /* Exit loop if no file name was retrieved */
             IF COND(%TRIM(&FILEN) *EQ ' ') THEN(GOTO #END)

             /* Make a copy of the downloaded host file  */
             CHGVAR VAR(&NEWFILE) VALUE('CSWIRE.CSV')
             CHGVAR VAR(&PATH) VALUE('/home/CHST4540/incoming/')
             /* -- Line below is for testing -- */
             /* CHGVAR VAR(&PATH) VALUE('/home/I0775/incoming/') */

             CHGVAR VAR(&CPYPATH) VALUE(&PATH *TCAT &NEWFILE)
             CHGVAR VAR(&PATHFILE) VALUE(&path *tcat &fileN)
             CPY OBJ(&PATHFILE) TOOBJ(&CPYPATH) REPLACE(*YES)

  /* clear workfile...                                           */
             CLRPFM     FILE(IZAWP10)
             MONMSG     MSGID(CPF0000)

  /* get current date...                                         */
             RTVJOBA    DATETIME(&CDATE)
             MONMSG     MSGID(CPF0000)

  /* upload charter steel data in .csv to workfile...            */

     /* main path */
             CHGVAR     VAR(&PATH) VALUE('/home/CHST4540/incoming/')
             /* -- Line below is for testing -- */
             /* CHGVAR     VAR(&PATH) VALUE('/home/I0775/incoming/') */

     /* file path */
             CHGVAR     VAR(&FPATH) VALUE(&PATH *TCAT &FILE *TCAT +
                          '.CSV')

            CPYFRMIMPF FROMSTMF(&FPATH) TOFILE(HWFILE1/IZAWP10) +
                          MBROPT(*REPLACE) FROMCCSID(*FILE) +
                          RCDDLM(*LF) STRDLM(*DBLQUOTE) +
                          DATFMT(*USA) TIMFMT(*USA) ERRRCDOPT(*REPLACE)
        /* file not found       */
             MONMSG     MSGID(CPF2817) EXEC(DO)
                        GOTO       CMDLBL(#END)
                        ENDDO
  /*                                                             */

             RTVMBRD    FILE(IZAWP10) NBRCURRCD(&RCDS)
             MONMSG     MSGID(CPF0000)


  /*                                                             */
             IF         COND(&RCDS > 0) THEN(DO)


  /* REMOVE ANY NULL THAT MAY SHOW UP IN THE LAST FIELD (MFS)    */
             RUNSQLSTM  SRCFILE(SFTPLIB/QSQLSRC) SRCMBR(IZAPW10NUL) +
                          COMMIT(*NONE)

  /* process workfile, writing it to Wire Coil MF                */
             CALL       PGM(IZAR465UL)


             SNDDST     TYPE(*LMSG) TOINTNET((JONATHON.JULSON@IAFI.COM)) +
                          DSTD('Charter Steel Upload File +
                          Received') LONGMSG(&LMSG)

             SNDDST     TYPE(*LMSG) TOINTNET((MARK.SNYDER@IAFI.COM)) +
                          DSTD('Charter Steel Upload File +
                          Received') LONGMSG(&LMSG)


  /* archive path */
             CHGVAR     VAR(&APATH) VALUE(&PATH *TCAT +
                          'Archive/ChSteel/')

  /* rename file so it can be archived                           */
             CHGVAR     VAR(&NEWNAME) VALUE(&FILE *TCAT '_' *TCAT +
                          &CDATE *TCAT '.CSV')

             RNM        OBJ(&FPATH) NEWOBJ(&NEWNAME)

  /* move file to archived folder                                */
     /* file path */
             CHGVAR     VAR(&FPATH) VALUE(&PATH *TCAT &NEWNAME)

             MOV        OBJ(&FPATH) TODIR(&APATH)

                        ENDDO
 #UPDATE:
              /* Remove  Original Host File */
              RMVLNK OBJLNK(&PATHFILE)

               /* UPDATE THE SFTPLOGPF Processed Date and Time  */
              CALL SFTPGETIFS PARM(&HOSTN &MSG &FILEN 'U')
              GOTO #LOOP

  /* ENDDO   IF %TRIM*&FILE) *NE ' '  */


 #END:       ENDPGM
