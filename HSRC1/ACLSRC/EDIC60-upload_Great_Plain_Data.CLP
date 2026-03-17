             PGM        PARM(&PONUM)
             /*** EDIC60 ****************************************/
             /* UPLOAD GREAT PLAIN DATA                         */
             /* JW (SRA)    2016.11.10                          */
             /*********************************************++++**/
             DCL        VAR(&FLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&STS ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSG1) TYPE(*CHAR) LEN(80)
             DCL        VAR(&MSG2) TYPE(*CHAR) LEN(80)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&PONUM) TYPE(*CHAR) LEN(17)

       /* CREATE QTEMP/EDIWP60 */
             DLTF       FILE(QTEMP/EDIWP60)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTDUPOBJ  OBJ(EDIWP60) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP) NEWOBJ(EDIWP60)

       /* CREATE QTEMP/EDIPP60 */
             DLTF       FILE(QTEMP/EDIPP60)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTDUPOBJ  OBJ(EDIPP60) FROMLIB(HFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP) NEWOBJ(EDIPP60)

        /*********************************************************/
        /* call pgm to retrieve PO info from Great Plains Server */
        /* and insert into edi workfile - ediwp60                */
             CALL       PGM(EDIC70) PARM(&PONUM)

        /*********************************************************/

             OVRDBF     FILE(EDIWP60) TOFILE(QTEMP/EDIWP60)
             OVRDBF     FILE(EDIPP60) TOFILE(QTEMP/EDIPP60)
             CALL       PGM(EDIR60) PARM(&STS &MSG1 &MSG2)

@EXIT:
             DLTOVR     FILE(*ALL)
             ENDPGM
