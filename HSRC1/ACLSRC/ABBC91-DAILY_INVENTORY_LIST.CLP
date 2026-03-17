             PGM
             /** ABBC91 *****************************************/
             /*  DAILY INVENETORY LIST                          */
             /*                                                 */
             /*  JW1   2018.07.13 CHG ERROR MSG                 */
             /***************************************** ABBC91 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
/* JW1 */
             DCL        VAR(&JPGM )  TYPE(*CHAR) LEN(10)
             DCL        VAR(&JINF )  TYPE(*CHAR) LEN(50)
             DCL        VAR(&JMBR )  TYPE(*CHAR) LEN(10)
             DCL        VAR(&JWS  )  TYPE(*CHAR) LEN(10)
             DCL        VAR(&JPGM )  TYPE(*CHAR) LEN(10)
             DCL        VAR(&JMSG )  TYPE(*CHAR) LEN(100)
             CHGVAR     VAR(&JPGM)   VALUE('ABBC91')
             CALL       PGM(UTLR23)  PARM(&JPGM &JINF)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHKOBJ     OBJ(&WLIB/ABBC91ACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(SKP))

     /* JW1  SNDBRKMSG  MSG('Somebody else is using the same +         */
     /*                   program. Wait a while and try it again.') +  */
     /*                   TOMSGQ(&WSID) MSGTYPE(*INFO)                 */

             RTVDTAARA  DTAARA(&WLIB/ABBC91ACT (1 10))  RTNVAR(&JMBR)
             RTVDTAARA  DTAARA(&WLIB/ABBC91ACT (31 10)) RTNVAR(&JWS)
             RTVDTAARA  DTAARA(&WLIB/ABBC91ACT (41 10)) RTNVAR(&JPGM)
             CHGVAR     VAR(&JMSG) VALUE(&JMBR *BCAT 'IS USING THIS +
                          PROGRAM AT' *BCAT &JWS *TCAT '. +
                          (&WLIB/ABBC91ACT)')
             CALL       PGM(QUILNGTX) PARM(&JMSG X'00000046' ' ' ' ' +
                          X'00000000')

             GOTO       SEND

 SKP:        CRTDTAARA  DTAARA(&WLIB/ABBC91ACT) TYPE(*CHAR) LEN(50) +
                          VALUE(&JINF) TEXT('DAILY INV DATA +
                          HANDLING') AUT(*ALL)

             CLRPFM     FILE(ABBWP90)
             CALL       PGM(ABBR91)
             DLTDTAARA  DTAARA(&WLIB/ABBC91ACT)
 SEND:
             ENDPGM
