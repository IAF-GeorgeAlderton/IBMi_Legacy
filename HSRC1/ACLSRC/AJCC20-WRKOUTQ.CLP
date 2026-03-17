             PGM
             /** AJCC20 ***********************/
             /*  ..WRKOUTQ                    */
             /*     T-SAKAKI     05.20.15     */
             /*********************** AJCC20 **/
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCLF       FILE(AJCPW20)
             RTVJOBA    JOB(&WSID)

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(AJCPW201)









             ENDPGM
