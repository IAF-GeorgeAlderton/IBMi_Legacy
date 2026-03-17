             PGM
/** AB#CAC ************************************************/
/*  SHIPPING PREPARATION CHECK LIST                       */
/*    H.AMANO       NOV/24/03                             */
/*                                                        */
/* TCHK1 05/06/11 ADD TEMPORARY CHANGE CALENDAR M/F       */
/**********************************************************/
             DCL        VAR(&ID) TYPE(*CHAR) LEN(1)

/* TCHK1 */  OVRDBF     FILE(AGDPP11) TOFILE(HFILE1/A@DPP11)
/* TCHK1 */  OVRDBF     FILE(AGDPL11) TOFILE(HFILE1/A@DPL11)
/* TCHK1 */  OVRDBF     FILE(AGDPL12) TOFILE(HFILE1/A@DPL12)

             CALL       PGM(AB#C82)

             DLTF       FILE(QTEMP/PRT132)
             MONMSG     MSGID(CPF0000)
             CRTPF      FILE(QTEMP/PRT132) RCDLEN(132)

             OVRDBF     FILE(PRT132) TOFILE(QTEMP/PRT132)
             CALL       PGM(AB#RAC) PARM(&ID)


             IF         COND(&ID *EQ ' ') THEN(GOTO CMDLBL(@END))

             CPYF       FROMFILE(QTEMP/PRT132) +
                          TOFILE(HWFILE1/PRT132A) MBROPT(*REPLACE)

/* TCHK1 S */
/* TCHK1     SNDDST     TYPE(*FILE) TOINTNET((APIC@iafi.com)) +
                          DSTD('Shipping preparation check') +
                          MSG('Please check the attached list to +
                          confirm shipping preparation.(AB#CAC).') +
                          DOCFILE(HWFILE1/PRT132A) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD('Shipping preparation +
                          check') DOCDATE(*CURRENT) CRTDATE(*CURRENT) */

             SNDDST     TYPE(*FILE) TOINTNET(                    +
                          (ShippingPreparationCheck@iafi.com)    +
                                                            )    +
                          DSTD('Shipping preparation check')     +
                          MSG('Please check the attached list to +
                          confirm shipping preparation.(AB#CAC).') +
                          DOCFILE(HWFILE1/PRT132A) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE)                          +
                          DOCD('Shipping preparation check')     +
                          DOCDATE(*CURRENT) CRTDATE(*CURRENT)
/* TCHK1 E */
@END:
             OVRPRTF    FILE(QPRINT) OUTQ(QPRINT) FORMTYPE(K6H1)
             CALL AB#RAF
             DLTOVR     FILE(QPRINT)

             ENDPGM
