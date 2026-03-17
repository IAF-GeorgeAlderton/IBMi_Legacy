             PGM        PARM(&PLOC1 &PLOC2 &PAORD)
             /** AB#C2C2 **********************************************/
             /*  ..AWNC LABEL --- sort sequence                       */
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

             OVRDBF     FILE(AB#WP2G) TOFILE(AB#WP2G) MBR(&WKSID)

  /*  if parm = ascending                                   */
             IF         COND(&PAORD = '1') THEN(DO) /* ascending */

             DLTF       FILE(QTEMP/AB#WPGA)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(AB#WPGA) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)

             CLRPFM     FILE(QTEMP/AB#WPGA)

             OVRDBF     FILE(AB#WPG) TOFILE(QTEMP/AB#WPGA)
                        ENDDO

  /*  if parm = descending                                  */
             IF         COND(&PAORD = '2') THEN(DO) /* descending */

             DLTF       FILE(QTEMP/AB#WPGD)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(AB#WPGD) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)

             CLRPFM     FILE(QTEMP/AB#WPGD)
             OVRDBF     FILE(AB#WPG) TOFILE(QTEMP/AB#WPGD)

                        ENDDO

   /*  pull these two locations from label wf...                 */
   /*   and write them to either ascend or descend workfile...   */
             CALL       PGM(AB#R2A3) PARM(&PLOC1 &PLOC2)


   /*  if these locations are in ascending sequence,             */
   /*     then copy the ascending workfiles...                   */
             IF         COND(&PAORD = '1') THEN(DO) /* ascending */
             CPYF       FROMFILE(QTEMP/AB#WPGA) +
                          TOFILE(HWFILE1/AB#WPGF) TOMBR(&WKSID) +
                          MBROPT(*ADD) FMTOPT(*MAP *DROP)
                        ENDDO


   /*  if these locations are in descending sequence,            */
   /*     then copy the descending workfiles...                  */
             IF         COND(&PAORD = '2') THEN(DO) /* descending */
             CPYF       FROMFILE(QTEMP/AB#WPGD) +
                          TOFILE(HWFILE1/AB#WPGF) TOMBR(&WKSID) +
                          MBROPT(*ADD) FMTOPT(*MAP *DROP)
                        ENDDO

             DLTOVR     FILE(AB#WPG)

             ENDPGM
