             PGM        PARM(&EFULIB &EFUFIL)
             /** OBAC60 **********************************/
             /* SEND INSTRUCTION TAG OUTGOING DATA     */
             /*         BETWEEN AS400, S88             */
             /* C:N.HAYAKAWA              93.03.18       */
             /********************************************/
             DCL        VAR(&WATFUN) TYPE(*DEC) LEN(2) VALUE(0)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SW01) TYPE(*CHAR) LEN(1)
             DCL        VAR(&EFUFIL) TYPE(*CHAR) LEN(9)
             DCL        VAR(&EFULIB) TYPE(*CHAR) LEN(9)
             DCL        VAR(&WT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&FIL60) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FIL61) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FIL62) TYPE(*CHAR) LEN(9)
             RTVJOBA    JOB(&WSID)
             CHGVAR     VAR(&WT) VALUE(%SST(&WSID 1 2))
             CHGVAR     VAR(&FIL60) VALUE('OBAWP60' *CAT &WT)
             CHGVAR     VAR(&FIL61) VALUE('OBAWP61' *CAT &WT)
             CHGVAR     VAR(&FIL62) VALUE('OBAWP62' *CAT &WT)
             /* WORK FILE DELETE */
             DLTF HWFILE/&FIL60
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF HWFILE/&FIL61
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF HWFILE/&FIL62
             MONMSG     MSGID(CPF3261 CPF2105)
             /* WORK FILE CREATE */
             CRTPF      FILE(HWFILE/&FIL60) RCDLEN(100) +
                          TEXT('INSTRUCTION TAG DATA EBC100') +
                          OPTION(*NOLIST) SIZE(2000 200) +
                          LVLCHK(*NO) AUT(*ALL)
             GRTOBJAUT  OBJ(&FIL60) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)

             CRTPF      FILE(HWFILE/&FIL61) RCDLEN(100) +
                          TEXT('INSTRUCTION TAG DATA ASC100') +
                          OPTION(*NOLIST) SIZE(2000 200) +
                          LVLCHK(*NO) AUT(*ALL)
             GRTOBJAUT  OBJ(&FIL61) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)

             CRTPF      FILE(HWFILE/&FIL62) RCDLEN(508) +
                          TEXT('INSTRUCTION TAG DATA ASC508') +
                          OPTION(*NOLIST) SIZE(2000 200) +
                          LVLCHK(*NO) AUT(*ALL)
             GRTOBJAUT  OBJ(&FIL62) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)

             /*  CREATE INSTRUCTION TAG PUBLICATION DATA FOR  SEND */
             OVRDBF     FILE(EAEWP04) TOFILE(&EFULIB/&EFUFIL)
             OVRDBF     FILE(OBAWP60) TOFILE(HWFILE/&FIL60)
             CALL       PGM(OBAR60) PARM(&SW01)
             DLTOVR     FILE(OBAWP60)
             DLTOVR     FILE(EAEWP04)
             /*EXIT WHEN RECORD IS 0*/
             IF         COND(&SW01 *NE '*') THEN(GOTO CMDLBL(NOREC))
             /**************************************************/
             /*CHECK AND CREATE DATA AREA FOR RUNNING COMMUNICATION PGM */
             /**************************************************/
 LOOP1:  /* CHKOBJ OBJ(HFILE/S88TRNACT) OBJTYPE(*DTAARA)             */
         /* MONMSG MSGID(CPF9801) EXEC(GOTO CMDLBL(NONACT)) */
             /*  WAIT FOR 1 MINUTE IF IT IS RUNNING */
         /* DLYJOB DLY(60)                                           */
             /* IF IT IS NO GOOD FOR 10 MINUTES, SEND A MESSAGE . */
         /* IF          COND(&WATFUN >= 10) THEN(SNDPGMMSG +         */
         /*              MSG('エフ出庫データのＳ８８に対する通信が+*/
         /*              １０分待ったが解除されない。情報課に連絡+ */
         /*              せよ。') TOMSGQ(&WSID) MSGTYPE(*INFO))    */
         /* CHGVAR VAR(&WATFUN) VALUE(&WATFUN + 1)                   */
         /* GOTO LOOP1                                               */

 NONACT: /* CRTDTAARA DTAARA(HFILE/S88TRNACT) TYPE(*CHAR) LEN(1) + */
         /*               TEXT('ARRS COMMUNICATION WHICH IS EXECUTED */
             /* IT IS CONVERTED INTO ASCII FROM  EBCDIC */
             OVRDBF     FILE(OBAWP60) TOFILE(HWFILE/&FIL60)
             OVRDBF     FILE(OBAWP61) TOFILE(HWFILE/&FIL61)
             CALL       PGM(OBAR61)
             DLTOVR     FILE(OBAWP60)
             DLTOVR     FILE(OBAWP61)
             /* DATA BLOCKING */
             OVRDBF     FILE(OBAWP61) TOFILE(HWFILE/&FIL61)
             OVRDBF     FILE(OBAWP62) TOFILE(HWFILE/&FIL62)
             CALL       PGM(OBAR62)
             DLTOVR     FILE(OBAWP61)
             DLTOVR     FILE(OBAWP62)
             /* SEND INSTRUCTION TAG DATA  AS400 => S88 */
         /* OVRDBF FILE(S88WP01) TOFILE(WORKLIB/&FIL62) */
         /* CALL PGM(S88R01)                                   */
         /* DLTOVR FILE(S88WP01)                               */
             /* DATA AREA DELETE */
         /* DLTDTAARA DTAARA(OALIB/S88TRNACT)                  */
             /* TAG DUMP LIST CREATE */
         /* OVRPRTF FILE(OBAPR63) LPI(6) OVRFLW(60) + */
         /*               RPLUNPRT(*YES) OUTQ(HAYAKAWA/SIJIF) +*/
         /*               FORMTYPE(K6H1) HOLD(*YES)            */
         /* OVRDBF FILE(OBAWP60) TOFILE(HQFILE/&FIL60) */
         /* CALL PGM(OBAR63) PARM(A2033)                       */
         /* DLTOVR FILE(OBAPR63)                               */
         /* DLTOVR FILE(OBAWP60)                               */
             /* WORK FILE DELETE  */
  NOREC: /*DLTF HWFILE/&FIL60 */
           /*DLTF HWFILE/&FIL61 */
           /*DLTF HWFILE/&FIL62 */

             ENDPGM
