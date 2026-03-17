             PGM
             /***FCEC45********************************************/
             /* USER PART# VS IAF PART#                                -EDP */
             /*     CREATE DATA FOR DOWNLOADING                 */
             /*          MAY/23/2002                            */
             /*****************************************************/
             DCLF       FILE(FCEPW45)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&FLD) TYPE(*CHAR) LEN(50)
             RTVJOBA    JOB(&WSID)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
  @STRT:
             SNDRCVF    RCDFMT(DSP01)

             CHGVAR     VAR(&IN61) VALUE('0')
             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(@END))


             IF         COND(&IN05 *EQ '1') THEN(DO)

             CLRPFM     FILE(FCEWP45)

             OVRDBF     FILE(MBDPP01) SHARE(*YES)
             IF         COND(&CUST *EQ ' ') THEN(DO)
             OPNQRYF    FILE((MBDPP01)) QRYSLT('F3SKJY *EQ ''''') +
                          KEYFLD((F3TOKU) (F3MHN1) (F3MHN2) +
                          (F3MHN3) (F3MHN4))
             ENDDO

             ELSE DO
             CHGVAR     VAR(&FLD) VALUE('F3TOKU *EQ ' *CAT &CUST +
             *CAT ' *AND F3SKJY *EQ '' '' ')
             OPNQRYF    FILE((MBDPP01)) QRYSLT(&FLD) +
                          KEYFLD((F3TOKU) (F3MHN1) (F3MHN2) +
                          (F3MHN3) (F3MHN4))
             ENDDO

             CALL       PGM(FCER45)

             CLOF       OPNID(MBDPP01)
             GOTO @END
             ENDDO

             GOTO       CMDLBL(@STRT)

  @END:

             ENDPGM
