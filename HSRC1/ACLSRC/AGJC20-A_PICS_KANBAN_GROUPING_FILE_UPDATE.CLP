             PGM
             /*** AGJC20 ***********************************/
             /* A-PICS KANBAN GROUPING FILE UPDATE         */
             /*  IWATA             2018.04.19              */
             /********************************** AGJC20 ****/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&FLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&DDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&AGJWP20) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             RTVJOBA    JOB(&WSID) USER(&PPUSER) DATE(&DDATE)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO

             CHGVAR     VAR(&AGJWP20) VALUE('AGJWP20' *CAT &WS3)

             CHGJOB     OUTQ(&PRTG)

 #STP10:
             DLTF       FILE(&WLIB/&AGJWP20)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AGJWP20) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(AGJWP20) +
                          OPTION(*NOLIST *NOSRC) SIZE(999 500 +
                          3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AGJWP20) TOFILE(&WLIB/&AGJWP20)

             /* EXTRACT FROM M/F TO WORK FILE */
             CALL       PGM(AGJR23)

             /* UPDATE WORK FILE */
             CALL       PGM(AGJR20) PARM(&PCMD)
             IF         COND(&PCMD *EQ '01') THEN(DO)
             GOTO END
             ENDDO

             /* UPDATE M/F FROM WORK FILE */
             CLRPFM     FILE(HFILE1/AGJPP20)
             CALL       PGM(AGJR24)
 END:
             ENDPGM
