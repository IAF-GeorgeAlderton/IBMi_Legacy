             PGM        PARM(&WKCD &TT)
             /** AM#C450 ***************************************       *****/
             /*    LEC   2024/05/07                                        */
             /**************************************************        ****/

             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PFLG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&PSIRE)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&PNOHZ)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&PNOBN)  TYPE(*DEC) LEN(2 0)
             DCL        VAR(&D@DLDT) TYPE(*CHAR) LEN(8)
             DCL        VAR(&WKCD)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&TT) TYPE(*CHAR) LEN(19)

             DCL        VAR(&MSGTXT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&PKINP) TYPE(*CHAR) LEN(5)


             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)
             CHGJOB     SWS(00000000)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)


  /* -------------------------------------------------------------- */
  /* create work files...                                           */
             CRTDUPOBJ  OBJ(AB#WP32) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/AB#WP32

             CRTDUPOBJ  OBJ(AB#WP33) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/AB#WP33

             CRTDUPOBJ  OBJ(MITANKF) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/MITANKF

             OVRDBF     FILE(AB#WP32) TOFILE(QTEMP/AB#WP32)
             OVRDBF     FILE(AB#WP33) TOFILE(QTEMP/AB#WP33)
             OVRDBF     FILE(MITANKF) TOFILE(QTEMP/MITANKF)

  /* -------------------------------------------------------------- */
  /*  create work file from toyota scs packing data...              */

             CALL       PGM(AM#R450) PARM(&WKCD &TT)

  /* -------------------------------------------------------------- */
  /*  update work file from part master...                          */

             OVRDBF     FILE(AB#WP32) TOFILE(QTEMP/AB#WP32)
             CALL       PGM(AB#R3Y)

  /* -------------------------------------------------------------- */
  /*  create work file 33 with price from price master pgm call...  */

             CHGVAR     VAR(&PFLG) VALUE(' ')
             CALL       PGM(AB#R35) PARM(&PFLG)

  /* -------------------------------------------------------------- */
  /*  print no price report and email to distr list...              */
             IF         (&PFLG *EQ '*') DO

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(LANPRT50) +
                          FORMTYPE(K6H1) HOLD(*YES) IGCDTA(&PIGCD)

             CALL       PGM(AB#R36) PARM(&PSIRE &PNOHZ)

             CRTDUPOBJ  OBJ(PRT132B) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/PRT132B

             CPYSPLF    FILE(QPRINT) TOFILE(QTEMP/PRT132B) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             MONMSG     MSGID(CPF3429)

             OVRDBF     FILE(PRT132) TOFILE(QTEMP/PRT132B)
             CALL       PGM(AB#RW0)

             SNDDST     TYPE(*FILE) TOINTNET((SalesGroup@iafi.com) +
                          (Production_Control@iafi.com *CC)) +
                          DSTD('Unit price not registered') MSG('** +
                          ERROR ** Some parts need pricing. Please +
                          check the attached report. (AB#C450).') +
                          DOCFILE(QTEMP/PRT132B) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD('POSTING ERROR MESSAGE')
             MONMSG     MSGID(CPF0000)

             DLTOVR     FILE(PRT132)

             ENDDO

  /* -------------------------------------------------------------- */
  /*  post work file 33 to sales file...                            */
             OVRDBF     FILE(AB#WP33) TOFILE(QTEMP/AB#WP33)
             CALL       PGM(AB#R37) PARM(&USER &PNOHZ &PNOBN &D@DLDT)

  /* -------------------------------------------------------------- */
  /*  flag these orders in packing file as "Posted"...              */
             CALL       PGM(AB#R37P) PARM(&WKCD)

  /* -------------------------------------------------------------- */

             DLTOVR     FILE(*ALL)

             ENDPGM
