             PGM
             /** AB#C84 ************************/
             /*PARTS EDIT MAINTENANCE          */
             /* K-KASHIWAGI        00.11.30    */
             /************************ AB#C84 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AB#R84) PARM(&WSID)

             ENDPGM
