             PGM
             /** FCKC01 ********************************************/
             /*  CHECK FA MASTER(AJSPP01) AND SEND REPORT BY MAIL  */
             /*  ADD JOB TO FCKC00  (JOB SCHEDULE: 10:10 AM)       */
             /*  J.WATANABE  2017.05.03                            */
             /******************************************************/

             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1)

             OVRDBF     FILE(AJSPP01) TOFILE(HFILE1/AJSPP01)
             CALL       PGM(HOBJ1/FCKR01) PARM(&RTN)

             IF         COND(&RTN = ' ') THEN(GOTO CMDLBL(@NOER))

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT132B) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)

             OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132B)

             CALL       PGM(AB#RW0)

             SNDDST     TYPE(*FILE) +
                          TOINTNET((Takanao.Kato2@iafi.com) +
                          (Kaz.Watanabe@iafi.com)) DSTD('FA MASTER +
                          CHECK LIST (FCKC01)') MSG('FA MASTER HAS +
                          IRREGULAR DATA. PLEASE CHEK ATTACHED +
                          LIST.(FCKC01)') DOCFILE(HWFILE1/PRT132B) +
                          DOCTYPE(*FFT) SNDFMT(*NOTE) DOCD('FA +
                          MASTER CHECK LIST') DOCDATE(*CURRENT) +
                          CRTDATE(*CURRENT)

             SNDDST     TYPE(*FILE) +
                          TOINTNET((QualityEngineers@iafi.com)) +
                          DSTD('FA MASTER CHECK LIST (FCKC01)') +
                          MSG('FA MASTER HAS IRREGULAR DATA. PLEASE +
                          CHEK ATTACHED LIST.(FCKC01)') +
                          DOCFILE(HWFILE1/PRT132B) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD('FA MASTER CHECK +
                          LIST') DOCDATE(*CURRENT) CRTDATE(*CURRENT)
             GOTO CMDLBL(@END)

@NOER:
        /*   SNDDST     TYPE(*LMSG) +                              */
        /*                TOINTNET((KAZ.WATANABE@IAFI.COM)) +      */
        /*                DSTD('NO ERROR FOR FA MASTER CHK LIST +  */
        /*                (FCKC01)') LONGMSG('NO ERROR FOR FA +    */
        /*                MASTER (FCKC01)') DOCD('NO ERROR +       */
        /*                FOR FA MASTER CHK')                      */

@END:        ENDPGM
