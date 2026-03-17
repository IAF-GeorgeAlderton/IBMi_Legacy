             PGM
             /*** GAHC31 ************************************/
             /*  DOWNLOAD OF TRANSPORTATION M/F             */
             /*   KIRI              2017.07.03              */
             /***********************************************/
             DCL        VAR(&WSID)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)      TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB)     TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)     TYPE(*CHAR) LEN(8)
             DCL        VAR(&SNAM)     TYPE(*CHAR) LEN(23)
             DCL        VAR(&GAHWP31)  TYPE(*CHAR) LEN(10)

             DCL        VAR(&REC)      TYPE(*DEC)  LEN(10 0) VALUE(0)


             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

             CHGJOB     OUTQ(&PRTG)
  STP01:
             CHGVAR     VAR(&GAHWP31) -
                                  VALUE('GAHWP31' *CAT %SST(&WSID 1 3))
             DLTF       FILE(&WLIB/&GAHWP31)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&GAHWP31) RCDLEN(512) +
                          IGCDTA(*YES) OPTION(*NOLIST *NOSRC) +
                          SIZE(1000 3000 3) LVLCHK(*NO) AUT(*ALL)

  STP02:
             OVRDBF     FILE(GAHWP31) TOFILE(&WLIB/&GAHWP31)
             CALL       GAHR31
             DLTOVR     FILE(GAHWP31)

             RTVMBRD    FILE(&WLIB/&GAHWP31)  NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(GOTO CMDLBL(END))
        /*------------------------------------------------------*/
    /*--------------------------*/
    /* DOWNLOAD CSV DATA (TEMP) */
    /*--------------------------*/
             CPYF       FROMFILE(&WLIB/&GAHWP31) +
                          TOFILE(&WLIB/GAHWP3X) MBROPT(*REPLACE) +
                          CRTFILE(*YES) FMTOPT(*NOCHK)
             STRPCO     PCTA(*NO)
             MONMSG     MSGID(CPF0000)
             STRPCCMD   PCCMD('"C:/PROGRAM FILES/IBM/CLIENT +
                          ACCESS/RTOPCB.EXE" +
                          C:/AS400/TTO/GAHWP31.DTF') PAUSE(*NO)

    /*----------------------*/
    /* SAVE CSV DATA TO IFS */
    /*----------------------*/
             CHGVAR     VAR(&SNAM) VALUE('TRANSPORTAION MASTER')
             CALL       PGM(APLC91) PARM('3' &GAHWP31 &WLIB &SNAM)
        /*------------------------------------------------------*/
 END:
             ENDPGM
