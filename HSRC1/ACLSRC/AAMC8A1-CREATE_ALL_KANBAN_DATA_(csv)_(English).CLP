             PGM        PARM(&POUT)
             /** AAMC8A1***************************************/
             /*  DOWNLOAD KANBAN RECICLE DAY DATA TO CSV      */
             /*  JW       2025.02.10                          */
             /*************************************************/
             DCL        VAR(&WSID)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3)     TYPE(*CHAR) LEN(3)
             DCL        VAR(&POUT)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&AAMWP80) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AAMWP81) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AAMWP82) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FNAM)    TYPE(*CHAR) LEN(30)

             RTVJOBA    JOB(&WSID)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&AAMWP80) VALUE('AAMWP80' *CAT &WS3)
             CHGVAR     VAR(&AAMWP81) VALUE('AAMWP81' *CAT &WS3)
             CHGVAR     VAR(&AAMWP82) VALUE('AAMWP82' *CAT &WS3)

 /** CREATE AAMWP81 **/
             DLTF       FILE(HWFILE1/&AAMWP81)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&AAMWP81) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(AAMWP81) +
                          OPTION(*NOLIST *NOSRC) SIZE(50000 5000 +
                          3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AAMWP80) TOFILE(&AAMWP80)
             OVRDBF     FILE(AAMWP81) TOFILE(&AAMWP81)
             CALL       PGM(AAMR8A) PARM(&POUT)

 /** CREATE AAMWP82 **/
             DLTF       FILE(HWFILE1/&AAMWP82)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&AAMWP82) RCDLEN(512) +
                          OPTION(*NOLIST *NOSRC) SIZE(10000 5000 3) +
                          LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AAMWP82) TOFILE(&AAMWP82)
             CALL       PGM(AAMR8B1) PARM(&POUT)

 /** DOWNLOAD TO CSV **/
             IF         COND(&POUT *EQ '1') THEN(DO)
             CHGVAR     VAR(&FNAM) VALUE('ALL KANBAN DATA BY LOACTION')
             ENDDO
             IF         COND(&POUT *EQ '2') THEN(DO)
             CHGVAR     VAR(&FNAM) VALUE('ALL KANBAN DATA BY PART#')
             ENDDO
             IF         COND(&POUT *EQ '3') THEN(DO)
             CHGVAR     VAR(&FNAM) VALUE('ALL KANBAN DATA (TOTAL)')
             ENDDO

             CALL       PGM(APLC94) PARM('1' &AAMWP82 'HWFILE1' &FNAM +
                          'Y' ' ' 'Y')
 ENDP:
             ENDPGM
