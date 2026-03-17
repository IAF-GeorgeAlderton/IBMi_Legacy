             PGM
             /** AH#C20 ************************************/
             /*  DOWNLOAD APICS ORDER ACCUM KANBAN DATA    */
             /*  JW       2021.11.29                     */
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
             DCL        VAR(&LIB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PF)      TYPE(*CHAR) LEN(10)

             CHGVAR     VAR(&SUB) VALUE('APICS ORD ACCM KANBAN  ' +
                          *CAT &USER)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

             /*==================================================*/
             /*         GENERATE CSV DATA                        */
             /*==================================================*/

             CLRPFM     FILE(&WLIB/AH#WP20)
             MONMSG     MSGID(CPF0000)

             CALL       PGM(AH#R20 )

             RTVMBRD    FILE(&WLIB/AH#WP20) NBRCURRCD(&REC)
             IF         COND(&REC *LE 1) THEN(GOTO CMDLBL(#STEP99))

             /*==================================================*/
             /*         TRANSFER CSV TO DIRECTORY                */
             /*==================================================*/
             CHGVAR     VAR(&LIB) VALUE(&WLIB)
             CHGVAR     VAR(&PF) VALUE('AH#WP20')

             CALL       PGM(APLC94) PARM('2' &PF &LIB &SUB 'Y' 'N' 'Y')

 #STEP99:
             ENDPGM
