             PGM
             /** AB#CSO ************************/
             /* ..CREATE KANBAN DATA FOR SERVICE PARTS */
             /*                                */
             /**********************************/
             DCL        VAR(&ID) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID)
             CALL       PGM(AB#RSO) PARM(&ID)
  /*         IF         COND(&ID *EQ ' ') THEN(SNDBRKMSG MSG('KANBAN +
                          DATA IS SUCCESSFULLY CREATED. PLEASE +
                          DOWNLOAD TO PC AND PRINT KANBAN(S).') +
                          TOMSGQ(&WSID))   */

             ENDPGM
