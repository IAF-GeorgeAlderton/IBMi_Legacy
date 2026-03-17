             PGM
             /** AB#C40 ************************/
             /* ..EDI FIXED ORDER DATA AMEND.. */
             /*   I-HASADA          97.07.15   */
             /*   TCH ADD TEST LIB  00.10.10   */
             /*                                */
             /*   ADD LOG PGM  02.01.10        */
             /************************ AB#C40 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SR) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PRT)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&FILE1)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE2)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHGJOB     SWS(00000000)
             CHGVAR     VAR(&SR) VALUE(%SST(&WSID 1 2))
             CHGVAR     VAR(&FILE1) VALUE(AB#WP40 *CAT &SR)
             CHGVAR     VAR(&FILE2) VALUE(AB#WP41 *CAT &SR)

             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE1) RCDLEN(100) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(AB#WP40) TOFILE(&FILE1)
             CALL       PGM(AB#R40) PARM(&USER)

             IF         (%SWITCH(0XXXXXXX)) DO
             GOTO       END
             ENDDO

             CALL       PGM(AB#RL4)

             DLTF       FILE(&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE2) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AB#WP41) OPTION(*NOLIST *NOSRC) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(AB#WP40) TOFILE(&FILE1)
             OVRDBF     FILE(AB#WP41) TOFILE(&FILE2)
             CALL       PGM(AB#R41)

             OVRDBF     FILE(AB#WP41) TOFILE(&FILE2)
             CALL       PGM(AB#R42)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)

             OVRDBF     FILE(AB#WP41) TOFILE(&FILE2)
     /*****  CALL       PGM(AB#R43)   ******/

 END:        DLTOVR     FILE(*ALL)

             ENDPGM
