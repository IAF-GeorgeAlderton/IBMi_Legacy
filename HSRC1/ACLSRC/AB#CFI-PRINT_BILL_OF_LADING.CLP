             PGM
             /** AB#CFI *****************************/
             /*  ..PRINT BILL OF LADING..           */
             /*     A.MAMIYA         2000.10.27     */
             /***************************** AB#CFI **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&CAR)  TYPE(*CHAR) LEN(15)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)
             CHGJOB     SWS(00000000)

             CALL       PGM(AB#RFI) PARM(&CAR)

             IF         (%SWITCH(1XXXXXXX)) DO
             GOTO       CMDLBL(@END)
             ENDDO

             FMTDTA     INFILE((&WLIB/AB#WPFI1)) +
                          OUTFILE(&WLIB/AB#WPFI2) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AB#SFI) +
                          OPTION(*NOPRT)

             CALL       PGM(AB#RFJ) PARM(&CAR)

 @END:       ENDPGM
