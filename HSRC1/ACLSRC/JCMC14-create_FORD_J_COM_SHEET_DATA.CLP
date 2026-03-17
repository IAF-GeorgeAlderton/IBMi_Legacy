/* JCMC14 *******************************************************************/
/*  CREATE JCMWP01/02 AND PRINT J-COM SHEET                                 */
/*  J.WATANABE 05/25/2016                                                   */
/****************************************************************************/
            PGM

             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&ASN )  TYPE(*CHAR) LEN(8)
             DCL        VAR(&NO  )  TYPE(*CHAR) LEN(3)
             DCL        VAR(&RTN )  TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTN1)  TYPE(*CHAR) LEN(1)


/* JW2 CHECK OTHER USER IS USING  ==================================*/
             CALL CHKC45 ('JCMC14' 'JCMC14' 'Y'  'CHK' &RTN1)
             IF         COND(&RTN1 *NE ' ') THEN(GOTO ENDP)
/* =================================================================*/

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             /* BEFORE RUN JCMR17, UPDATE J-COM FILE (JCMPP11/12) */
             CALL       PGM(JCMC10) PARM(' ')

             CLRPFM     FILE(*LIBL/JCMWP11)
             CLRPFM     FILE(*LIBL/JCMWP12)

     /*      CALL       PGM(JCMR14) PARM(&ASN &NO &RTN)  */
             CALL       PGM(JCMR17) PARM(&ASN &NO &RTN)

             IF         COND(&RTN = '*') THEN(DO)
             SNDPGMMSG  MSG('Eﾈﾈﾅﾈ! J-Cﾅﾃ ｴｱﾎｱ ﾑｱﾍ ﾄﾅﾎ ｳﾈｵｱﾎｵｴ!')
             GOTO       ENDX
             ENDDO

             SNDPGMMSG  MSG(&NO *CAT ' ASN ﾍｸｵｵﾎ ｸｱﾍ ｲｵｵﾄ ｳﾈｵｱﾎｵｴ.')

       /* SAVE JCMWP11/12 TO JCMWP11S/12S */
             CPYF       FROMFILE(HWFILE1/JCMWP11) +
                          TOFILE(HWFILE1/JCMWP11S) MBROPT(*ADD) +
                          FMTOPT(*MAP *DROP)
             MONMSG     MSGID(CPF0000)

             CPYF       FROMFILE(HWFILE1/JCMWP12) +
                          TOFILE(HWFILE1/JCMWP12S) MBROPT(*ADD) +
                          FMTOPT(*MAP *DROP)
             MONMSG     MSGID(CPF0000)
ENDX:
       /*JW2*DLTDTAARA  DTAARA(XXXXXX) ****************/
             CALL CHKC45 ('JCMC14' 'JCNC14' 'N'  '' '')

ENDP:
             ENDPGM
