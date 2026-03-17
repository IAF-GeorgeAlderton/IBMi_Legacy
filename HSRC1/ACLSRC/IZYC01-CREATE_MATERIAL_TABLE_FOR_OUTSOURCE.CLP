             PGM
             /*** IZYC01 *****************************/
             /*  CREATE MATERIAL TABLE FOR OUTSOURCE */
             /*   Y.MAEDA                 2018.01.15 */
             /***************************** IZYC01 ***/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             DLTF       FILE(&WLIB/IZYWP01)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/IZYWP01) RCDLEN(1024) +
                          OPTION(*NOLIST) SIZE(50000) LVLCHK(*NO) +
                          AUT(*ALL)

             CALL       PGM(IZYR01) PARM('4511')

             ENDPGM
