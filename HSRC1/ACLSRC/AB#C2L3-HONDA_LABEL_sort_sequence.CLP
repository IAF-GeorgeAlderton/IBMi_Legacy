             PGM        PARM(&PLOC1 &PLOC2 &PAORD)
             /** AB#C2L3 **********************************************/
             /*  ..HONDA LABEL --- sort sequence                      */
             /*     &PAORD  - parm = '1' is ascending,                */
             /*                      '2' is descending                */
             /***************************** AB#C2L3 *******************/
             DCL        VAR(&PLOC1)    TYPE(*CHAR) LEN(2)
             DCL        VAR(&PLOC2)    TYPE(*CHAR) LEN(2)
             DCL        VAR(&PAORD)    TYPE(*CHAR) LEN(1)

             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WKSID)   TYPE(*CHAR) LEN(3)
             DCL        VAR(&PRT)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&WKSID) VALUE(%SUBSTRING(&WSID 1 3))

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             OVRDBF     FILE(AB#WP2U) TOFILE(AB#WP2U) MBR(&WKSID)
             OVRDBF     FILE(AB#WP2V) TOFILE(AB#WP2V) MBR(&WKSID)

  /*  if parm = ascending                                   */
             IF         COND(&PAORD = '1') THEN(DO) /* ascending */

             DLTF       FILE(QTEMP/AB#WPUA)
             MONMSG     MSGID(CPF0000)

             DLTF       FILE(QTEMP/AB#WPVA)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(AB#WPUA) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             CRTDUPOBJ  OBJ(AB#WPVA) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)


             CLRPFM     FILE(QTEMP/AB#WPUA)
             CLRPFM     FILE(QTEMP/AB#WPVA)

             OVRDBF     FILE(AB#WPU) TOFILE(QTEMP/AB#WPUA)
             OVRDBF     FILE(AB#WPV) TOFILE(QTEMP/AB#WPVA)

                        ENDDO

  /*  if parm = descending                                  */
             IF         COND(&PAORD = '2') THEN(DO) /* descending */

             DLTF       FILE(QTEMP/AB#WPUD)
             MONMSG     MSGID(CPF0000)

             DLTF       FILE(QTEMP/AB#WPVD)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(AB#WPUD) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             CRTDUPOBJ  OBJ(AB#WPVD) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)


             CLRPFM     FILE(QTEMP/AB#WPUD)
             CLRPFM     FILE(QTEMP/AB#WPVD)

             OVRDBF     FILE(AB#WPU) TOFILE(QTEMP/AB#WPUD)
             OVRDBF     FILE(AB#WPV) TOFILE(QTEMP/AB#WPVD)

                        ENDDO

   /*  pull these two locations from label wf...                 */
   /*   and write them to either ascend or descend workfile...   */
             CALL       PGM(AB#R2L3) PARM(&PLOC1 &PLOC2)




   /*  if these locations are in ascending sequence,             */
   /*     then copy the ascending workfiles...                   */
             IF         COND(&PAORD = '1') THEN(DO) /* ascending */
             CPYF       FROMFILE(QTEMP/AB#WPUA) +
                          TOFILE(HWFILE1/AB#WPUF) TOMBR(&WKSID) +
                          MBROPT(*ADD) FMTOPT(*MAP *DROP)

             CPYF       FROMFILE(QTEMP/AB#WPVA) +
                          TOFILE(HWFILE1/AB#WPVF) TOMBR(&WKSID) +
                          MBROPT(*ADD) FMTOPT(*MAP *DROP)

                        ENDDO


   /*  if these locations are in descending sequence,            */
   /*     then copy the descending workfiles...                  */
             IF         COND(&PAORD = '2') THEN(DO) /* descending */
             CPYF       FROMFILE(QTEMP/AB#WPUD) +
                          TOFILE(HWFILE1/AB#WPUF) TOMBR(&WKSID) +
                          MBROPT(*ADD) FMTOPT(*MAP *DROP)

             CPYF       FROMFILE(QTEMP/AB#WPVD) +
                          TOFILE(HWFILE1/AB#WPVF) TOMBR(&WKSID) +
                          MBROPT(*ADD) FMTOPT(*MAP *DROP)
                        ENDDO

             DLTOVR     FILE(AB#WPU)
             DLTOVR     FILE(AB#WPV)

             ENDPGM
