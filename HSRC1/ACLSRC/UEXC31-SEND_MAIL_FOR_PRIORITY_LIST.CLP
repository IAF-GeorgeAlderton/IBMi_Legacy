             PGM
             /*= UEXC31 ====================================================*/
             /*  SEND MAIL                                                  */
             /*  J.WATANABE     2020.06.19                                  */
             /*  --------------                                             */
             /*  &FILE  (10A) PRINTER FILE (QPRINT...)                      */
             /*  &USER  (10A) USER ID                                       */
             /*  &WSID  (10A) WSID                                          */
             /*  &NBR   (06A) JOB#                                          */
             /*  &ADR1 (250A) MAIL ADDRESS                                  */
             /*  &DSTD  (50A) MAIL DESCRIPTION                              */
             /*  &DOCD  (50A) DOC. DESCRIPTION                              */
             /*  &MSG  (250A) MSG                                           */
             /*=============================================================*/
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR ) TYPE(*CHAR) LEN(06)
             DCL        VAR(&ADR1) TYPE(*CHAR) LEN(250)
             DCL        VAR(&DSTD) TYPE(*CHAR) LEN(50)
             DCL        VAR(&DOCD) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MSG ) TYPE(*CHAR) LEN(240)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             CHGVAR     VAR(&FILE) VALUE('QPRINT    ')
             CHGVAR     VAR(&NBR ) VALUE('314273')
             CHGVAR     VAR(&ADR1) VALUE('KAZ.WATANABE@IAFI.COM')
             CHGVAR     VAR(&DSTD) VALUE('** IAF YELLOW AND ORANGE +
                          FLAG LIST **')
             CHGVAR     VAR(&DOCD) VALUE('** IAF YELLOW AND ORANGE +
                          FLAG LIST **')
             CHGVAR     VAR(&MSG) VALUE('** THIS REPORT WAS CREATED +
                          BY IAF AND SENT TO ASJ. (AJ#C741).')

             CALL       PGM(SNDC01) PARM(&FILE &USER &WSID &NBR +
                          &ADR1 &DSTD &DOCD &MSG)

             ENDPGM
