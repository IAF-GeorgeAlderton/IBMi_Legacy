             PGM        PARM(&CLR)
             /** AB#C0F ****************************************************/
             /*  EDI(856) GENTRAN                                          */
             /*  TEST AB#R0F                                               */
             /*  J.WATANABE   2025.03.05                                   */
             /**************************************************************/

             DCL        VAR(&CLR )  TYPE(*CHAR) LEN(1)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&FLAG)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PERR)  TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CHGJOB     SWS(00000000)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGVAR     VAR(&WLIB) VALUE('TWFILE1')

  /* CREATE WORK FILES  */
             DLTF       FILE(QTEMP/AB#WP0F)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(AB#WP0F) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/AB#WP0F

             DLTF       FILE(QTEMP/MITANKF)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(MITANKF) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/MITANKF)

             DLTF       FILE(QTEMP/AB#WP34)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(AB#WP34) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/AB#WP34

             DLTF       FILE(QTEMP/AB#WP0G)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(AB#WP0G) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/AB#WP0G

             DLTF       FILE(QTEMP/AB#PPCT)
             MONMSG     MSGID(CPF0000)
             CPYF       FROMFILE(HFILE1/AB#PPCT) +
                          TOFILE(QTEMP/AB#PPCT) MBROPT(*REPLACE) +
                          CRTFILE(*YES)
             MONMSG     MSGID(CPF0000)

             DLTF       FILE(QTEMP/AB#PP2G)
             MONMSG     MSGID(CPF0000)
             CPYF       FROMFILE(HFILE1/AB#PP2G) +
                          TOFILE(QTEMP/AB#PP2G) MBROPT(*REPLACE) +
                          CRTFILE(*YES)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(AB#PL2H) FROMLIB(HFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             DLTF       FILE(QTEMP/AB#PP42)
             MONMSG     MSGID(CPF0000)
             CPYF       FROMFILE(HFILE1/AB#PP42) +
                          TOFILE(QTEMP/AB#PP42) MBROPT(*REPLACE) +
                          CRTFILE(*YES)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(AB#PL42) FROMLIB(HFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(AB#PL2G) FROMLIB(HFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             DLTF       FILE(QTEMP/AB#PP47)
             MONMSG     MSGID(CPF0000)
             CPYF       FROMFILE(HFILE1/AB#PP47) +
                          TOFILE(QTEMP/AB#PP47) MBROPT(*REPLACE) +
                          CRTFILE(*YES)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(AB#PL49) FROMLIB(HFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             DLTF       FILE(QTEMP/AB#PP75)
             MONMSG     MSGID(CPF0000)
             CPYF       FROMFILE(HFILE1/AB#PP75) +
                          TOFILE(QTEMP/AB#PP75) MBROPT(*REPLACE) +
                          CRTFILE(*YES)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(AB#PL75) FROMLIB(HFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(AB#PL76) FROMLIB(HFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(MITANKF) TOFILE(QTEMP/MITANKF)
             OVRDBF     FILE(AB#WP0F) TOFILE(QTEMP/AB#WP0F)
             OVRDBF     FILE(AB#WP34) TOFILE(QTEMP/AB#WP34)
             OVRDBF     FILE(AB#WP0G) TOFILE(QTEMP/AB#WP0G)

             OVRDBF     FILE(AB#PPCT) TOFILE(QTEMP/AB#PPCT)
             OVRDBF     FILE(AB#PP2G) TOFILE(QTEMP/AB#PP2G)
             OVRDBF     FILE(AB#PL2H) TOFILE(QTEMP/AB#PL2H)
             OVRDBF     FILE(AB#PL2G) TOFILE(QTEMP/AB#PL2G)
             OVRDBF     FILE(AB#PP47) TOFILE(QTEMP/AB#PP47)
             OVRDBF     FILE(AB#PL49) TOFILE(QTEMP/AB#PL49)
             OVRDBF     FILE(AB#PP42) TOFILE(QTEMP/AB#PP42)
             OVRDBF     FILE(AB#PL42) TOFILE(QTEMP/AB#PL42)
             OVRDBF     FILE(AB#PL75) TOFILE(QTEMP/AB#PL75)
             OVRDBF     FILE(AB#PL76) TOFILE(QTEMP/AB#PL76)

             OVRDBF     FILE(AB#EP75) TOFILE(TFILE1/AB#EP75)
             OVRDBF     FILE(AB#EP76) TOFILE(TFILE1/AB#EP76)
             OVRDBF     FILE(AB#EP63) TOFILE(TFILE1/AB#EP63)
             OVRDBF     FILE(AB#EP72) TOFILE(TFILE1/AB#EP72)
             OVRDBF     FILE(AB#EP53) TOFILE(TFILE1/AB#EP53)
             OVRDBF     FILE(AB#EP54) TOFILE(TFILE1/AB#EP54)
             OVRDBF     FILE(AB#EP55) TOFILE(TFILE1/AB#EP55)
             OVRDBF     FILE(AB#EP56) TOFILE(TFILE1/AB#EP56)
             OVRDBF     FILE(AB#EL57) TOFILE(TFILE1/AB#EL57)
             OVRDBF     FILE(AB#EP58) TOFILE(TFILE1/AB#EP58)
             OVRDBF     FILE(AB#EP78) TOFILE(TFILE1/AB#EP78)
             OVRDBF     FILE(AB#EP6A) TOFILE(TFILE1/AB#EP6A)

     /**     OVRDBF     FILE(AB#HP20) TOFILE(TFILE1/AB#HP20)     **/
     /**     OVRDBF     FILE(AB#PL30) TOFILE(TFILE1/AB#PL30)     **/
     /**     OVRDBF     FILE(AB#PP78) TOFILE(TFILE1/AB#PP78)     **/
     /**     OVRDBF     FILE(AB#PL79) TOFILE(TFILE1/AB#PL79)     **/

     /**     OVRDBF     FILE(AB#PL66) TOFILE(TFILE1/AB#PL66)     **/
     /**     OVRDBF     FILE(AB#PL67) TOFILE(TFILE1/AB#PL67)     **/
     /**     OVRDBF     FILE(AB#PL77) TOFILE(TFILE1/AB#PL77)     **/

             OVRDBF     FILE(AB#EP60)  TOFILE(TFILE2/AB#EP60)
             OVRDBF     FILE(AB#EL6A)  TOFILE(TFILE2/AB#EL6A)
             OVRDBF     FILE(AB#EL60B) TOFILE(TFILE2/AB#EL60B)
             OVRDBF     FILE(AB#EP61)  TOFILE(TFILE2/AB#EP61)
             OVRDBF     FILE(AB#EP62)  TOFILE(TFILE2/AB#EP62)
             OVRDBF     FILE(AB#EP77)  TOFILE(TFILE2/AB#EP77)

    /** USE TFILE1 FOR AB#PP10/AB#PPA1                         **/
             OVRDBF     FILE(AB#PL08)  TOFILE(TFILE1/AB#PL08)
             OVRDBF     FILE(AB#PL1A)  TOFILE(TFILE1/AB#PL1A)
             OVRDBF     FILE(AB#PL13)  TOFILE(TFILE1/AB#PL13)
             OVRDBF     FILE(AB#PL11)  TOFILE(TFILE1/AB#PL11)

             IF         COND(&CLR *EQ 'Y') THEN(DO)
             CLRPFM     FILE(TFILE2/AB#EP60)
             CLRPFM     FILE(TFILE2/AB#EP61)
             CLRPFM     FILE(TFILE2/AB#EP62)
             CLRPFM     FILE(TFILE2/AB#EP77)
             CLRPFM     FILE(TWFILE1/AB#WP7A)
             ENDDO

             CALL       PGM(TOBJ1/AB#R0F) PARM(&FLAG  &PERR)

             DLTOVR     FILE(*ALL)
 END:

 SKP:
             ENDPGM
