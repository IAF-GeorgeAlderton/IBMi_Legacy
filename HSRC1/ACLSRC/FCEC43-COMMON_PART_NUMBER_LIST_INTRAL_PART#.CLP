             PGM
             /***FCEC42********************************************/
             /* COMMON PART NUMBER LIST ..INTRAL COMPANY PART NUMBER */
             /* TEN DAYS.. OP-EDP */
             /*         A-SENGA           1981.10.09    CL MAIN */
             /*****************************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGJOB     OUTQ(&PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             DLTF       FILE(FCEWP43)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/FCEWP43) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(10000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)
             CALL       PGM(FCER43)

             ENDPGM
