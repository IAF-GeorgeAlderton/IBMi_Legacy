             PGM        PARM(&PLOC1 &PLOC2 &PAORD)
             /** AB#C2C3 **********************************************/
             /*  TAKATA LABEL --- sort sequence                       */
             /*     &PAORD  - parm = '1' is ascending,                */
             /*                      '2' is descending                */
             /*********************************************************/
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

             OVRDBF     FILE(AB#WP2F) TOFILE(AB#WP2F) MBR(&WKSID)

  /*  if parm = ascending                                   */
             IF         COND(&PAORD = '1') THEN(DO) /* ascending */

             DLTF       FILE(QTEMP/AB#WPFAS)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(AB#WPFAS) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)

             CLRPFM     FILE(QTEMP/AB#WPFAS)

             OVRDBF     FILE(AB#WPF) TOFILE(QTEMP/AB#WPFAS)
                        ENDDO

  /*  if parm = descending                                  */
             IF         COND(&PAORD = '2') THEN(DO) /* descending */

             DLTF       FILE(QTEMP/AB#WPFDS)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(AB#WPFDS) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)

             CLRPFM     FILE(QTEMP/AB#WPFDS)
             OVRDBF     FILE(AB#WPF) TOFILE(QTEMP/AB#WPFDS)

                        ENDDO

   /*  pull these two locations from label wf...                 */
   /*   and write them to either ascend or descend workfile...   */
             CALL       PGM(AB#R2T3) PARM(&PLOC1 &PLOC2)


   /*  if these locations are in ascending sequence,             */
   /*     then copy the ascending workfiles...                   */
             IF         COND(&PAORD = '1') THEN(DO) /* ascending */
             CPYF       FROMFILE(QTEMP/AB#WPFAS) +
                          TOFILE(HWFILE1/AB#WPFF) TOMBR(&WKSID) +
                          MBROPT(*ADD) FMTOPT(*MAP *DROP)
                        ENDDO


   /*  if these locations are in descending sequence,            */
   /*     then copy the descending workfiles...                  */
             IF         COND(&PAORD = '2') THEN(DO) /* descending */
             CPYF       FROMFILE(QTEMP/AB#WPFDS) +
                          TOFILE(HWFILE1/AB#WPFF) TOMBR(&WKSID) +
                          MBROPT(*ADD) FMTOPT(*MAP *DROP)
                        ENDDO

             DLTOVR     FILE(AB#WPF)

             ENDPGM
