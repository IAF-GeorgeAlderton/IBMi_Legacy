             PGM
             /** FCKC02 ********************************************/
             /*  CHECK FA MASTER(AARPP11) WGT AND SEND REPORT MAIL */
             /*  ADD JOB TO FCKC00  (JOB SCHEDULE: 10:10 AM)       */
             /*  J.WATANABE  2017.07.07                            */
             /******************************************************/

             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1)

             CALL       PGM(*LIBL/FCKR02) PARM(&RTN)

             IF         COND(&RTN = ' ') THEN(GOTO CMDLBL(@NOER))

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT132B) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)

             OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132B)

             CALL       PGM(AB#RW0)

    /*       SNDDST     TYPE(*FILE) +                                  */
    /*                    TOINTNET((Kaz.Watanabe@iafi.com)) +          */
    /*                    DSTD('FA MASTER WGT CHECK LIST (FCKC02)') +  */
    /*                    MSG('*** FA MASTER HAS IRREGULAR DATA. PLEASE +  */
    /*                    CHEK ATTACHED LIST.(FCKC02)') +              */
    /*                    DOCFILE(HWFILE1/PRT132B) DOCTYPE(*FFT) +     */
    /*                    SNDFMT(*NOTE) DOCD('FA MASTER WGT CHECK +    */
    /*                    LIST') DOCDATE(*CURRENT) CRTDATE(*CURRENT)   */

             SNDDST     TYPE(*FILE) +
                          TOINTNET((Takanao.Kato2@iafi.com)) +
                          DSTD('FA MASTER WGT CHECK LIST (FCKC02)') +
                          MSG('** ERROR ** FA MASTER HAS IRREGULAR +
                          DATA. PLEASE CHEK AN ATTACHED +
                          LIST.(FCKC02).') DOCFILE(HWFILE1/PRT132B) +
                          DOCTYPE(*FFT) SNDFMT(*NOTE) DOCD('FA +
                          MASTER WGT CHECK LIST') DOCDATE(*CURRENT) +
                          CRTDATE(*CURRENT)

             SNDDST     TYPE(*FILE) +
                          TOINTNET((QualityEngineers@iafi.com)) +
                          DSTD('FA MASTER WGT CHECK LIST (FCKC02)') +
                          MSG('** ERROR ** FA MASTER HAS IRREGULAR +
                          DATA. PLEASE CHEK AN ATTACHED +
                          LIST.(FCKC02).') DOCFILE(HWFILE1/PRT132B) +
                          DOCTYPE(*FFT) SNDFMT(*NOTE) DOCD('FA +
                          MASTER WGT CHECK LIST') DOCDATE(*CURRENT) +
                          CRTDATE(*CURRENT)
             GOTO CMDLBL(@END)

@NOER:
        /*   SNDDST     TYPE(*LMSG) +                                   */
        /*                TOINTNET((KAZ.WATANABE@IAFI.COM)) +           */
        /*                DSTD('NO ERROR FOR FA MASTER WGT CHK LIST +   */
        /*                (FCKC02)') LONGMSG('NO ERROR FOR FA +         */
        /*                MASTER *WGT* (FCKC02)') DOCD('NO ERROR +      */
        /*                FOR FA MASTER WGT CHK')                       */

@END:        ENDPGM
