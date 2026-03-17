             PGM        PARM(&WKCD &USR)
             /** ALDC03 **********************************/
             /* MATCHING SHIPPING SYSTEM IN IAF(3-POINT) */
             /* TCH(N.HYOTO)       06/16/00              */
             /* MENBER = M + JOB LAST2 + WORKER          */
             /*                                          */
             /* TCH(N.HYOTO)       06/20/00              */
             /* MENBER = M + JOB LAST2                   */
             /*                                          */
             /********************************************/
             DCL        VAR(&WKCD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&JOB2) TYPE(*CHAR) LEN(2)
             DCL        VAR(&JOB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBR)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USR)  TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&JOB)

/* CREATE MENBER NAME */
             CHGVAR     VAR(&JOB2) VALUE(%SUBSTRING(&JOB 9 2))
/*           CHGVAR     VAR(&MBR)  VALUE('M' *CAT &JOB2 *CAT &WKCD) */
             CHGVAR     VAR(&MBR)  VALUE('M' *CAT &JOB2)

   /*        ADDPFM     FILE(HWFILE1/ALDWP11) MBR(&MBR) */
   /*        MONMSG     MSGID(CPF0000)                  */

   /*        CPYF       FROMFILE(HWFILE1/ALDWP11) +
                          TOFILE(HWFILE1/ALDWP10) FROMMBR(&MBR) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)   */
  /*         MONMSG     MSGID(CPF0000) */

      /*     CLRPFM     FILE(HWFILE1/ALDWP11) MBR(&MBR)  */
       /*    MONMSG     MSGID(CPF0000)  */

       /*    OVRDBF     FILE(ALDWP10) TOFILE(HWFILE1/ALDWP11) MBR(&MBR) */
       /*    MONMSG     MSGID(CPF0000)  */

             CALL       PGM(ALDR02) PARM(&WKCD &USR)

       /*    DLTOVR     FILE(*ALL)  */
       /*    MONMSG     MSGID(CPF0000) */

      /*     CPYF       FROMFILE(HWFILE1/ALDWP11) +
                          TOFILE(HWFILE1/ALDWP10) FROMMBR(&MBR) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)     */
       /*    MONMSG     MSGID(CPF0000)    */

        /*   CLRPFM     FILE(HWFILE1/ALDWP11) MBR(&MBR)    */
        /*   MONMSG     MSGID(CPF0000)                    */

             ENDPGM
