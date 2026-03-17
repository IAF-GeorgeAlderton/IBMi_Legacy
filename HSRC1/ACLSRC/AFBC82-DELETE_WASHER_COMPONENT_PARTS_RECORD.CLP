             PGM
             /** AFBC82 ************************************/
             /* DELETE WASHER COMPONENT PARTS RECORD       */
             /* <LOCAL PARTS PROCUREMENT SYSTEM>           */
             /*    K.KASHIWAGI  2000.12.14                 */
             /************************************ AFBC8C **/
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID)  USER(&USER)

             CALL       PGM(AFBR82) PARM(&USER)

             ENDPGM
