             PGM
             /** FBCC34 ************************************/
             /*   SALES EXPANSION RESULT                   */
             /*   COPIED FROM FBCC31                     */
             /*   JW     2019.09.04                      */
             /**********************************************/
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB)    TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)    TYPE(*CHAR) LEN(8)
             DCL        VAR(&REC)     TYPE(*DEC)  LEN(10 0)
             DCL        VAR(&TO1)     TYPE(*CHAR) LEN(50)

             DCL        VAR(&SUB)     TYPE(*CHAR) LEN(30)
             DCL        VAR(&LIB)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PF)   TYPE(*CHAR) LEN(10)

             CHGVAR     VAR(&SUB) VALUE('SALES EXPANSION RESULT ' +
                          *CAT &USER)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

             /*==================================================*/
             /*         GENERATE CSV DATA                        */
             /*==================================================*/

             DLTF       FILE(&WLIB/FBCWP31)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/FBCWP31) RCDLEN(210) +
                        IGCDTA(*YES) OPTION(*NOLIST *NOSRC) +
                        SIZE(500 5000 3) LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(FBCR34A) PARM(&TO1)

             RTVMBRD    FILE(&WLIB/FBCWP31) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(GOTO CMDLBL(#STEP99))

             /*==================================================*/
             /*         TRANSFER CSV TO DIRECTORY                */
             /*==================================================*/
             CHGVAR     VAR(&LIB) VALUE(&WLIB)
             CHGVAR     VAR(&PF) VALUE('FBCWP31')

             CALL       PGM(APLC94) PARM('1' &PF &LIB &SUB 'Y' 'N' 'N')

 #STEP99:
             ENDPGM
