             PGM
             /** AZAC01 **********************************************/
             /*  CREATE ANALYSIS DATA OF MATERIAL                    */
             /*                                                      */
             /*  TCH 01.03.30                                        */
             /********************************************** AZAC04 **/
             DCLF       FILE(AZAPW04)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&US)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&FLAG)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID) USER(&US)
             CHGJOB     SWS(00000000)

             CALL       PGM(ALBC00) PARM(&US &WLIB)

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(AZAPW041)

             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&IN01 *EQ '1') GOTO END

 STP3:
             IF         (&IN05 *EQ '0') GOTO STP1

             CLRPFM     FILE(&WLIB/AZAPP04)
             CLRPFM     FILE(&WLIB/AZAPP40)

 /* CREATE WORK FILE */
             CALL       PGM(AZAR04) PARM(&US &PODRN &FLAG)

             OVRPRTF    FILE(QPQUPRFIL) OUTQ(QPRINTB)
             RUNQRY     QRY(HOBJ1/QAZAPP04)
             RUNQRY     QRY(HOBJ1/QAZAPP40)

             IF         (&FLAG *EQ ' ') DO
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) +
                          VALUE('THERE IS NO DATA')
             GOTO       STP1
             ENDDO

 END:
             DLTOVR     FILE(*ALL)
             ENDPGM
