PGM
/** ECQC18 ************************************************/
/*  DIE UNIT PRICE UPLOAD/UPDATE                          */
/*                                                        */
/* TCHK1 05/24/10 CREATE                                  */
/**********************************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(07)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(01)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SRVF) TYPE(*CHAR) LEN(01)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGVAR     VAR(&SRVF) VALUE(' ')
             CLRPFM     FILE(HWFILE1/ECQWP18)

             CHKOBJ     OBJ(DIECOST) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STP2))

             CALL       PGM(ECQR18)
             CHGVAR     VAR(&SRVF) VALUE('1')

STP2:
             CALL       PGM(ECQR19) PARM(&SRVF)

             CPYF       FROMFILE(HWFILE1/DIECOST) +
                          TOFILE(HWFILE1/DIECOSTSV) +
                          MBROPT(*REPLACE) CRTFILE(*NO) FMTOPT(*MAP +
                          *DROP)

             DLTF       FILE(HWFILE1/DIECOST)
             MONMSG     MSGID(CPF3261 CPF2105)

             ENDPGM
