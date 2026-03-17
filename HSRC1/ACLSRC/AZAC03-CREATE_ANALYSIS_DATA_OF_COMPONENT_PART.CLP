             PGM
             /** AZAC03 **********************************************/
             /*  CREATE ANALYSIS DATA OF COMPONENT PART              */
             /*                                                      */
             /*  TCH 01.03.29                                        */
             /*  TCH 01.06.26 ORDER DATE -> ORDER NUMBER             */
             /********************************************** AZAC03 **/
             DCLF       FILE(AZAPW03)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&US)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&FLAG)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID) USER(&US)
             CHGJOB     SWS(00000000)

             CALL       PGM(ALBC00) PARM(&US &WLIB)

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(AZAPW011)

             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&IN01 *EQ '1') GOTO END



 STP3:
             IF         (&IN05 *EQ '0') GOTO STP1

             CLRPFM     FILE(&WLIB/AZAPP03)
             CLRPFM     FILE(&WLIB/AZAPP30)

 /* CREATE WORK FILE */
             CALL       PGM(AZAR03) PARM(&US &PNOHZ &FLAG)

             OVRPRTF    FILE(QPQUPRFIL) OUTQ(QPRINTB)
             RUNQRY     QRY(HOBJ1/QAZAPP03)
             RUNQRY     QRY(HOBJ1/QAZAPP30)

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
