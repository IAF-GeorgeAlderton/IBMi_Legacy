             PGM        PARM(&SRCFIL &SRCMBR)
             /** FTPC01  *********************************************/
             /*  TRANSFER SOURCE CODE TO IFS                         */
             /*  J.W  2025.10.27                                     */
             /********************************************************/
/* SOURCE DATA           **/
             DCL        VAR(&SRCLIB ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SRCFIL ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SRCMBR ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FNAM   ) TYPE(*CHAR) LEN(30)
/* IFS ADDRESS           **/
             DCL        VAR(&STMF)    TYPE(*CHAR) LEN(100)

             CHGVAR     VAR(&SRCLIB) VALUE('HSRC1')
       /***  CHGVAR     VAR(&SRCFIL) VALUE('ARPGSRC') ***/
       /***  CHGVAR     VAR(&SRCMBR) VALUE('AB#R0A ') ***/
             CHGVAR     VAR(&FNAM  ) VALUE('RPGSRC')

             CPYF       FROMFILE(&SRCLIB/&SRCFIL) +
                          TOFILE(HFILE1/WRKPP80) FROMMBR(&SRCMBR) +
                          MBROPT(*REPLACE) FMTOPT(*CVTSRC)

/* DOWNLOAD QPRINT TO IFS */

             CHGVAR     VAR(&STMF) +
                          VALUE('/QNTC/IAF-AS400-FILE/AS400-TRANS/PC/D+
                          OWNLOAD/I0777/')

             CALL       PGM(APLC94NS) PARM(('2') ('WRKPP80') +
                          ('HFILE1') (&FNAM) ('T') ('N') ('Y') +
                          (&STMF))

             ENDPGM
