             PGM        PARM(&NONY &SHID &RTN)
/* JCMC32 *******************************************************************/
/*  CREATE FORD ASN (CANCEL)                                                */
/*  J.WATANABE 2022.06.22                                                   */
/****************************************************************************/
             DCL        VAR(&NONY) TYPE(*CHAR) LEN(4)
             DCL        VAR(&SHID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTN ) TYPE(*CHAR) LEN(1)

             OVRDBF     FILE(EB#EP66) TOFILE(QTEMP/EB#EP66)
             OVRDBF     FILE(EB#EP63) TOFILE(QTEMP/EB#EP63)
             OVRDBF     FILE(EB#EP64) TOFILE(QTEMP/EB#EP64)
             OVRDBF     FILE(EB#EP65) TOFILE(QTEMP/EB#EP65)

             CALL       PGM(JCMR32) PARM(&NONY &SHID &RTN )

             ENDPGM
