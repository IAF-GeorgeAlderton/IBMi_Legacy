             PGM        PARM(&SLC)
             /** ABACP4 ******************************************/
             /*PRODUCT DEMAND FORECAST                           */
             /*   BE ABLE TO SELECT MULTIPLE CUSTOMERS AT A TIME.*/
             /*  TCH71 04/15/05  RITATSU                         */
             /*  TCH72 05/31/05  TMI                             */
             /*  TCH73 07/19/05  TAKATA                          */
             /*  TCHK  09/12/05  TAKATA MULTI NONY               */
             /*  TCHK1 10/05/05  RITATSU CHANGE                  */
             /*  TCHK2 02/09/06  ADD FORECAST ABNORMAL LIST      */
             /*  TCHK3 02/09/06  RITATSU COMMENT                 */
             /*  TCHK4 05/04/06  RMV FORECAST ABNORMAL LIST      */
             /*  TCHK5 08/11/06  CHG PROCESS CONTROL             */
             /*  TCHK6 10/04/06  ADD FUTABA TEXAS                */
             /*  TCHK7 10/12/06  ADD JTEKT TEXAS                 */
             /*  TCHK8 11/14/06  ADD FUTABA INDIANA              */
             /*  TCHK9 12/10/07  ADD JTEKT VIRGINIA              */
             /*  TCHKA 01/31/08  ADD FUTABA CANADA               */
             /*  TCHKB 09/04/08  RMV AISIN SEYMORE               */
             /*  TCHKC 10/27/08  ADD TBCA                        */
             /*  TCHKD 04/07/11  ADD FUTABA CHICAGO              */
             /*                  CHG QPRINTB --> QDKT            */
             /*  TCHKE 02/13/14  ADD PRICE CHECK LIST            */
             /*  JW1   2021.02.18 CHG AB#R0D --> AB#R0D2         */
             /******************************** ABACP1 ************/
             DCL        VAR(&ABADS1) TYPE(*CHAR) LEN(48)
             DCL        VAR(&ABBDS1) TYPE(*CHAR) LEN(54)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&BHIZ)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&PYMD)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&WYMD)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&PDEVT)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&WS)     TYPE(*CHAR) LEN(2)
             DCL        VAR(&REC1)    TYPE(*DEC)  LEN(10 0)
             DCL        VAR(&USR)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&FLAG)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&ANO)   TYPE(*CHAR) LEN(2)
