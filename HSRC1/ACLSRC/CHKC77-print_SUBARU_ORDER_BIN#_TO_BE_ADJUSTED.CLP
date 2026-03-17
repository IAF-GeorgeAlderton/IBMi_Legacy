             PGM
             /** CHKC77 **********************************************/
             /*  SUBARU ORDER BIN# TO BE ADJUSTED                    */
             /*  ADD JOB TO AB#C0A                                   */
             /*  J.WATANABE 2019.07.24                               */
             /********************************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&SRC ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DATE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             OVRDBF     FILE(AB#WP452) TOFILE(HWFILE1/AB#WP452AR)
             CALL       PGM(CHKR77) PARM(&RTN)

             ENDPGM
