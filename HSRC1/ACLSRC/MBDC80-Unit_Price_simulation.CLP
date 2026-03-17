             PGM
             /** GDGC77 ************************/
             /* UNIT PRICE SIMULATION          */
             /*     TCH  2002/12/16            */
             /*     TCH04 2004/12/16           */
             /************************ GDGC77 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USR)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USR)
             CALL       PGM(ALBC00) PARM(&USR &WLIB)


      /* TCH04  */
             CLRPFM     FILE(&WLIB/MBDWP)
             MONMSG     MSGID(CPF0000)

             CALL       PGM(MBDR80)

             RUNQRY     QRY(TCHLIB/CHICAGE3)

             ENDPGM
