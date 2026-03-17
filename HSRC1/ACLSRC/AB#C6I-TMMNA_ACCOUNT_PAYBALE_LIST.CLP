/* TCHK2     PGM        PARM(&CUST &PDAT &PSLT) */
/* TCHK2 */  PGM        PARM(&CUST &PDAT &PTIM &PSLT)
             /** AB#C6H ************************/
             /*  ..TMMNA ACCOUNT PAYBALE LIST  */
             /*                                */
             /* TCHK1 03/03/09 CHG PARM        */
             /* TCHK2 09/10/14 CHG PARM        */
             /************************ AB#C6G **/
/* TCHK1     DCL        VAR(&CUST) TYPE(*CHAR) LEN(2) */
/* TCHK1 */  DCL        VAR(&CUST) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PDAT)  TYPE(*DEC) LEN(8 0)
/* TCHK2 */  DCL        VAR(&PTIM)  TYPE(*DEC) LEN(6 0)
             DCL        VAR(&PSLT) TYPE(*CHAR) LEN(1)

             CLRPFM     FILE(AB#PP6B)
             CLRPFM     FILE(AB#PP6C)
/* TCHK2     CALL       PGM(AB#R6I) PARM(&CUST &PDAT &PSLT) */
/* TCHK2 */  CALL       PGM(AB#R6I) PARM(&CUST &PDAT &PTIM &PSLT)

             ENDPGM
