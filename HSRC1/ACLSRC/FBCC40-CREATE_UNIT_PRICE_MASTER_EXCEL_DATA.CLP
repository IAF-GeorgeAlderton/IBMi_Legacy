             PGM
             /** FBCC40 ******************************/
             /* CREATE UNIT PRICE MASTER EXCEL DATA  */
             /*   T.SAKASHITA          2007.01.01    */
             /****************************** FBCC04 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             DLTF       FILE(FBCWP40)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/FBCWP40) RCDLEN(2048) +
                          OPTION(*NOLIST) SIZE(30000 10000) +
                          LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(FBCR40)

             ENDPGM
