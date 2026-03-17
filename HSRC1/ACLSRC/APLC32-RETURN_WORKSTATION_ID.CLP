             PGM        PARM(&WS3)
             /** APLC32 ******************************************/
             /* RETURN WORKSTATION ID                            */
             /*  Y.SAMEJIMA.........           2012.09.20        */
             /****************************************************/
             DCL        VAR(&SPL)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBNBR)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3)    TYPE(*CHAR) LEN(03)
             DCL        VAR(&WS6)    TYPE(*CHAR) LEN(06)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&JOBNBR)
             CHGVAR     VAR(&WS6) VALUE(%SST(&WSID 1 6))
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))
             IF         COND(&WS6 *EQ 'QPADEV') THEN(DO)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 8 3))
             ENDDO

             ENDPGM
