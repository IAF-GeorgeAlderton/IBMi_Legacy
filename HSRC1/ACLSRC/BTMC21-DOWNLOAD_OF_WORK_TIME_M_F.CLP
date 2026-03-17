             PGM
             /*** BTMC21 ************************************/
             /*  DOWNLOAD OF WORK TIME M/F                  */
             /*   KIRI              2017.06.28              */
             /***********************************************/
             DCL        VAR(&WSID)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)      TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB)     TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)     TYPE(*CHAR) LEN(8)
             DCL        VAR(&SNAM)     TYPE(*CHAR) LEN(23)
             DCL        VAR(&BTMWP21)  TYPE(*CHAR) LEN(10)

             DCL        VAR(&REC)      TYPE(*DEC)  LEN(10 0) VALUE(0)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

             CHGJOB     OUTQ(&PRTG)
  STP01:
             CHGVAR     VAR(&BTMWP21) -
                                  VALUE('BTMWP21' *CAT %SST(&WSID 1 3))
             DLTF       FILE(&WLIB/&BTMWP21)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&BTMWP21) RCDLEN(512) +
                          IGCDTA(*YES) OPTION(*NOLIST *NOSRC) +
                          SIZE(1000 3000 3) LVLCHK(*NO) AUT(*ALL)

  STP02:
             OVRDBF     FILE(BTMWP21) TOFILE(&WLIB/&BTMWP21)
             CALL       BTMR21
             DLTOVR     FILE(BTMWP21)

             RTVMBRD    FILE(&WLIB/&BTMWP21)  NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(GOTO CMDLBL(END))
        /*------------------------------------------------------*/
    /*--------------------------*/
    /* DOWNLOAD CSV DATA (TEMP) */
    /*--------------------------*/
             CPYF       FROMFILE(&WLIB/&BTMWP21) +
                          TOFILE(&WLIB/BTMWP2X) MBROPT(*REPLACE) +
                          CRTFILE(*YES) FMTOPT(*NOCHK)
             STRPCO     PCTA(*NO)
             MONMSG     MSGID(CPF0000)
             STRPCCMD   PCCMD('"C:/PROGRAM FILES/IBM/CLIENT +
                          ACCESS/RTOPCB.EXE" +
                          C:/AS400/TTO/BTMWP21.DTF') PAUSE(*NO)

    /*----------------------*/
    /* SAVE CSV DATA TO IFS */
    /*----------------------*/
             CHGVAR     VAR(&SNAM) VALUE('WORK TIME MASTER')
             CALL       PGM(APLC91) PARM('3' &BTMWP21 &WLIB &SNAM)
        /*------------------------------------------------------*/
 END:
             ENDPGM
