             PGM        PARM(&PSIRE)
/** AB#C2F ************************************************/
/*  TAKUMI ORDER PROCESSING                               */
/*  ORDER/FORECAST UPLOAD PROCESS              2006.02.09 */
/*  (THIS PROGRAM IS CALLED BY AB#R2Z)                    */
/*                                                        */
/*  TCHK1 10/29/09 RE-MAKE                                */
/*  TCHK2 12/11/09 RMV OHASHI FORECAST PROCESS            */
/*  TCHK3 05/20/10 ADD TIEM ORDER PROCESS                 */
/*  TCHK4 05/28/10 ADD TAKUMI CANADA ORDER PROCESS        */
/*  TCHK5 10/26/12 ADD ACZ ORDER PROCESS                  */
/*  TCHK6 08/29/13 CHG PRINT SETTING                      */
/*  TCHK7 11/12/13 ADD ARJ ORDER PROCESS                  */
/*  TCHK8 06/18/14 CHG NIFAST(MI) FORECAST PROCESS        */
/*  TCHK9 07/22/14 ADD ADI ORDER/FORECAST PROCESS         */
/*  JW1   05/31/17 SAVE TAKUMITX TO TAKUMITX@             */
/*  JW2   06/19/17 ADD OVRDBF TO CALENDAR FILE            */
/*  JW3   02/01/18 ADD A#R0556U FOR FUTABA CHICAGO        */
/*  JW3            ADD A#R0579U FOR FUTABA CANADA         */
/*  JW4   05/22/18 ADD CPYF COMMAND                       */
/*  JW5   04/20/23 ACCEPT PMO'S 2 BUILDINGS FC/FIRM       */
/**********************************************************/
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&SR)     TYPE(*CHAR) LEN(2)
             DCL        VAR(&MBAN)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PFLG)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&FILE1)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE2)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE3)  TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE4)  TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE5)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE6)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&PSIRE)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&SIREF)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&PID)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&ID)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&PFG)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&PTN)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&PYM)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&ABADS1) TYPE(*CHAR) LEN(48)
             DCL        VAR(&REC)    TYPE(*DEC)  LEN(10 0)
             DCL        VAR(&USER2) TYPE(*CHAR) LEN(10)

 /*JW5*/     DCL        VAR(&MSG1 ) TYPE(*CHAR) LEN(30) VALUE(' ')
             DCL        VAR(&MSG2 ) TYPE(*CHAR) LEN(30) VALUE(' ')

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&PRTG) VALUE('LANPRT50  ')
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHGJOB     SWS(00000000)

/* PMO ************************************************************/
             IF         COND(&PSIRE *EQ '0681') THEN(DO)
             CHGVAR     VAR(&SR) VALUE('PM')
        /**  CHKOBJ     OBJ(PMO)  OBJTYPE(*FILE)                 **/
        /**  MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(@SKP1))  **/

             OVRDBF     FILE(AB#WPMO) TOFILE(&WLIB/AB#WPMO)
             CLRPFM     FILE(AB#WPMO)
             OVRDBF     FILE(PMO)     TOFILE(&WLIB/PMO)

   /*JW5 *** CALL       PGM(A#R0681O)  PARM(&PID) **************/
   /*JW5*    CALL       PGM(A#R0681O2) PARM(&PID) *************/

             CHGVAR     VAR(&PID) VALUE('3')

             IF         COND(&PID *EQ '2') THEN(GOTO PMOX)
             IF         COND(&PID *EQ '3') THEN(GOTO PMOX)

             OVRDBF     FILE(ABAWPMF) TOFILE(&WLIB/ABAWPMF)
             CLRPFM     FILE(ABAWPMF)
   /*JW5 *** CALL       PGM(A#R0681F)  PARM(&ID)   **************/
   /*JW5     CALL       PGM(A#R0681F2) PARM(&ID)   ***/

             IF         COND(&ID *EQ '2') THEN(GOTO PMOX)
             IF         COND(&ID *EQ '3') THEN(GOTO PMOX)


 /** PMO ERROR MSG1 **/
 PMOX:
             IF         COND((&ID *EQ '2') *OR (&PID *EQ '2')) +
                          THEN(DO) /*JW5*/
              CHGVAR VAR(&MSG1) VALUE('"PM01" OR "PM02" NOT FOUND!   ')
              CALL       PGM(UTLC96 ) PARM(&MSG1 &MSG2)
              ENDDO

 /** PMO ERROR MSG2 **/
             IF         COND((&ID *EQ '3') *OR (&PID *EQ '3')) +
                          THEN(DO) /*JW5*/
              CHGVAR VAR(&MSG1) VALUE('"PM01" AND "PM02" BOTH FOUND! ')
              CALL       PGM(UTLC96 ) PARM(&MSG1 &MSG2)
                         GOTO @END
              ENDDO

              ENDDO

  @END:
             DLTOVR     FILE(*ALL)
             ENDPGM
