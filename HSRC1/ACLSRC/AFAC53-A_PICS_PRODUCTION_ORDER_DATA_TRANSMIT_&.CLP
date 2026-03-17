             PGM
             /** AFAC53 *******************************************/
             /*  A-PICS PRODUCTION ORDER DATA TRANSMIT & PROCESS  */
             /*      I-HASADA                     1997.04.16      */
             /******************************************* AFAC53 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PBMN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PKBN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDAT) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PBIN) TYPE(*CHAR) LEN(2) VALUE('00')
             DCL        VAR(&PSBN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PTSR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PFIL) TYPE(*CHAR) LEN(9)
             RTVJOBA    JOB(&WSID)

             CHGJOB     SWS(00000000)

             CHGVAR     VAR(&PBMN) VALUE('0111')
             CALL       PGM(AFAR54) PARM(&PBMN &PKBN &PDAT &PBIN +
                          &PSBN &PTSR)

             IF         (%SWITCH(1XXXXXXX)) DO
             GOTO       END
             ENDDO

             CALL       PGM(AFAR53) PARM(&PBMN &PDAT &PBIN &PSBN +
                          &PTSR &PFIL)

             IF         (%SWITCH(X1XXXXXX)) DO
             GOTO       END
             ENDDO

             DLTF       FILE(AAA0111)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HFILE1/AAA0111) RCDLEN(256) +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX) AUT(*ALL)
             CPYF       FROMFILE(&PFIL) TOFILE(AAA0111) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)

             CHGVAR     VAR(&PKBN) VALUE('*')
             CALL       PGM(AFAR54) PARM(&PBMN &PKBN &PDAT &PBIN +
                          &PSBN &PTSR)

 END:        ENDPGM
