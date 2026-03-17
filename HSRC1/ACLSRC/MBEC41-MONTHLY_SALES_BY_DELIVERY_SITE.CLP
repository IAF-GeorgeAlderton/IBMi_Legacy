             PGM
             /*** MBEC41 **********************************/
             /*  T.N.K.U    MONTHLYSALES BY DELIVERY SITE */
             /*      H.ITO             90.06.13           */
             /********************************** MBEC41 ***/
             DCLF       FILE(MBEPW41)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MCEDP01) TYPE(*CHAR) LEN(8)
             DCL        VAR(&CHKY) TYPE(*CHAR) LEN(4)
             DCL        VAR(&CHKM) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(100)

             RTVDTAARA  DTAARA(MCEDP01) RTNVAR(&MCEDP01)
             RTVJOBA    JOB(&WSID) USER(&US)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGVAR     VAR(&CHKY) VALUE(%SST(&MCEDP01 1 4))
             CHGVAR     VAR(&CHKM) VALUE(%SST(&MCEDP01 5 2))
 @001:       SNDRCVF    DEV(&WSID) RCDFMT(MBEPW411)
             IF         (&IN01 *EQ '1') GOTO END
             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN03) VALUE('0')
             CHGVAR     VAR(&IN04) VALUE('0')
             CHGVAR     VAR(&IN06) VALUE('0')
             CHGVAR     VAR(&IN07) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&IN80 *EQ '1') DO
             CALL       PGM(GGBR19)
             GOTO       CMDLBL(@001)
             ENDDO

             IF         (&@TOKU = '    ') DO
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE(' CUSTOMER IS NOT INPUT ')
             GOTO       CMDLBL(@001)
             ENDDO

             IF         (&@NONY *EQ '    ') DO

             IF         ((&@NKOJ *EQ ' ') *AND (&@NUKE *EQ '    ')) DO
             ENDDO
             ELSE       DO
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN04) VALUE('1')
             CHGVAR     VAR(&IN06) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) +
                          VALUE('REVERSING ITEM IS NOT RIGHT        ')
             GOTO       CMDLBL(@001)
             ENDDO

             ENDDO
             ELSE       DO

             IF         (&@NKOJ *EQ ' ') DO
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN04) VALUE('1')
             CHGVAR     VAR(&IN06) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) +
                          VALUE('  FACTORY IS NOT INPUT  ')
             GOTO       CMDLBL(@001)
             ENDDO

             IF         (&@NUKE *EQ '    ') DO
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN04) VALUE('1')
             CHGVAR     VAR(&IN06) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) +
                          VALUE('  DOCK CODE IS NOT INPUT ')
             GOTO       CMDLBL(@001)
             ENDDO
             ENDDO

             IF         COND(&@NEN *LT 1998) THEN(DO)
             CHGVAR     VAR(&IN07) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('  YEAR IS NOT RIGHT   ')
             GOTO       CMDLBL(@001)
             ENDDO

             IF         COND(&@TUK *LT 01 *OR &@TUK *GT 12) THEN(DO)
             CHGVAR     VAR(&IN07) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE(' MONTH IS NOT RIGHT   ')
             GOTO       CMDLBL(@001)
             ENDDO

             IF         (&IN05 *EQ '0') GOTO @001

             DLTF       FILE(HWFILE1/MBEWP41)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/MBEWP41) RCDLEN(512) +
                          OPTION(*NOLIST) SIZE(30000 10000) +
                          LVLCHK(*NO) AUT(*ALL)
             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(TPRINT) FORMTYPE(K6H1)
             CALL       PGM(MBER41) PARM(&@TOKU &@NONY &@NKOJ &@NUKE +
                          &@NEN &@TUK &MCEDP01)
             DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF2128)

 END:        ENDPGM