/* TCHK5 */  DCL        VAR(&SLC)   TYPE(*CHAR) LEN(04)
             DCL        VAR(&AYM)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&TOKU)   TYPE(*DEC) LEN(4 0)
             DCL        VAR(&NONY)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&PSIGO) TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&ID) TYPE(*CHAR) LEN(1)
 /* TCHK */  DCL        VAR(&ID1) TYPE(*CHAR) LEN(1)
 /* TCHK */  DCL        VAR(&ID2) TYPE(*CHAR) LEN(1)
 /* TCHK */  DCL        VAR(&ID3) TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USR)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(ALBC00) PARM(&USR  &WLIB)

             RTVDTAARA  DTAARA(ABADS1) RTNVAR(&ABADS1)
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&PYMD)

             CHGVAR     VAR(&BHIZ) VALUE(%SST(&ABADS1 1 6))

             CHGVAR     VAR(%SST(&WYMD 3 6)) VALUE(&PYMD)
             CHGVAR     VAR(%SST(&WYMD 1 2)) VALUE('20')

             CHGVAR     VAR(&AYM) VALUE(%SST(&WYMD 1 6))

             CALL       PGM(ABAR01) PARM(&AYM)

             IF         ((%SST(&ABADS1 1 6)) *GT &AYM) GOTO SAP1
             IF         (%SST(&ABADS1 1 6) *EQ &AYM) GOTO SAP1

             CHGVAR     VAR(%SST(&ABADS1 7 42)) +
                          VALUE('000000000000000000000000000000000000+
                          000000')
             CHGDTAARA  DTAARA(ABADS1) VALUE(&ABADS1)

             CHGVAR     VAR(%SST(&ABBDS1 27 1)) VALUE(' ')
             CHGDTAARA  DTAARA(ABBDS1) VALUE(&ABBDS1)

 SAP1:
             /*----------------------------*/
             /*  ATS                    .  */
             /*----------------------------*/

/* TCHK5 */  IF         COND(&SLC *EQ '3530') THEN(DO)
             CHKOBJ     OBJ(ATSFCST) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(@END))

             OVRPRTF    FILE(QPRINT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(QDKT) +
                          FORMTYPE(K6H1)
             OVRPRTF    FILE(QPRINT2) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(FORECAST) +
                          FORMTYPE(K6H1) HOLD(*YES)

             CALL       PGM(ABAR1O)
             CHGVAR     VAR(&NONY) VALUE('3530')
             DLTF ATSFCST
             MONMSG     MSGID(CPF0000)

             ENDDO

             /*----------------------------*/
             /*  AISIN                  .  */
             /*----------------------------*/

/* TCHK5     IF         COND(%SST(&SLC 17 1) *EQ '1') THEN(DO) */
/* TCHKB     IF         COND(&SLC *EQ '0966') THEN(DO)               */
/* TCHKB     CHKOBJ     OBJ(AISINFC) OBJTYPE(*FILE)                  */
/* TCHKB     MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(@END))       */
/* TCHKB                                                             */
/* TCHKB     CLRPFM     FILE(ABAWAIF)                                */
/* TCHKB     CALL       PGM(AB#R27) PARM(&ID)                        */
/* TCHKB     IF         COND(&ID *EQ ' ') THEN(GOTO CMDLBL(@END))    */
/* TCHK2 */ /* TCHK4 OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) + */
/* TCHK2 */ /* TCHK4              OUTQ(QPRINT) FORMTYPE(K6H1)        */
/* TCHK2 */ /* TCHK4 CALL       PGM(ABAR1ZD)                         */
/* TCHK2 */ /* TCHK4 DLTOVR     FILE(QPRINT)                         */
/* TCHKB                                                             */
/* TCHKB     OVRPRTF    FILE(QPRINT) LPI(6) +                        */
/* TCHKB                  RPLUNPRT(*YES) OUTQ(QPRINTB) +             */
/* TCHKB                  FORMTYPE(K6H1)                             */
/* TCHKB     OVRPRTF    FILE(QPRINT2) LPI(6) +                       */
/* TCHKB                  RPLUNPRT(*YES) OUTQ(FORECAST) +            */
/* TCHKB                  FORMTYPE(K6H1) HOLD(*YES)                  */
/* TCHKB                                                             */
/* TCHKB                                                             */
/* TCHKB     CALL       PGM(ABAR1S)                                  */
/* TCHKB                                                             */
/* TCHKB     CHGVAR     VAR(&NONY) VALUE('0966')                     */
/* TCHKB     DLTF AISINFC                                            */
/* TCHKB     MONMSG     MSGID(CPF0000)                               */
/* TCHKB                                                             */
/* TCHKB     ENDDO                                                   */


             /*----------------------------*/
  /*TCH71 */ /*  RITATSU                .  */
             /*----------------------------*/

/* TCHK5     IF         COND(%SST(&SLC 18 1) *EQ '1') THEN(DO)    */
/* TCHK3     CHKOBJ     OBJ(RITATSUF) OBJTYPE(*FILE)              */
/* TCHK3     MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(@END))    */
/* TCHK3                                                          */
/* TCHK3     CLRPFM     FILE(ABAWRIF)                             */
/* TCHK3     CALL       PGM(AB#R5D) PARM(&ID)                     */
/* TCHK3     IF         COND(&ID *EQ ' ') THEN(GOTO CMDLBL(@END)) */
/* TCHK3                                                          */
/* TCHK3     OVRPRTF    FILE(QPRINT) LPI(6) +                     */
/* TCHK3                  RPLUNPRT(*YES) OUTQ(QPRINTB) +          */
/* TCHK3                  FORMTYPE(K6H1)                          */
/* TCHK3     OVRPRTF    FILE(QPRINT2) LPI(6) +                    */
/* TCHK3                  RPLUNPRT(*YES) OUTQ(FORECAST) +         */
/* TCHK3                  FORMTYPE(K6H1) HOLD(*YES)               */
/* TCHK3                                                          */
/* TCHK3                                                          */
/* TCHK3     CALL       PGM(ABAR1U)                               */
/* TCHK3                                                          */
/* TCHK3     CHGVAR     VAR(&NONY) VALUE('1301')                  */
 /* TCHK1    DLTF RITATSUF */
/* TCHK3     MONMSG     MSGID(CPF0000)                            */
/* TCHK3 */
/* TCHK3 */  /* TCHK5 GOTO @END */
/* TCHK3 */
 /*TCH71 */  /* TCHK5 ENDDO     */

             /*----------------------------*/
  /*TCH72 */ /*  TMI                    .  */
             /*----------------------------*/

/* TCHK5 */  IF         COND(&SLC *EQ '3540') THEN(DO)
             CHKOBJ     OBJ(TMIF)     OBJTYPE(*FILE)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(@END))

             CLRPFM     FILE(ABAWTMF)
             CALL       PGM(AB#R5E) PARM(&ID)
             IF         COND(&ID *EQ ' ') THEN(GOTO CMDLBL(@END))

             OVRPRTF    FILE(QPRINT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(QDKT) +
                          FORMTYPE(K6H1)
             OVRPRTF    FILE(QPRINT2) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(FORECAST) +
                          FORMTYPE(K6H1) HOLD(*YES)


             CALL       PGM(ABAR1V)

             CHGVAR     VAR(&NONY) VALUE('3540')
             DLTF TMIF
             MONMSG     MSGID(CPF0000)

 /*TCH72 */  ENDDO


 /* TCHK *** CHKOBJ     OBJ(TAKATAF)  OBJTYPE(*FILE)              */
 /* TCHK *** MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(@END))    */
 /* TCHK ***                                                      */
 /* TCHK *** CLRPFM     FILE(ABAWTKF)                             */
 /* TCHK *** CALL       PGM(AB#R5F) PARM(&ID)                     */
 /* TCHK *** IF         COND(&ID *EQ ' ') THEN(GOTO CMDLBL(@END)) */
 /* TCHK ***                                                      */
 /* TCHK *** OVRPRTF    FILE(QPRINT) LPI(6) +                     */
 /* TCHK ***              RPLUNPRT(*YES) OUTQ(QPRINTB) +          */
 /* TCHK ***              FORMTYPE(K6H1)                          */
 /* TCHK *** OVRPRTF    FILE(QPRINT2) LPI(6) +                    */
 /* TCHK ***              RPLUNPRT(*YES) OUTQ(FORECAST) +         */
 /* TCHK ***              FORMTYPE(K6H1) HOLD(*YES)               */
 /* TCHK ***                                                      */
 /* TCHK ***                                                      */
 /* TCHK *** CALL       PGM(ABAR1W)                               */
 /* TCHK ***                                                      */
 /* TCHK *** CHGVAR     VAR(&NONY) VALUE('3712')                  */
 /* TCHK *** DLTF TAKATAF                                         */
 /* TCHK *** MONMSG     MSGID(CPF0000)                            */

             /*----------------------------*/
             /*  TAKATA : 3712          .  */
             /*----------------------------*/

             IF         COND(&SLC *EQ '3712') THEN(DO)

             CHGVAR     VAR(&ID1) VALUE(' ')
             CHGVAR     VAR(&ID2) VALUE(' ')
             CHGVAR     VAR(&ID3) VALUE(' ')
             CLRPFM     FILE(ABAWTKF)

             CHKOBJ     OBJ(TAKATAFAZ) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(@TKT2))

 /* 1. TAKATAFAZ: 3682 */
             OVRDBF     FILE(TAKATAF)  TOFILE(TAKATAFAZ)
             CALL       PGM(AB#R5F) PARM(&ID1 '1')

             IF         COND(&ID1 *EQ ' ') THEN(GOTO CMDLBL(@TKT2))
             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(QPRINT) FORMTYPE(K6H1) /* TCHK */
             OVRPRTF    FILE(QPRINT2) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(FORECAST) +
                          FORMTYPE(K6H1) HOLD(*YES)
             CALL       PGM(ABAR1W)
             DLTOVR     FILE(*ALL)
             CPYF       FROMFILE(HWFILE1/TAKATAFAZ) +
                          TOFILE(HWFILE1/TAKATAFAZS) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)
             CLRPFM     TAKATAFAZ
             MONMSG     MSGID(CPF0000)

 @TKT2:
             CHKOBJ     OBJ(TAKATAFMX) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(@TKT3))

 /* 2. TAKATAFMX: 3712 */
             OVRDBF     FILE(TAKATAF)  TOFILE(TAKATAFMX)
             CALL       PGM(AB#R5F) PARM(&ID2 '2')
             IF         COND(&ID2 *EQ ' ') THEN(GOTO CMDLBL(@TKT3))
             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(QPRINT) FORMTYPE(K6H1) /* TCHK */
             OVRPRTF    FILE(QPRINT2) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(FORECAST) +
                          FORMTYPE(K6H1) HOLD(*YES)
             CALL       PGM(ABAR1W)
             DLTOVR     FILE(*ALL)
             CPYF       FROMFILE(HWFILE1/TAKATAFMX) +
                          TOFILE(HWFILE1/TAKATAFMXS) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)
             CLRPFM     TAKATAFMX
             MONMSG     MSGID(CPF0000)

 @TKT3:
             CHKOBJ     OBJ(TAKATAFDR) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(@TKT4))

 /* 3. TAKATAFMC: 3714 */
             OVRDBF     FILE(TAKATAF)  TOFILE(TAKATAFMC)
             CALL       PGM(AB#R5F) PARM(&ID2 '3')
             IF         COND(&ID2 *EQ ' ') THEN(GOTO CMDLBL(@TKT4))
             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(QPRINT) FORMTYPE(K6H1) /* TCHK */
             OVRPRTF    FILE(QPRINT2) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(FORECAST) +
                          FORMTYPE(K6H1) HOLD(*YES)
             CALL       PGM(ABAR1W)
             DLTOVR     FILE(*ALL)
             CPYF       FROMFILE(HWFILE1/TAKATAFMC) +
                          TOFILE(HWFILE1/TAKATAFMCS) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)
             CLRPFM     TAKATAFMC
             MONMSG     MSGID(CPF0000)

 @TKT4:
             CHKOBJ     OBJ(TAKATAFDR) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(@TKTE))

 /* 4. TAKATAFDR: 3842 */
             OVRDBF     FILE(TAKATAF)  TOFILE(TAKATAFDR)
             CALL       PGM(AB#R5F) PARM(&ID3 '4')

             IF         COND(&ID3 *EQ ' ') THEN(GOTO CMDLBL(@TKTE))
             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(QPRINT) FORMTYPE(K6H1) /* TCHK */
             OVRPRTF    FILE(QPRINT2) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(FORECAST) +
                          FORMTYPE(K6H1) HOLD(*YES)
             CALL       PGM(ABAR1W)
             DLTOVR     FILE(*ALL)
             CPYF       FROMFILE(HWFILE1/TAKATAFDR) +
                          TOFILE(HWFILE1/TAKATAFDRS) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)
             CLRPFM     TAKATAFDR
             MONMSG     MSGID(CPF0000)

             @TKTE:
             IF         COND(&ID1 *EQ ' ' *AND +
                             &ID2 *EQ ' ' *AND +
                             &ID3 *EQ ' ') THEN(GOTO CMDLBL(@END))

             CHGVAR     VAR(&NONY) VALUE('3712')

             ENDDO

             /*----------------------------*/
             /*  FUTABA TEXAS              */
             /*----------------------------*/

             IF         COND(&SLC *EQ '0578') THEN(DO)
             CHKOBJ     OBJ(FUTABTXF)  OBJTYPE(*FILE)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(@END))

             CLRPFM     FILE(ABAWFTXF)
             CALL       PGM(A#R0578F) PARM(&ID)
             IF         COND(&ID *EQ ' ') THEN(GOTO CMDLBL(@END))

             OVRPRTF    FILE(QPRINT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(QDKT) +
                          FORMTYPE(K6H1)
             OVRPRTF    FILE(QPRINT2) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(FORECAST) +
                          FORMTYPE(K6H1) HOLD(*YES)

             CALL       PGM(A#R0578G)

             CHGVAR     VAR(&NONY) VALUE('0578')

             DLTF       FUTABTXF
             MONMSG     MSGID(CPF0000)

             ENDDO
/* TCHK6 END */

/* TCHK8 STRART */
             /*----------------------------*/
             /*  FUTABA INDIANA            */
             /*----------------------------*/

             IF         COND(&SLC *EQ '0567') THEN(DO)
             CHKOBJ     OBJ(FUTABINF)  OBJTYPE(*FILE)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(@END))

             CLRPFM     FILE(ABAWFINF)
             CALL       PGM(A#R0567F) PARM(&ID)
             IF         COND(&ID *EQ ' ') THEN(GOTO CMDLBL(@END))

             OVRPRTF    FILE(QPRINT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(QDKT) +
                          FORMTYPE(K6H1)
             OVRPRTF    FILE(QPRINT2) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(FORECAST) +
                          FORMTYPE(K6H1) HOLD(*YES)

             CALL       PGM(A#R0567G)

             CHGVAR     VAR(&NONY) VALUE('0567')

             DLTF       FUTABINF
             MONMSG     MSGID(CPF0000)

             ENDDO
/* TCHK8 END */

/* TCHKA STRART */
             /*----------------------------*/
             /*  FUTABA CANADA             */
             /*----------------------------*/

             IF         COND(&SLC *EQ '0579') THEN(DO)
             CHKOBJ     OBJ(FUTABCNF)  OBJTYPE(*FILE)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(@END))

             CLRPFM     FILE(ABAWFCNF)
             CALL       PGM(A#R0579F) PARM(&ID)
             IF         COND(&ID *EQ ' ') THEN(GOTO CMDLBL(@END))

             OVRPRTF    FILE(QPRINT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(QDKT) +
                          FORMTYPE(K6H1)
             OVRPRTF    FILE(QPRINT2) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(FORECAST) +
                          FORMTYPE(K6H1) HOLD(*YES)

             CALL       PGM(A#R0579G)

             CHGVAR     VAR(&NONY) VALUE('0579')

             DLTF       FUTABCNF
             MONMSG     MSGID(CPF0000)

             ENDDO
/* TCHKA END */

/* TCHKD STRART */
             /*----------------------------*/
             /*  FUTABA CHICAGO            */
             /*----------------------------*/

             IF         COND(&SLC *EQ '0556') THEN(DO)
             CHKOBJ     OBJ(FUTABCHF)  OBJTYPE(*FILE)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(@END))

             CLRPFM     FILE(ABAWFCHF)
             CALL       PGM(A#R0556F) PARM(&ID)
             IF         COND(&ID *EQ ' ') THEN(GOTO CMDLBL(@END))

             OVRPRTF    FILE(QPRINT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(QDKT) +
                          FORMTYPE(K6H1)
             OVRPRTF    FILE(QPRINT2) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(FORECAST) +
                          FORMTYPE(K6H1) HOLD(*YES)

             CALL       PGM(A#R0556G)

             CHGVAR     VAR(&NONY) VALUE('0556')

             DLTF       FUTABCHF
             MONMSG     MSGID(CPF0000)

             ENDDO
/* TCHKA END */

/* TCHK7 STRART */
             /*----------------------------*/
             /*  JTEKT TEXAS               */
             /*----------------------------*/

             IF         COND(&SLC *EQ '3832') THEN(DO)
             CHKOBJ     OBJ(JTEKTTXF)  OBJTYPE(*FILE)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(@END))

             CLRPFM     FILE(ABAWJTXF)
             CALL       PGM(A#R3832F) PARM(&ID)
             IF         COND(&ID *EQ ' ') THEN(GOTO CMDLBL(@END))

             OVRPRTF    FILE(QPRINT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(QDKT) +
                          FORMTYPE(K6H1)
             OVRPRTF    FILE(QPRINT2) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(FORECAST) +
                          FORMTYPE(K6H1) HOLD(*YES)

             CALL       PGM(A#R3832G)

             CHGVAR     VAR(&NONY) VALUE('3832')

             DLTF       JTEKTTXF
             MONMSG     MSGID(CPF0000)

             ENDDO
/* TCHK6 END */

/* TCHK9 STRART */
             /*----------------------------*/
             /*  JTEKT VIRGINIA            */
             /*----------------------------*/

             IF         COND(&SLC *EQ '3891') THEN(DO)
             CHKOBJ     OBJ(JTEKTVAF)  OBJTYPE(*FILE)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(@END))

             CLRPFM     FILE(ABAWJVAF)
             CALL       PGM(A#R3891F) PARM(&ID)
             IF         COND(&ID *EQ ' ') THEN(GOTO CMDLBL(@END))

             OVRPRTF    FILE(QPRINT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(QDKT) +
                          FORMTYPE(K6H1)
             OVRPRTF    FILE(QPRINT2) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(FORECAST) +
                          FORMTYPE(K6H1) HOLD(*YES)

             CALL       PGM(A#R3891G)

             CHGVAR     VAR(&NONY) VALUE('3891')

             DLTF       JTEKTVAF
             MONMSG     MSGID(CPF0000)

             ENDDO
/* TCHK9 END */

/* TCHKC STRART */
             /*----------------------------*/
             /*  TBCA                      */
             /*----------------------------*/

             IF         COND(&SLC *EQ '3318') THEN(DO)
             CHKOBJ     OBJ(TBCAF)     OBJTYPE(*FILE)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(@END))

             CLRPFM     FILE(ABAW3318)
             CALL       PGM(A#R3318F) PARM(&ID)
             IF         COND(&ID *EQ ' ') THEN(GOTO CMDLBL(@END))

             OVRPRTF    FILE(QPRINT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(QDKT) +
                          FORMTYPE(K6H1)
             OVRPRTF    FILE(QPRINT2) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(FORECAST) +
                          FORMTYPE(K6H1) HOLD(*YES)

             CALL       PGM(A#R3318G)

             CHGVAR     VAR(&NONY) VALUE('3318')

             DLTF       TBCAF
             MONMSG     MSGID(CPF0000)

             ENDDO
/* TCHK9 END */


             DLTF       FILE(QTEMP/ABAWP42)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/ABAWP42) RCDLEN(300) +
                          OPTION(*NOLIST) SIZE(15000 2000) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(ABAWP42) TOFILE(QTEMP/ABAWP42)
             DLTF       FILE(QTEMP/ABAWP25)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/ABAWP25) RCDLEN(300) +
                          OPTION(*NOLIST) SIZE(15000 2000) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(ABAWP25) TOFILE(QTEMP/ABAWP25)
             CALL       PGM(ABAR1J) PARM(&NONY &AYM)
             CALL       PGM(ABAR1C)
             DLTF       FILE(QTEMP/ABAWP25)


             IF         ((%SST(&ABADS1 1 6)) *GT &AYM) GOTO STP24
             IF         (&BHIZ *EQ &AYM) GOTO STP1

             CALL       PGM(ABAR31) PARM(&AYM)
             CALL       PGM(ABBR03) PARM(&AYM)

 STP1:
             CHGVAR     VAR(&PSIGO) VALUE('1')

 STP24:      IF         ((%SST(&ABADS1 1 6)) *LE &AYM) GOTO STP25
             CHGVAR     VAR(&PSIGO) VALUE('1')
 STP25:      CHGJOB     SWS(00000000)


             /*  A.INOUE    2002.06.19  */
             DLTF       FILE(QTEMP/ABAWP72)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/ABAWP72) RCDLEN(384) +
                          OPTION(*NOLIST) SIZE(1000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)
             DLTF       FILE(QTEMP/ABAWL72)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/ABAWL72) RCDLEN(384) +
                          OPTION(*NOLIST) SIZE(1000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(QTEMP/ABAWP32)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/ABAWP32) RCDLEN(37) +
                          OPTION(*NOLIST) SIZE(20000 20000 3) +
                          LVLCHK(*NO) AUT(*ALL)
             /* 2002.06.19  */
/* TCHKE S */
             CRTDUPOBJ  OBJ(MITANKF) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     QTEMP/MITANKF
             OVRDBF     FILE(MITANKF) TOFILE(QTEMP/MITANKF)
/* TCHKE E */

             CALL       PGM(ABAR32) PARM(&PSIGO &AYM &BHIZ '4')

/* JW1 SAVE ABAWP42 */
             CPYF       FROMFILE(QTEMP/ABAWP42) +
                          TOFILE(*LIBL/ABAWP42S) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2802)
             CALL       PGM(SAVR01) PARM('4')

             DLTF       FILE(QTEMP/ABAWP42)

/* TCHKE S */
             CHGVAR     VAR(&REC1) VALUE('0')
             RTVMBRD    FILE(QTEMP/MITANKF) NBRCURRCD(&REC1)
             IF         COND(&REC1 *NE 0) THEN(DO)
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(LANPRT50) +
                          FORMTYPE(K6H1) HOLD(*NO) IGCDTA(&PIGCD)
/*JW1*/
       /**** CALL       PGM(AB#R0D) ****/
             CALL       PGM(AB#R0D2)

             ENDDO
/* TCHKE E */
             /*  A.INOUE    2002.06.19  */
             CHGVAR     VAR(&REC1) VALUE('0')
             RTVMBRD    FILE(QTEMP/ABAWP32) NBRCURRCD(&REC1)
             IF         COND(&REC1 *NE 0) THEN(DO)

             ENDDO

             DLTF       FILE(QTEMP/ABAWP32)
             /*              */
             CHGVAR     VAR(&REC1) VALUE('0')
             RTVMBRD    FILE(QTEMP/ABAWP72) NBRCURRCD(&REC1)

             IF         COND(&REC1 *NE 0) THEN(DO)
             FMTDTA     INFILE((QTEMP/ABAWP72)) +
                          OUTFILE(QTEMP/ABAWL72) SRCFILE(FMTSRC) +
                          SRCMBR(ABAS72) OPTION(*NOPRT)
             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(FORECAST) FORMTYPE(K6H1) HOLD(*YES) +
                          SAVE(*YES)
             CALL       PGM(ABAR72) PARM(&AYM)
             DLTOVR     FILE(QPRINT)

    /*       OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(QPRINT) FORMTYPE(K6H1) HOLD(*NO)  */
             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(QPRINT) FORMTYPE(K6H1) HOLD(*NO)

             CALL       PGM(ABAR72) PARM(&AYM)
             DLTOVR     FILE(QPRINT)
             ENDDO

             DLTF       FILE(QTEMP/ABAWP72)
             DLTF       FILE(QTEMP/ABAWL72)
             /*  END A.INOUE    2002.06.19  */

             /*--------------------------------------------*/
             /* ..FROM USER PRODUCT DEMAND FORECAST DATA.. */
             /* ..FORECAST DATA INPUT                      */
             /*--------------------------------------------*/
             CALL       PGM(ABBC61) PARM(&AYM)

             CHGVAR     VAR(%SST(&ABADS1 1 6)) VALUE(&AYM)
  @LOP1:
             CHGDTAARA  DTAARA(ABADS1) VALUE(&ABADS1)
             MONMSG     MSGID(CPF1063) EXEC(GOTO CMDLBL(@LOP1))

  @LOP2:
             CHGDTAARA  DTAARA(ABBDS1) VALUE(&ABBDS1)
             MONMSG     MSGID(CPF1063) EXEC(GOTO CMDLBL(@LOP2))
 @END:

             ENDPGM
