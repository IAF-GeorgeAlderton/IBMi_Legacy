             PGM        PARM(&PLOC1 &PLOC2 &PAORD)
             /** AB#C48K3 *********************************************/
             /*  TAKATA MIXED PALLET --- SORT SEQUENCE                */
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

  /*  if parm = ascending                                   */
             IF         COND(&PAORD = '1') THEN(DO) /* ascending */

             DLTF       FILE(QTEMP/ABWWP38A)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(ABWWP38A) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)

             CLRPFM     FILE(QTEMP/ABWWP38A)

             OVRDBF     FILE(ABWWP38) TOFILE(QTEMP/ABWWP38A)
                        ENDDO

  /*  if parm = descending                                  */
             IF         COND(&PAORD = '2') THEN(DO) /* descending */

             DLTF       FILE(QTEMP/ABWWP38D)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(ABWWP38D) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)

             CLRPFM     FILE(QTEMP/ABWWP38D)

             OVRDBF     FILE(ABWWP38) TOFILE(QTEMP/ABWWP38D)

                        ENDDO

   /*  pull these two locations from label wf...                 */
   /*   and write them to either ascend or descend workfile...   */
             CALL       PGM(AB#R48K3) PARM(&PLOC1 &PLOC2)


   /*  if these locations are in ascending sequence,             */
   /*     then copy the ascending workfiles...                   */
             IF         COND(&PAORD = '1') THEN(DO) /* ascending */
             CPYF       FROMFILE(QTEMP/ABWWP38A) +
                          TOFILE(HWFILE1/ABWWP38T) MBROPT(*ADD) +
                          FMTOPT(*MAP *DROP)
                        ENDDO


   /*  if these locations are in descending sequence,            */
   /*     then copy the descending workfiles...                  */
             IF         COND(&PAORD = '2') THEN(DO) /* descending */
             CPYF       FROMFILE(QTEMP/ABWWP38D) +
                          TOFILE(HWFILE1/ABWWP38T) MBROPT(*ADD) +
                          FMTOPT(*MAP *DROP)
                        ENDDO

             DLTOVR     FILE(ABWWP38)

             ENDPGM
