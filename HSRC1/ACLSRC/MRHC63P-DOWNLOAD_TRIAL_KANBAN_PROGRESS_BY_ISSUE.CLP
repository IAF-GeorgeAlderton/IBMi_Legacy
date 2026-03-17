             PGM        PARM(&KANF &KANT &DELF &DELT &CUST &DEPT)
             /*** MRHC63P *******************************************/
             /*  DOWNLOAD TRIAL KANBAN PROGRESS BY ISSUE DATE       */
             /*  JW        2024.02.02                               */
             /*******************************************************/
             DCL        VAR(&KANF) TYPE(*CHAR) LEN(8)
             DCL        VAR(&KANT) TYPE(*CHAR) LEN(8)
             DCL        VAR(&DELF) TYPE(*CHAR) LEN(8)
             DCL        VAR(&DELT) TYPE(*CHAR) LEN(8)
             DCL        VAR(&CUST) TYPE(*CHAR) LEN(4)
             DCL        VAR(&DEPT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTN ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FNAM) TYPE(*CHAR) LEN(30)

             DLTF       FILE(QTEMP/MRHWP63)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ OBJ(MRHWP63) FROMLIB(HWFILE1) OBJTYPE(*FILE) TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/MRHWP63)

             DLTF       FILE(QTEMP/MRHWP63A)
             MONMSG     MSGID(CPF0000)
            CRTDUPOBJ OBJ(MRHWP63A) FROMLIB(HWFILE1) OBJTYPE(*FILE) TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/MRHWP63A)

             OVRDBF     FILE(MRHWP63)  TOFILE(QTEMP/MRHWP63)
             OVRDBF     FILE(MRHWP63A) TOFILE(QTEMP/MRHWP63A)

             CALL       PGM(MRHR63P) PARM((&KANF) (&KANT) (&DELF) +
                          (&DELT) (&CUST) (&DEPT) (&RTN))

             IF         COND(&RTN = ' ') THEN(DO)
             CHGVAR     VAR(&FNAM) VALUE('TRIAL KANBAN ')
             CALL       PGM(APLC94) PARM('2' 'MRHWP63A' 'QTEMP' &FNAM +
                          'Y' ' ' 'Y')
             ENDDO

 ENDP:
             ENDPGM
