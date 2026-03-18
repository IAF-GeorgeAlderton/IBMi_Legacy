/* TCHK3 */  PGM        PARM(&PSIRE &SELEC &RYYYY &RMMMM &RDDDD +
                             &SYYYY &SMMMM &SDDDD &PGRP &PBIN#)
             /** AB#C2G **********************************/
             /*       ..EDI FORD FRS ORDER PROCESSING..  */
             /*  TCH 2000.05.10                          */
             /*  TCH 2000.10.25                          */
             /*                                          */
             /* T.SAKAKI 05/06/15 AB#R21 OUTQ CHANGE  %0001 */
             /* T.SAKAKI 09/16/16 CHG OVRPRTF         %0002 */
             /*                   ADD NOTIFICATION    %0003 */
             /********************************** AB#C2G **/
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&SR)      TYPE(*CHAR) LEN(2)
             DCL        VAR(&PSIRK)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&MBAN)    TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRT)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&PFLG)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&FILE1)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE2)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE3)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE4)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE5)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE6)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&PSIRE)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&SELEC)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&RYYYY)   TYPE(*DEC)  LEN(4 0)
             DCL        VAR(&RMMMM)   TYPE(*DEC)  LEN(2 0)
             DCL        VAR(&RDDDD)   TYPE(*DEC)  LEN(2 0)
             DCL        VAR(&SYYYY)   TYPE(*DEC)  LEN(4 0)
             DCL        VAR(&SMMMM)   TYPE(*DEC)  LEN(2 0)
             DCL        VAR(&SDDDD)   TYPE(*DEC)  LEN(2 0)
/* TCHK2 */  DCL        VAR(&PGRP)    TYPE(*CHAR) LEN(1)
/* TCHK3 */  DCL        VAR(&PBIN#)   TYPE(*DEC)  LEN(2 0)
             DCL        VAR(&WLIB)    TYPE(*CHAR) LEN(8)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHGVAR     VAR(&WLIB) VALUE('TFILE1')

             CHGJOB     SWS(00000000)

/* %0002 TEST USER USES EPRINT9 */
             CHGVAR     VAR(&PRTG) VALUE('EPRINT1   ')
             IF         COND(&USER *EQ 'TEST') THEN(DO)
             CHGVAR     VAR(&PRTG) VALUE('EPRINT9   ')
                        ENDDO

             CHGVAR     VAR(&SR) VALUE('FD')
             CHGVAR     VAR(&FILE1) VALUE(AB#WP201 *CAT &SR)
             CHGVAR     VAR(&FILE2) VALUE(AB#WP202 *CAT &SR)
             CHGVAR     VAR(&FILE3) VALUE(AB#WP20 *CAT &SR)
             CHGVAR     VAR(&FILE4)  VALUE('MITANKF' *CAT &SR)
             CHGVAR     VAR(&FILE5) VALUE(AB#WP451 *CAT &SR)
             CHGVAR     VAR(&FILE6) VALUE(AB#WP452 *CAT &SR)

     /*JW*/  DLTF       FILE(&WLIB/&FILE5)

             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE5) RCDLEN(256) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AB#WP451) TOFILE(&FILE5)

             CLRPFM     FILE(TWFILE1/ABWP451)

/* CREATE FRS           */
             IF         COND(&SELEC *EQ '6') THEN(DO)
             CLRPFM     FILE(TWFILE1/ABWP451 )
             CLRPFM     FILE(TFILE1/AB#PP2W  )
             CLRPFM     FILE(TFILE1/ABF3P01  )
             OVRDBF     FILE(ABWP451  ) TOFILE(TWFILE1/ABWP451 )
             OVRDBF     FILE(AB#PP2W  ) TOFILE(TFILE1/AB#PP2W  )
             OVRDBF     FILE(ABF3P01  ) TOFILE(TFILE1/ABF3P01  )
             OVRPRTF    FILE(QPRINT) OUTQ(&PRTG) HOLD(*YES)
             CALL       PGM(AB#RF7FP) PARM(&RYYYY &RMMMM &RDDDD +
                          &SYYYY &SMMMM &SDDDD &PSIRE &PGRP &PBIN#)
             ENDDO

/* RE-CREATE FRS(NIRVANA) */
/* TCHK3 */  IF         COND(&SELEC *EQ '7') THEN(DO)
             OVRPRTF    FILE(QPRINT) HOLD(*YES)
             OVRPRTF    FILE(QPRINT2) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1) HOLD(*YES) +
                          IGCDTA(&PIGCD) /* %0002 */
             CALL       PGM(AB#RFMP) PARM(&RYYYY &RMMMM &RDDDD &SYYYY +
                          &SMMMM &SDDDD &PSIRE &PGRP &PBIN#)
                         GOTO ENDP
             ENDDO

/************************************/
/*  TEMP STOP                       */
/***********************************/

             DLTOVR     FILE(*ALL)

 ENDP:       ENDPGM
