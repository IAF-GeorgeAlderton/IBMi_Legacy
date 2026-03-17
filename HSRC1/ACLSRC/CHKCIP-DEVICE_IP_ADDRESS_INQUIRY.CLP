             PGM
             /** CHKCIP *************************/
             /*  �������������索 */
             /*      T-SAKASHITA 2001.11.21     */
             /********************** CHKCIP *****/
             DCLF       FILE(CHKPWIP)

             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
           /*DCL   &RTVDEV    *CHAR 10           DEV TO RETRIEVE  */
           /*DCL   &PORT      *DEC  LEN(5 0)     PORT NUMBER      */
           /*DCL   &PORTBIN   *CHAR 2            PORT (BINARY)    */
           /*DCL   &MSG       *CHAR 150          DISPLAYED MSG    */
             DCL   &ERROR     *CHAR 16        /* ERROR FIELD      */
           /*DCL   &DEVNAM    *CHAR 10           DEVICE NAME      */
             DCL   &RCVVAR    *CHAR 1024      /* RECEIVER VAR     */
           /*DCL   &CTLD      *CHAR 10           CONTROLLER DESC  */
           /*DCL   &PORTCHAR  *CHAR 5            PORT NUMBER      */
           /*DCL   &TCPADDR   *CHAR 15           TCP/IP ADDRESS   */
           /*DCL   &PROTOCOL  *CHAR 1            NETWORK PROTOCOL    +
                     VALUE(X'02')                TCP/IP PROTOCOL  */
             RTVJOBA    JOB(&WSID)

DSP01:
             SNDRCVF    DEV(&WSID) RCDFMT(CHKPWIP1)
             IF         (&IN01 *EQ '1') GOTO END

             CHGVAR     VAR(&IN99) VALUE('0')

             CHGVAR    &RCVVAR        ' '

             CALL       PGM(QDCRDEVD) PARM(&RCVVAR X'00000400' +
                          'DEVD0600' &DDEV &ERROR) /* ERROR +
                          FIELD             */

           /*CHGVAR    &DEVNAM        %SST(&RCVVAR  22 10)*/

             CHGVAR    &DCTL          %SST(&RCVVAR 205 10)
           /*CHGVAR    &PORTBIN       %SST(&RCVVAR 860  2)*/
           /*CHGVAR    &PORT          %BIN(&PORTBIN)      */
           /*CHGVAR    &PORTCHAR      &PORT               */
             CHGVAR    &DIP           %SST(&RCVVAR 877 15)

          /* CHGVAR    &MSG           VALUE(                  +
                       ' DEVICE: '          *CAT &DEVNAM   *TCAT   +
                       ' CONTROLLER: '      *CAT &CTLD     *TCAT   +
                       ' PORT: '            *CAT &PORTCHAR *TCAT   +
                       ' ADDRESS: '         *CAT &TCPADDR)  */

             GOTO       CMDLBL(DSP01)

END:
             ENDPGM
