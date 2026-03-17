             PGM
             /*** GADC42 ********************************************/
             /*  DOWNLOAD OF EXTENTED BIN MASTER (FOR SHIPMENT M/F) */
             /*                                                     */
             /*   KIRI                2017.07.11                    */
             /*******************************************************/
             DCL        VAR(&WSID)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)      TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB)     TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)     TYPE(*CHAR) LEN(8)
             DCL        VAR(&SNAM)     TYPE(*CHAR) LEN(30)
             DCL        VAR(&GADWP42)  TYPE(*CHAR) LEN(10)

             DCL        VAR(&REC)      TYPE(*DEC)  LEN(10 0) VALUE(0)


             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

             CHGJOB     OUTQ(&PRTG)
  STP01:
             CHGVAR     VAR(&GADWP42) -
                                  VALUE('GADWP42' *CAT %SST(&WSID 1 3))
             DLTF       FILE(&WLIB/&GADWP42)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&GADWP42) RCDLEN(512) +
                          IGCDTA(*YES) OPTION(*NOLIST *NOSRC) +
                          SIZE(1000 3000 3) LVLCHK(*NO) AUT(*ALL)

  STP02:
             OVRDBF     FILE(GADWP42) TOFILE(&WLIB/&GADWP42)
             CALL       GADR42
             DLTOVR     FILE(GADWP42)

             RTVMBRD    FILE(&WLIB/&GADWP42)  NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(GOTO CMDLBL(END))
        /*------------------------------------------------------*/
    /*--------------------------*/
    /* DOWNLOAD CSV DATA (TEMP) */
    /*--------------------------*/
             CPYF       FROMFILE(&WLIB/&GADWP42) +
                          TOFILE(&WLIB/GADWP4X) MBROPT(*REPLACE) +
                          CRTFILE(*YES) FMTOPT(*NOCHK)
             STRPCO     PCTA(*NO)
             MONMSG     MSGID(CPF0000)
             STRPCCMD   PCCMD('"C:/PROGRAM FILES/IBM/CLIENT +
                          ACCESS/RTOPCB.EXE" +
                          C:/AS400/TTO/GADWP42.DTF') PAUSE(*NO)

    /*----------------------*/
    /* SAVE CSV DATA TO IFS */
    /*----------------------*/
               CHGVAR     VAR(&SNAM) VALUE('EXTENTED BIN MASTER')

      /*JW1*** CALL ***   PGM(APLC91) PARM('3' &GADWP42 &WLIB &SNAM)  ***/
               CALL       PGM(APLC94) PARM('1' &GADWP42 &WLIB &SNAM 'Y' '' 'Y')
 END:
             ENDPGM
