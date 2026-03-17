             PGM
             /*** FCEC93 *********************************/
             /* INQUIRY OF  COUNTING PART NO BY LOCATION CODE  */
             /* H.ITO                1992.01.16          */
             /********************************* FCEC93 ***/
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WS) USER(&US)
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)

             DLTF       FILE(FCEWP93)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/FCEWP93) RCDLEN(64) +
                          TEXT('COMPLETION PART KANBAN UPDATE M/F DATA') +
                          OPTION(*NOLIST) SIZE(2000) LVLCHK(*NO)
             CALL       PGM(FCER93)
         /*  DSPFL      FILE(FCEWP93) */

             ENDPGM
