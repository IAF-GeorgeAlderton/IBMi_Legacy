             PGM        PARM(&HYMD &BIN &BUMON  &ATENA &BLK1 +
                          &BLK2 &HAKO)
             /** ATAC82 ************************************/
             /*  UNDELIVERED CHECK LIST                    */
             /*                              88.07.23      */
             /*                   VER. 2.0   90.06.09      */
             /************************************ ATAC81 **/
             DCL        VAR(&CP)      TYPE(*CHAR)  LEN(1)
             DCL        VAR(&BUMON)   TYPE(*CHAR)  LEN(5)
             DCL        VAR(&HAKO)    TYPE(*CHAR)  LEN(1)
             DCL        VAR(&HYMD)    TYPE(*CHAR)  LEN(8)
             DCL        VAR(&BIN)     TYPE(*CHAR)  LEN(2)
             DCL        VAR(&ATENA)   TYPE(*CHAR)  LEN(1)
             DCL        VAR(&BLK1)    TYPE(*CHAR)  LEN(3)
             DCL        VAR(&BLK2)    TYPE(*CHAR)  LEN(3)
             DCL        VAR(&USER)    TYPE(*CHAR)  LEN(10)
             DCL        VAR(&WSNO)    TYPE(*CHAR)  LEN(10)
             DCL        VAR(&PRT)     TYPE(*CHAR)  LEN(7)
             DCL        VAR(&TYPE)    TYPE(*CHAR)  LEN(1)
             DCL        VAR(&PRTG)    TYPE(*CHAR)  LEN(10)
             DCL        VAR(&KOTAE)   TYPE(*CHAR)  LEN(1)
             DCL        VAR(&MBAN)    TYPE(*CHAR)  LEN(4)
             DCL        VAR(&KOTE)    TYPE(*CHAR)  LEN(1)
             RTVJOBA    JOB(&WSNO) USER(&USER)

             CHGJOB     OUTQ(&PRTG)
             IF         (&HAKO *NE 'M')   GOTO END
             CHGVAR     VAR(&CP) VALUE('1')
             IF         (&BUMON *EQ '8982 ') DO
             CHGVAR     VAR(&CP) VALUE('2')
             ENDDO
             OVRPRTF    FILE(ATAPRM2) DEV(PE) PAGESIZE(66 132) LPI(6) +
                          OVRFLW(66) OUTQ(&PRTG) FORMTYPE(D992) +
                          COPIES(&CP) LVLCHK(*NO)
             CALL       PGM(ATARM2) PARM(&HYMD &BIN &BUMON &ATENA +
                                         &BLK1  &BLK2)
END:         CHGJOB     OUTQ(&PRT)
             ENDPGM
