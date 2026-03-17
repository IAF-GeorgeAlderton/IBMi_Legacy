             PGM
             /** AB#CAS ******************************************/
             /* SHIP/SCHEDULE BOXES INQRUIRY                     */
             /*   HOTTA.           2018.09.06                    */
             /*   JW1   2020.08.12 ADD AB#WPAR                   */
             /*   JW2   2021.03.04 ADD AB#WPAO                   */
             /*         2021.03.08 USE QTEMP FOR WORK FILE       */
             /*   JW3   2021.05.12 ADD AB#WPAP                   */
             /*         2021.06.16 ADD AB#WPAQ                   */
             /****************************************************/
             DCL        VAR(&WSID)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&REC)     TYPE(*DEC)  LEN(10 0)
             DCL        VAR(&WLIB)    TYPE(*CHAR) LEN(8)
             DCL        VAR(&FLIB)    TYPE(*CHAR) LEN(8)
             DCL        VAR(&DDATE)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&AB#WPAR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AB#WPAS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AB#WPAT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3)     TYPE(*CHAR) LEN(3)

       /*JW2 DCL        VAR(&P@NTYM)  TYPE(*DEC) LEN(6 0)   ***/
       /*JW2 DCL        VAR(&P@ERR)   TYPE(*CHAR) LEN(1)    ***/
       /*JW2 DCL        VAR(&PCMD)    TYPE(*CHAR) LEN(2)    ***/

             RTVJOBA    JOB(&WSID) USER(&USER) DATE(&DDATE)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&USER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO

             CHGVAR     VAR(&AB#WPAR) VALUE('AB#WPAR' *CAT &WS3)
             CHGVAR     VAR(&AB#WPAS) VALUE('AB#WPAS' *CAT &WS3)
             CHGVAR     VAR(&AB#WPAT) VALUE('AB#WPAT' *CAT &WS3)
 STP10:
         /* JW1 */
             DLTF       FILE(QTEMP/AB#WPAR)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WPAR) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AB#WPAR) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 5000 20) LVLCHK(*NO) AUT(*ALL)

         /* JW2 */
             DLTF       FILE(QTEMP/AB#WPAO)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ OBJ(AB#WPAO) FROMLIB(HWFILE1) OBJTYPE(*FILE) TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

         /* JW3 */
             DLTF       FILE(QTEMP/AB#WPAP)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ OBJ(AB#WPAP) FROMLIB(HWFILE1) OBJTYPE(*FILE) TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
         /* JW3 */
             DLTF       FILE(QTEMP/AB#WLAQ)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/AB#WLAQ)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ OBJ(AB#WPAQ) FROMLIB(HWFILE1) OBJTYPE(*FILE) TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             DLTF       FILE(QTEMP/AB#WPAS)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WPAS) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AB#WPAS) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 5000 20) LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(QTEMP/AB#WPAT)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WPAT) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AB#WPAT) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 5000 20) LVLCHK(*NO) AUT(*ALL)

      /*JW2  OVRDBF     FILE(AB#WPAR) TOFILE(&WLIB/&AB#WPAR)   ***/
      /*JW2  OVRDBF     FILE(AB#WPAS) TOFILE(&WLIB/&AB#WPAS)   ***/
      /*JW2  OVRDBF     FILE(AB#WPAT) TOFILE(&WLIB/&AB#WPAT)   ***/

             OVRDBF     FILE(AB#WPAR) TOFILE(QTEMP/AB#WPAR)
             OVRDBF     FILE(AB#WPAS) TOFILE(QTEMP/AB#WPAS)
             OVRDBF     FILE(AB#WPAT) TOFILE(QTEMP/AB#WPAT)
 /**JW2**/
             OVRDBF     FILE(AB#WPAO) TOFILE(QTEMP/AB#WPAO)
 /**JW3**/
             OVRDBF     FILE(AB#WPAP) TOFILE(QTEMP/AB#WPAP)
             OVRDBF     FILE(AB#WPAQ) TOFILE(QTEMP/AB#WPAQ)

             CALL       PGM(AB#RAA)

             DLTOVR     FILE(*ALL)

             IF         COND(&USER *NE 'I0777') THEN(GOTO CMDLBL(ENDP))

/* JW SAVE QTEMP FILE */
     CPYF FROMFILE(QTEMP/AB#WPAR) TOFILE(TWFILE1/AB#WPAR) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF0000)

     CPYF FROMFILE(QTEMP/AB#WPAS) TOFILE(TWFILE1/AB#WPAS) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF0000)

     CPYF FROMFILE(QTEMP/AB#WPAO) TOFILE(TWFILE1/AB#WPAO) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF0000)

     CPYF FROMFILE(QTEMP/AB#WPAT) TOFILE(TWFILE1/AB#WPAT) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF0000)

     CPYF FROMFILE(QTEMP/AB#WPAP) TOFILE(TWFILE1/AB#WPAP) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF0000)

     CPYF FROMFILE(QTEMP/AB#WPAQ) TOFILE(TWFILE1/AB#WPAQ) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF0000)

 ENDP:
             ENDPGM
