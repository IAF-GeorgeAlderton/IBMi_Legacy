             PGM        (&TOEMAIL &SUBJECT &STMF)
             /** TESTJW1 *********************************************/
             /*  DOWNLOAD MAIL BODY TO IFS                           */
             /*  J.W  2025.10.20                                     */
             /********************************************************/
/* SEND TO EMAIL ADDRESS **/
             DCL        VAR(&TOEMAIL) TYPE(*CHAR) LEN(256)
/* SUBJECT OF EMAIL      **/
             DCL        VAR(&SUBJECT) TYPE(*CHAR) LEN(256)
/* IFS ADDRESS           **/
             DCL        VAR(&STMF)    TYPE(*CHAR) LEN(1024)

/* SET PARAMETER */
             CHGVAR     VAR(&TOEMAIL) VALUE('ﾁｱﾔ.ﾑｱﾎｱﾄｱｲｵ@ｹｱｶｹ.ｳﾅﾃ')
             CHGVAR     VAR(&SUBJECT) VALUE('EDI 997 Rｵﾆﾅﾈﾎ - FORD')
             CHGVAR     VAR(&STMF) +
                          VALUE('/QNTC/IAF-AS400-FILE/AS400-TRANS/PC/D+
                          OWNLOAD/FORD/ATT00001.CSV')

/* DOWNLOAD QPRINT TO IFS */
             CALL TESTJW2




/* CLEAR WORK FILE */
             CLRPFM   FILE(HFILE1/EDIBUF)

             CALL TESTJW9  (&TOEMAIL &SUBJECT &STMF)

             ENDPGM
