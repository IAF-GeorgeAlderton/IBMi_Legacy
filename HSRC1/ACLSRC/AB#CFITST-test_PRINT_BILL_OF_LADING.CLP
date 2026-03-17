             PGM
             /** AB#CFI *****************************/
             /*  TEST AB#RFI                        */
             /*  JW   2025.11.06                    */
             /***************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&CAR)  TYPE(*CHAR) LEN(15)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)
             CHGJOB     SWS(00000000)

/** TEST **/
             CHGVAR     VAR(&WLIB) VALUE('TWFILE1')
             OVRDBF     FILE(AB#WPFI1 ) TOFILE(&WLIB/AB#WPFI1)
/*********   CALL       PGM(AB#CFJTST) ******/

             CALL       PGM(AB#RFI) PARM(&CAR)

             GOTO       CMDLBL(ENDP)

             FMTDTA     INFILE((&WLIB/AB#WPFI1)) +
                          OUTFILE(&WLIB/AB#WPFI2) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AB#SFI) +
                          OPTION(*NOPRT)

/**/         OVRDBF     FILE(AB#WPFI2 ) TOFILE(&WLIB/AB#WPFI2)
/**/         OVRDBF     FILE(ABFFP01  ) TOFILE(TFILE1/ABFFP01 )

             CALL       PGM(AB#RFJ) PARM(&CAR)


 ENDP:
             DLTOVR     FILE(*ALL)
             ENDPGM
