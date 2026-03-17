             PGM        PARM(&LIBL &FILE &MBR &SRCCHGDATE &STYPE)
             /** VVVCY1 **********************************/
             /*ソースレベルアンマッチ表示              */
             /* T.SAKASHITA 2012.06.01                   */
             /* -------------------------------          */
             /* JW1 J.WATANABE CLEAR &SRCCHGDATE         */
             /********************************************/

             DCL        VAR(&LIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBR) TYPE(*CHAR) LEN(10)

             DCL        VAR(&SRCCHGDATE) TYPE(*CHAR) LEN(13)
             DCL        VAR(&CHGDATE) TYPE(*CHAR) LEN(13)

             DCL        VAR(&SRCF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SRCFLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SRCMBR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SRCDATE) TYPE(*CHAR) LEN(13)
             DCL        VAR(&STYPE) TYPE(*CHAR) LEN(10)

 /* JW1 */
             CHGVAR     VAR(&SRCCHGDATE) VALUE('0000000000000')

             RTVMBRD    FILE(&LIBL/&FILE) MBR(&MBR) SRCTYPE(&STYPE) +
                          SRCCHGDATE(&SRCCHGDATE) CHGDATE(&CHGDATE)
             MONMSG     MSGID(CPF9999)

         /*  RTVOBJD    OBJ(AAAR01) OBJTYPE(*PGM) SRCF(&SRCF) +
                          SRCFLIB(&SRCFLIB) SRCMBR(&SRCMBR) +
                          SRCDATE(&SRCDATE) */

             ENDPGM
