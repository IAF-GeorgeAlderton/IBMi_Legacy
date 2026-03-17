             PGM
             /** AFAC82 ************************************/
             /* DELETE A-PACS MATERIAL SUPPLY RECORD       */
             /* <LOCAL PARTS PROCUREMENT SYSTEM>           */
             /*    K.KASHIWAGI  2000.12.11                 */
             /************************************ AFBC8C **/
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID)  USER(&USER)

             CALL       PGM(AFAR82) PARM(&USER)

             ENDPGM
