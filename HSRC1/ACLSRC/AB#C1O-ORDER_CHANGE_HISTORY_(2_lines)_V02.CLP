             PGM
             /***AB#C1O********************************************/
             /* ORDER CHANGE HISTORY (2 LINES) V02                */
             /* JW    2021.10.21                                  */
             /* -----------------------------                     */
             /* JW    2023.06.07 CHG AB#WHP10 -->  AB#WP1H        */
             /* JW    2023.09.20 CHG AB#R1O   -->  AB#R1O3        */
             /*****************************************************/
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)


     /**JW1  CRTDUPOBJ  OBJ(AB#WHP10) FROMLIB(HWFILE1) +        **/
     /**                  OBJTYPE(*FILE) TOLIB(QTEMP)           **/
     /**     MONMSG     MSGID(CPF0000)                          **/
     /**     CLRPFM     QTEMP/AB#WHP10                          **/
     /**     OVRDBF     FILE(AB#WHP10) TOFILE(QTEMP/AB#WHP10)   **/

             CRTDUPOBJ  OBJ(AB#WP1H ) FROMLIB(HWFILE1) +
                          OBJTYPE(*FILE) TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     QTEMP/AB#WP1H
             OVRDBF     FILE(AB#WP1H ) TOFILE(QTEMP/AB#WP1H)

      /**    CALL       PGM(AB#R1O)      **/
             CALL       PGM(AB#R1O3)

             ENDPGM
