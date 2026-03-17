             PGM        PARM(&JFILE &SDFILE &RCVHT &ERFILE &SFNM2 +
                          &SDRV &PIPGMN &OFILE)
             /** EJKC65 ********************************/
             /* HULFT SEND PROCESS                     */
             /*    **ORIGINAL IS JK915C FROM ASJ**     */
             /*  T.SAKAKI            2016.10.13        */
             /******************************* EJKC65 ***/
             DCL        VAR(&OFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JFILE) TYPE(*CHAR) LEN(12)
             DCL        VAR(&SDFILE) TYPE(*CHAR) LEN(32)
             DCL        VAR(&SFILE) TYPE(*CHAR) LEN(33)
             DCL        VAR(&FILEID) TYPE(*CHAR) LEN(13)
             DCL        VAR(&RCVHT) TYPE(*CHAR) LEN(12)
             DCL        VAR(&HOST) TYPE(*CHAR) LEN(71)
             DCL        VAR(&ERFILE) TYPE(*CHAR) LEN(32)
             DCL        VAR(&EFILE) TYPE(*CHAR) LEN(33)
             DCL        VAR(&SFNM2) TYPE(*CHAR) LEN(20)
             DCL        VAR(&MSGL0) TYPE(*CHAR) LEN(21)
             DCL        VAR(&EXT) TYPE(*CHAR) LEN(8)
             DCL        VAR(&SDRV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NULL) TYPE(*CHAR) LEN(1) VALUE(X'00')
             DCL        VAR(&PIPGMN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POWSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POUSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POKONA) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POSTTS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PKINP) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PKOUT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WS)    TYPE(*CHAR) LEN(3)
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS)    TYPE(*CHAR) LEN(3)
             DCL        VAR(&PTTL)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&PMSG)  TYPE(*CHAR) LEN(256)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 3))

      /*-------------------*/
      /* RECEIVING PROCESS */
      /*-------------------*/
             IF         COND(&SDRV *EQ 'R') THEN(DO)

          /*----------------------------------------------------*/
          /* CHECK MULTIPLE PROCESS CONTROL FILE                */
          /*     POSTTS = '1'  OK- CAN PROCESS                  */
          /*            = '2'  NG- PROCESSING BY PREVIOUS JOB   */
          /*----------------------------------------------------*/
             CALL       PGM(APLR85) PARM(&PIPGMN &POWSID &POUSID +
                          &POKONA &POSTTS)
       /* IF PREVIOUS HULFT JOB IS NOT COMPLETED  */
             IF         COND(&POSTTS *EQ '2') THEN(DO)
             CHGVAR     VAR(&PTTL) VALUE('HULFT_RCV GOT AN ERROR +
                          WHILE RECEIVING ' *CAT &PIPGMN)
             CHGVAR     VAR(&PMSG) VALUE('HULFT_RCV WAS FAILED. +
                          PLEASE CHECK AND TAKE CARE OF IT. FILE  +
                          IS ' *TCAT &PIPGMN *TCAT ' -> AND +
                          THEN,UNLOCK MULTIPLE PROCESS CONTROL FILE +
                          BY CALL APLR84')
             CALL       PGM(MSGC10) PARM(&PTTL &PMSG)
             GOTO       CMDLBL(@END)
             ENDDO

             CHGVAR     VAR(&FILEID) VALUE(&JFILE *CAT &NULL)
             CHGVAR     VAR(&HOST) VALUE(&RCVHT *CAT &NULL)
             CHGVAR     VAR(&EXT) VALUE('       ' *CAT &NULL)
                                       /*1234567*/

             CALL       PGM(HULFT/UTLRECV) PARM(&FILEID &ERFILE +
                          &HOST 'EXIT' &EXT)
         ENDDO

      /*******************/
      /* SENDING PROCESS */
      /*******************/
             IF         COND(&SDRV *EQ 'S') THEN(DO)

          /*----------------------------------------------------*/
          /* CHECK MULTIPLE PROCESS CONTROL FILE                */
          /*     POSTTS = '1'  OK- CAN PROCESS                  */
          /*            = '2'  NG- PROCESSING BY PREVIOUS JOB   */
          /*----------------------------------------------------*/
             CALL       PGM(APLR82) PARM(&PIPGMN &OFILE &POWSID +
                          &POUSID &POKONA &POSTTS)
       /* IF PREVIOUS HULFT JOB IS NOT COMPLETED  */
             IF         COND(&POSTTS *EQ '2') THEN(DO)
             CHGVAR     VAR(&PTTL) VALUE('HULFT_SND GOT AN ERROR +
                          WHILE SENDING ' *CAT &PIPGMN)
             CHGVAR     VAR(&PMSG) VALUE('HULFT_SND WAS FAILED. +
                          PLEASE CHECK AND TAKE CARE OF IT. FILE  +
                          IS ' *TCAT &PIPGMN *TCAT ' -> AND +
                          THEN,UNLOCK MULTIPLE PROCESS CONTROL FILE +
                          BY CALL APLR84')
             CALL       PGM(MSGC10) PARM(&PTTL &PMSG)
             GOTO       CMDLBL(@END)
             ENDDO

             CHGVAR     VAR(&FILEID) VALUE(&JFILE *CAT &NULL)
             CHGVAR     VAR(&SFILE) VALUE(&SDFILE *CAT &NULL)
             CHGVAR     VAR(&HOST) VALUE(&RCVHT *CAT &NULL)
             CHGVAR     VAR(&EFILE) VALUE(&ERFILE *CAT &NULL)
     /* FILE NAME 'S830FCO.TXT' */
             CHGVAR     VAR(&MSGL0) VALUE(&SFNM2 *CAT &NULL)
             CHGVAR     VAR(&EXT) VALUE('       ' *CAT &NULL)
                                       /*1234567*/

      /*----------------*/
      /* SEND BY HULFT  */
      /*----------------*/
             CALL       PGM(HULFT/UTLSEND) PARM(&FILEID &SFILE &HOST +
                          'SYNC' &MSGL0 &EFILE 'EXIT' &EXT)

         ENDDO

@END:        ENDPGM
