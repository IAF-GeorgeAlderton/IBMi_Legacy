             PGM
             /** MBDC86 ****************************/
             /*  WASHER PART VOLUME LIST           */
             /*  J.WATANABE   2021.01.21           */
             /**************************************/
             DCLF       FILE(MBDPW86)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&KEN)  TYPE(*DEC)  LEN(10 0)
             RTVJOBA    JOB(&WSID)
 @DSP1:
             SNDRCVF    DEV(&WSID) RCDFMT(DSP01)

             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(@EXIT))

             CHGVAR     VAR(&IN41) VALUE('0')
             CHGVAR     VAR(&IN42) VALUE('0')

             IF         COND(&XFROM *EQ '      ') THEN(DO)
             CHGVAR     VAR(&IN41) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('ENTER DATE(FROM) !')
             GOTO @DSP1
             ENDDO

             IF         COND((&XFROM *LT '200001') *OR (&XFROM *GT +
                          '210012')) THEN(DO)
             CHGVAR     VAR(&IN41) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('DATE(FROM) IS INVALID !')
             GOTO @DSP1
             ENDDO

             IF         COND(&XTO *EQ '      ') THEN(DO)
             CHGVAR     VAR(&IN42) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('ENTER DATE(TO) !')
             GOTO @DSP1
             ENDDO

             IF         COND((&XTO   *LT '200001') *OR (&XTO *GT +
                          '210012')) THEN(DO)
             CHGVAR     VAR(&IN42) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('DATE(TO) IS INVALID !')
             GOTO @DSP1
             ENDDO

             IF         COND(&XFROM *GT &XTO) THEN(DO)
             CHGVAR     VAR(&IN41) VALUE('1')
             CHGVAR     VAR(&IN42) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('DATE(FROM) IS GREATER THAN +
                          DATE(TO) !')
             GOTO @DSP1
             ENDDO

             IF         COND(&IN05 *NE '1') THEN(DO)
             CHGVAR     VAR(&XMSG) VALUE('PRESS F5 TO RUN...')
             GOTO       @DSP1
             ENDDO

/* PROCESS ------ */

             DLTF       FILE(QTEMP/MBDWP86)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ OBJ(MBDWP86) FROMLIB(HWFILE1) OBJTYPE(*FILE) TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             DLTF       FILE(QTEMP/MBDWP86V)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(MBDWP86V) FROMLIB(HWFILE1) +
                          OBJTYPE(*FILE) TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(QTEMP/MBDWP86)
             CLRPFM     FILE(QTEMP/MBDWP86V)

      /***JW CALL       PGM(MBDR86) PARM(&XFROM &XTO)  **/

             CALL       PGM(MBDR86A) PARM(&XFROM &XTO)
             CALL       PGM(MBDR86V)

             RTVMBRD    FILE(QTEMP/MBDWP86V) NBRCURRCD(&KEN)
             IF         COND(&KEN *EQ 0) THEN(GOTO @EXIT)

/* TRANSFER TO CSV */
             CALL       PGM(APLC94) PARM('2' 'MBDWP86V' 'QTEMP' +
                          'WASHER PART VOLUME LIST' 'Y' ' ' 'Y')
@EXIT:
             ENDPGM
