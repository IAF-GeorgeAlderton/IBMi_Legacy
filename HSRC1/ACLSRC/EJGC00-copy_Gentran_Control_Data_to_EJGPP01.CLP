             PGM        PARM(&CSV &OPT)
             /** EJGC00 *************************************/
             /*  COPY GENTRAN CONTROL DATA TO EJGPP01       */
             /*    J.WATANABE                 2016.12.06    */
             /*                                             */
             /*  PARAMETER                                  */
             /*    &CSV: SOURCE DATA (CSV)                  */
             /*    &OPT: R:REPLACE, U=UPDATE                */
             /***********************************************/

             DCL        VAR(&CSV)  TYPE(*CHAR) LEN(12)
             DCL        VAR(&OPT)  TYPE(*CHAR) LEN(01)
             DCL        VAR(&LIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FIL1) TYPE(*CHAR) LEN(59)
             DCL        VAR(&FIL2) TYPE(*CHAR) LEN(80)

             CHGVAR     VAR(&LIB) VALUE('TFILE1')
             CHGVAR     VAR(&WLIB) VALUE('TWFILE1')

             CHGVAR     VAR(&FIL1) +
                          VALUE('/QNTC/IAF-AS400-FILE/AS400-TRANS/PC/+
                          Download/AS400/GENTRAN/')
             CHGVAR     VAR(&FIL2) VALUE(&FIL1 *TCAT &CSV)

STP1:   /*********************************************************/
        /* upload SALES-UP.csv --> AS400 HWFILE1/FBCWP83         */
        /*********************************************************/
             CLRPFM     FILE(&WLIB/EJGWP01)
             CPYFRMIMPF FROMSTMF(&FIL2) TOFILE(&WLIB/EJGWP01) +
                          MBROPT(*REPLACE) FROMCCSID(*FILE) +
                          RCDDLM(*CRLF) STRDLM(*DBLQUOTE) +
                          DATFMT(*USA) TIMFMT(*USA) +
                          ERRRCDOPT(*REPLACE) RPLNULLVAL(*FLDDFT)

  /* REPLACE/UPDATE RECORD */
             CALL       EJGR01 PARM(&CSV &OPT)

             ENDPGM
