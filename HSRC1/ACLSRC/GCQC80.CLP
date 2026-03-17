             PGM

             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD)    TYPE(*CHAR) LEN(4)
             DCL        VAR(&FILE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&SRC)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WFILE) TYPE(*CHAR) LEN(10)

             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&GCQWP80) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WS) USER(&US)
             RTVJOBA    USER(&USER)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WS 1 3))
          /* CHGVAR     VAR(&GCQWP80) VALUE('GCQWP80' *CAT &WS3) */
             CHGVAR     VAR(&GCQWP80) VALUE('GCQWP80')

          /* CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG +
                          &PDEVT &PIGCD &USER &FILE &SRC +
                          &WFILE) */

             CALL       PGM(ALBC01) PARM(&USER &FILE &WFILE)

             DLTF       FILE(&GCQWP80)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&FILE/&GCQWP80) RCDLEN(300) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO)

             DLTF       FILE(GCQWP83)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&FILE/GCQWP83) RCDLEN(300) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO)

             OVRDBF     FILE(GCQWP80) TOFILE(&GCQWP80)
             CALL       PGM(GCQR82)

             CALL       PGM(GCQR83)

             IF         COND(&WS3 *EQ 'HPI') THEN(DO)
             EDTDTA     FILE(&GCQWP80)
             ENDDO

             ENDPGM
