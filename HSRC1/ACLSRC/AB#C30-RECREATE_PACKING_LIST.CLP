             PGM
             /** AB#C30 **********************************************/
             /*  ..EDI PICK-UP     LIST..                            */
             /*  I-HASADA        97.06.26                            */
             /*  TCH 00.02.02 CHANGE NUMBER OF PAGES                 */
             /*  TCH 00.02.02 ADD DELIVERY CODE                      */
             /*  TCH 00.02.07 CHANGE NUMBER  OF COPIES               */
             /*  TCH 00.03.01 CHANGE TYPE LIST                       */
             /*  TCH 00.05.18 USE NUMBER OF PAGES OF MASTER          */
             /*  TCH 00.08.17 CHANGE DEFALT WEIGHT                   */
             /*  TCH 00.09.11 DENSO(MI)                              */
             /*  TCH 01.02.23 ADD INVOICE NUMBER                     */
             /*  TCH 01.03.15 ADD PARAMETER FOR NAME OF COUNTRY      */
             /*  TCH 01.03.22 RE-CREATE AB#C30                       */
             /********************************************** AB#C30 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SSID) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)

             /* JW */
             GOTO       CMDLBL(END)

             RTVJOBA    JOB(&WSID) USER(&US)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CALL       PGM(ALBC00) PARM(&US &WLIB)


             CHGVAR     VAR(&SSID) VALUE(%SUBSTRING(&WSID 1 3))

             CHKOBJ     OBJ(&WLIB/AB#PP31) OBJTYPE(*FILE) MBR(&SSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM +
                          FILE(&WLIB/AB#PP31) MBR(&SSID))

             CHKOBJ     OBJ(&WLIB/AB#PL31) OBJTYPE(*FILE) MBR(&SSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDLFM +
                          FILE(&WLIB/AB#PL31) MBR(&SSID) +
                          DTAMBRS((&WLIB/AB#PP31 (&SSID))))

             CHKOBJ     OBJ(&WLIB/AB#PL32) OBJTYPE(*FILE) MBR(&SSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDLFM +
                          FILE(&WLIB/AB#PL32) MBR(&SSID) +
                          DTAMBRS((&WLIB/AB#PP31 (&SSID))))

             CHKOBJ     OBJ(&WLIB/AB#PL33) OBJTYPE(*FILE) MBR(&SSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDLFM +
                          FILE(&WLIB/AB#PL33) MBR(&SSID) +
                          DTAMBRS((&WLIB/AB#PP31 (&SSID))))

             CHKOBJ     OBJ(AB#WP60) OBJTYPE(*FILE) MBR(&SSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM +
                          FILE(AB#WP60) MBR(&SSID))

             CLRPFM     FILE(&WLIB/AB#PP31) MBR(&SSID)
             CLRPFM     FILE(AB#WP60) MBR(&SSID)

             OVRDBF     FILE(AB#PP31) TOFILE(&WLIB/AB#PP31) MBR(&SSID)
             OVRDBF     FILE(AB#PL31) TOFILE(&WLIB/AB#PL31) MBR(&SSID)
             OVRDBF     FILE(AB#PL32) TOFILE(&WLIB/AB#PL32) MBR(&SSID)
             OVRDBF     FILE(AB#PL33) TOFILE(&WLIB/AB#PL33) MBR(&SSID)
             OVRDBF     FILE(AB#WP60) TOFILE(AB#WP60) MBR(&SSID)

             OVRPRTF    FILE(AB#PR44) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) RPLUNPRT(*YES) OUTQ(LANPRT02) +
                          FORMTYPE(K6S1) COPIES(2)

             CALL       PGM(AB#R3P) PARM(&SSID)

             DLTOVR     FILE(*ALL)

 END:        ENDPGM
