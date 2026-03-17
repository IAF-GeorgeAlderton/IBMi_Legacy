             PGM        PARM(&PLOC1 &PLOC2 &PAORD)
             /** AB#C2C4 **********************************************/
             /*  COMMON LABEL --- sort sequence                       */
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

             OVRDBF     FILE(AB#WP2I) TOFILE(AB#WP2I) MBR(&WKSID)

  /*  if parm = ascending                                   */
             IF         COND(&PAORD = '1') THEN(DO) /* ascending */

             DLTF       FILE(QTEMP/AB#WPCA)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(AB#WPCA) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)

             CLRPFM     FILE(QTEMP/AB#WPCA)

             OVRDBF     FILE(AB#WPC) TOFILE(QTEMP/AB#WPCA)
                        ENDDO

  /*  if parm = descending                                  */
             IF         COND(&PAORD = '2') THEN(DO) /* descending */

             DLTF       FILE(QTEMP/AB#WPCD)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(AB#WPCD) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)

             CLRPFM     FILE(QTEMP/AB#WPCD)
             OVRDBF     FILE(AB#WPC) TOFILE(QTEMP/AB#WPCD)

                        ENDDO

   /*  pull these two locations from label wf...                 */
   /*   and write them to either ascend or descend workfile...   */
             CALL       PGM(AB#R2O3) PARM(&PLOC1 &PLOC2)


   /*  if these locations are in ascending sequence,             */
   /*     then copy the ascending workfiles...                   */
             IF         COND(&PAORD = '1') THEN(DO) /* ascending */
             CPYF       FROMFILE(QTEMP/AB#WPCA) +
                          TOFILE(HWFILE1/AB#WPCF) TOMBR(&WKSID) +
                          MBROPT(*ADD) FMTOPT(*MAP *DROP)
                        ENDDO


   /*  if these locations are in descending sequence,            */
   /*     then copy the descending workfiles...                  */
             IF         COND(&PAORD = '2') THEN(DO) /* descending */
             CPYF       FROMFILE(QTEMP/AB#WPCD) +
                          TOFILE(HWFILE1/AB#WPCF) TOMBR(&WKSID) +
                          MBROPT(*ADD) FMTOPT(*MAP *DROP)
                        ENDDO

             DLTOVR     FILE(AB#WPC)

             ENDPGM
