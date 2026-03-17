             PGM
             /** AFDC10 **********************************************/
             /* INQUIRY                                              */
             /* <LOCAL PROCURMENT SYSTEM>                            */
             /*    CREATE DATE  2001.12.17                           */
             /*----------------------------------                    */
             /* JW1    2023.10.11 ADD DOWNLOAD TO CSV                */
             /********************************************************/
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&SUPP)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&SUPX)  TYPE(*CHAR) LEN(1)

             DCL        VAR(&FNAM) TYPE(*CHAR) LEN(30)
             DCL        VAR(&KEN)  TYPE(*DEC)  LEN(10 0)

             RTVJOBA    JOB(&WSID)  USER(&USER)

             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CLRPFM     FILE(&WLIB/AFDWP05)
             CALL       PGM(AFDR10)

       /********************************/
       /* DOWNLOAD AFDWP05 TO CSV      */
       /********************************/

             RTVMBRD    FILE(HWFILE1/AFDWP05 ) NBRCURRCD(&KEN)

             IF         (&KEN *LE 1) THEN(DO)
             GOTO       ENDP
             ENDDO

             IF         (&KEN *GT 1) THEN(DO)
             CHGVAR     VAR(&FNAM) VALUE('OUTSRC_ODR' *BCAT '9999')
             CALL       PGM(APLC97) PARM('2' 'AFDWP05 ' 'HWFILE1' &FNAM +
                          'Y' ' ' 'Y')
             ENDDO
 ENDP:
             ENDPGM
