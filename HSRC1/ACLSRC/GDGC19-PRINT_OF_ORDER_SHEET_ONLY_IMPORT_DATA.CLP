             PGM
             /*** GDGC19 **********************************/
             /*  PRINT OF ORDER SHEET  ONLY IMPORT DATA   */
             /*                                           */
             /*  N.HYOTO 2001.06.08                       */
             /*  GDGR20 ->ASJOUTQ         05/13/04   */
             /*************************** BASED ON GDGC12 */
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPGO) TYPE(*CHAR) LEN(2)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)
             RTVJOBA    JOB(&WSID) USER(&PPUSER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)

/*                                                                     */
/*           CHKOBJ     OBJ(TRANS) OBJTYPE(*DTAARA)                    */
/*           MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +                */
/*                        DTAARA(TRANS) TYPE(*CHAR) +                  */
/*                        LEN(2) TEXT('IAF->ASJ TRANSFER CHECK'))      */
/*                                                                     */
/*           CHGVAR     VAR(&PPGO) VALUE('  ')                         */
/*           CALL       PGM(GDGR12) PARM(&PPUSER &PPGO)                */
/*                                                                     */
/*           IF         COND(&PPGO = 'GO') THEN(DO)                    */
/*                                                                     */
/*           DLTF       FILE(GDGWP13)                                  */
/*           MONMSG     MSGID(CPF3261 CPF2105)                         */
/*           CRTPF      FILE(&WLIB/GDGWP13) RCDLEN(128) +              */
/*                        OPTION(*NOLIST *NOSRC) SIZE(1000 500 5) +    */
/*                        LVLCHK(*NO) AUT(*ALL)                        */
/*                                                                     */
/*           OVRPRTF    FILE(GDGPR13) DEVTYPE(*AFPDS) LPI(6) +         */
/*                        RPLUNPRT(*YES) OUTQ(LANPRT02) FORMTYPE(K6S1)  */
/*           CALL       PGM(GDGR13) PARM(&PPUSER)                      */
/*           CLRPFM     FILE(GDGPP10)                                  */
/*                                                                     */
/*           CLRPFM     FILE(GDIWP10)                                  */
/*           CALL       PGM(GDIR14)                                    */
/*           CPYF       FROMFILE(GDIWP10) TOFILE(GDIPP10) +            */
/*                        MBROPT(*REPLACE) FMTOPT(*NOCHK)              */
/*           MONMSG     MSGID(CPF0000)                                 */
/*                                                                     */
/*           DLTF       FILE(GDIWP13)                                  */
/*           MONMSG     MSGID(CPF3261 CPF2105)                         */
/*           CRTPF      FILE(&WLIB/GDIWP13) RCDLEN(128) +              */
/*                        OPTION(*NOLIST *NOSRC) SIZE(1000 500 5) +    */
/*                        LVLCHK(*NO) AUT(*ALL)                        */
/*                                                                     */
/*           OVRPRTF    FILE(GDIPR13) DEVTYPE(*AFPDS) LPI(6) +         */
/*                        RPLUNPRT(*YES) OUTQ(LANPRT02) FORMTYPE(K6S1)  */
/*           CALL       PGM(GDIR13) PARM(&PPUSER)                      */
/*           CLRPFM     FILE(GDIPP10)                                  */
/*           DLTOVR     FILE(*ALL)                                     */
/*                                                                     */
/*           SNDNETF    FILE(&WLIB/GDGWP13) TOUSRID((QFILE SYSTEM1))   */
/*           SNDNETF    FILE(&WLIB/GDIWP13) TOUSRID((QFILE SYSTEM1))   */
/*                                                                     */
             /*------------------------------------------*/
             /*   ...SBMNETJOB rｮnﾝｰh ﾆﾞｭﾎﾞ ﾉ ncpｬc...   */
             /*------------------------------------------*/
/*           SBMNETJOB  FILE(HSRC1/ACLSRC) TOUSRID((QFILE SYSTEM1)) +  */
/*                        MBR(GDGT13)                                  */
/*                                                                     */
/*           CHGDTAARA  DTAARA(TRANS) VALUE('  ')                      */
/*                                                                     */
/*           ENDDO                                                     */
             /*----------------------------*/
             /*   シッピング情報の更新   */
             /*----------------------------*/
             CHGVAR     VAR(&REC) VALUE(0)
             RTVMBRD    FILE(&WLIB/GIGWP52) NBRCURRCD(&REC)
             IF         COND(&REC *NE 0) THEN(DO)
             OVRDBF     FILE(INFILE) TOFILE(&WLIB/GIGWP52)
             OVRPRTF    FILE(QPRINT) OVRFLW(52) OUTQ(ASJOUTQ) +
                          FORMTYPE(K6H1)
             CALL       PGM(GDGR20) PARM(&PPUSER)
             DLTOVR     FILE(*ALL)
             CLRPFM     FILE(&WLIB/GIGWP52)
             ENDDO

             CHGVAR     VAR(&REC) VALUE(0)
             RTVMBRD    FILE(&WLIB/GIGWP53) NBRCURRCD(&REC)
             IF         COND(&REC *NE 0) THEN(DO)
             OVRDBF     FILE(INFILE) TOFILE(&WLIB/GIGWP53)
             OVRPRTF    FILE(QPRINT) OVRFLW(52) OUTQ(ASJOUTQ) +
                          FORMTYPE(K6H1)
             CALL       PGM(GDIR20) PARM(&PPUSER)
             DLTOVR     FILE(*ALL)
             CLRPFM     FILE(&WLIB/GIGWP53)
             ENDDO

             ENDPGM
