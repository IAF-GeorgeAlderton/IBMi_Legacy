             PGM        PARM(&OBJ &LDAT &RTN)
             /** UTLC76 ******************************************/
             /*  UTILITY- GET LAST USE DATE OF OBJECT            */
             /*  JW1: J-WATANABE             2019.08.19          */
             /*--------------------------------------------------*/
             /*  CALLING SEQ.                                    */
             /*                    CALL 'UTLC76'                 */
             /*                    PARM           $OBJ   10      */
             /*                    PARM           $LDAT   8      */
             /*                    PARM           $RTN    1      */
             /*   IN  $OBJ  : 10A OBJECT                          */
             /*   OUT $LDATE:  8A LAST USE DATE                   */
             /*       $RTN  :  1A BLANK=OK, '*'=NG                */
             /****************************************************/
             DCL        VAR(&OBJ ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USDT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&LDAT) TYPE(*CHAR) LEN(8)
             DCL        VAR(&LTR1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&LTR2) TYPE(*CHAR) LEN(2)
             DCL        VAR(&LTR6) TYPE(*CHAR) LEN(6)
             DCL        VAR(&RTN ) TYPE(*CHAR) LEN(1)

             RTVOBJD    OBJ(HOBJ1/&OBJ) OBJTYPE(*PGM) USEDATE(&USDT)
             MONMSG     MSGID(CPF0001 CPF9811)

             CHGVAR     VAR(&LDAT) VALUE('00000000')
             CHGVAR     VAR(&LTR1) VALUE(%SST(&USDT 1 1))
             CHGVAR     VAR(&LTR6) VALUE(%SST(&USDT 2 6))

             IF COND(&LTR1 = ' ') THEN(CHGVAR VAR(&LTR2) VALUE('00'))
             IF COND(&LTR1 = '0') THEN(CHGVAR VAR(&LTR2) VALUE('19'))
             IF COND(&LTR1 = '1') THEN(CHGVAR VAR(&LTR2) VALUE('20'))

             CHGVAR     VAR(&LDAT) VALUE(&LTR2 *CAT &LTR6)
             CHGVAR     VAR(&RTN ) VALUE(' ')
             GOTO       CMDLBL(ENDP)
          /**ENDDO                             **/

          /**CHGVAR     VAR(&RTN ) VALUE('*')  **/

ENDP:        ENDPGM
