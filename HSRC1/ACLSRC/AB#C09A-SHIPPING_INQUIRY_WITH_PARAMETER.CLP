             PGM
             /** AB#C09A **************************/
             /*  SHIPPING INQUIRY                 */
             /*           NOV/21/01         TCH   */
             /*************************************/

             DCL        VAR(&NONY) TYPE(*CHAR) LEN(4) VALUE('0000')
             DCL        VAR(&FROM) TYPE(*CHAR) LEN(8) VALUE('00000000')
             DCL        VAR(&TO  ) TYPE(*CHAR) LEN(8) VALUE('00000000')
             DCL        VAR(&NOBN) TYPE(*CHAR) LEN(2) VALUE('00')
             DCL        VAR(&NKOJ) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&NUKE) TYPE(*CHAR) LEN(4) VALUE('    ')

      /*JW** CALL       PGM(AB#R09A) PARM(&NONY &FROM &TO &NOBN +       **/
      /*****              &NKOJ &NUKE)                                  **/

             CALL       PGM(AB#R09D) PARM(&NONY &FROM &TO &NOBN +
                          &NKOJ &NUKE)

             ENDPGM
