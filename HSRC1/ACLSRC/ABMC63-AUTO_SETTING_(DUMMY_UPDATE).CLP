             PGM
             /** ABMC63 ************************/
             /* AUTO SETTING (DUMMY UPDATE)    */
             /*   SAKAKI.         2019.11.05   */
             /**********************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&FLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&DDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&P@NTYM) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&P@ERR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&P1KIHZ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&MBAN)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG@) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID) USER(&PPUSER) DATE(&DDATE)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO

 STP00:
 STP2:
 STP10:

             CPYF       FROMFILE(&FLIB/FCEPP01) +
                          TOFILE(&FLIB/FCFPP01) MBROPT(*REPLACE) +
                          CRTFILE(*YES) FMTOPT(*MAP *DROP)
             CPYF       FROMFILE(&FLIB/FCEPP11) +
                          TOFILE(&FLIB/FCFPP11) MBROPT(*REPLACE) +
                          CRTFILE(*YES) FMTOPT(*MAP *DROP)
             CPYF       FROMFILE(&FLIB/GHCPP21) +
                          TOFILE(&FLIB/GHDPP21) MBROPT(*REPLACE) +
                          CRTFILE(*YES) FMTOPT(*MAP *DROP)
       /* ABMWP21 <-> FCFPP01 */
       /*         <-> FCFPP11 */
       /*         <-> GHDPP21 */
             CALL       PGM(ABMRL5)

      /*----------------------------------*/
      /* UPDATE  GHCPP21                  */
      /*----------------------------------*/
             CALL       PGM(ABMRLX)

           /* AAFPP01   PLATING KANBAN  */
             CALL       PGM(ABMRM1)

           /* AAHPP01   PART WITHDRAWAL */
             CALL       PGM(ABMRM2)

           /* ABHPP01   PRODUCTION      */
             CALL       PGM(ABMRM5)

           /* ADHPP01   HEAT TREATMENT  */
             CALL       PGM(ABMRM6)

           /* AAPPP01   FINISHED PARTS  */
             CALL       PGM(ABMRM3)

           /* AANPP01   HALF FINISHED PARTS */
             CALL       PGM(ABMRM4)

 #END:

 END:        ENDPGM
