             PGM
             /*** GCQC61 ******************************/
             /*  DIE MASTER TRANSFER                */
             /*    JW(SRA)         11.05.2015         */
             /*    JW1     2021.04.23 USE APLC94      */
             /*****************************************/
             DCL        VAR(&DIR) TYPE(*CHAR) LEN(100)
             DCL        VAR(&DIR2) TYPE(*CHAR) LEN(100)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CMD1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(15) +
                          VALUE('DIE-MASTER.CSV')
           /*--------------------------------------------*/
           /*    CHECK ENVIRONMENT                        */
           /*--------------------------------------------*/
            RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

             CHGVAR     VAR(&DIR) +
                          VALUE('QNTC/IAF-AS400-FILE/AS400-TRANS/Manu+
                          facturing/Download/' *CAT &USER)
      /* CREATE DIRECTRY */
             CRTDIR     DIR(&DIR )
             MONMSG     MSGID(CPFA0A0)
             MONMSG     MSGID(CPFA0A9)

  /* CREATE WORK FILE */
             DLTF       FILE(QTEMP/GCQWP61)
             MONMSG     MSGID(CPF3261 CPF2105)

             DLTF       FILE(QTEMP/GCQWP62)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTDUPOBJ  OBJ(GCQWP61) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(GCQWP62) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(GCQWP61) TOFILE(QTEMP/GCQWP61)
             CALL       GCQR61 PARM(&CMD1)
      /*END*/
             IF         COND(&CMD1 *EQ '1') THEN(GOTO CMDLBL(ENDP))

      /* COPY.........*/
             OVRDBF     FILE(GCQWP62) TOFILE(QTEMP/GCQWP62)
             CALL       GCQR62

 /* TRANSFER.....*/
 /** JW1     CPYTOIMPF  FROMFILE(QTEMP/GCQWP62) TOSTMF(&DIR2) +        **/
 /**                      MBROPT(*REPLACE) RCDDLM(*CRLF) +             **/
 /**                      RMVBLANK(*BOTH) FLDDLM(',') DATFMT(*USA) +   **/
 /**                      TIMFMT(*USA) ADDCOLNAM(*SYS)                 **/
 /**         MONMSG     MSGID(CPF0000)                                 **/

 /* JW1 TRANSFER WF TO ISF.CSV */
             CALL       PGM(APLC94) PARM('2' 'GCQWP62' 'QTEMP' 'DIE +
                          MASTER' 'Y' ' ' 'Y')

             DLTOVR     FILE(*ALL)

 ENDP:       ENDPGM
