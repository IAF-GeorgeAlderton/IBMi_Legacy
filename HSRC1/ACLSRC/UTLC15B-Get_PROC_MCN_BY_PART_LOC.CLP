             /** UTLC15B *****************************************/
             /*  UTILITY - GET PROC/MCN BY PART/LOC              */
             /*--------------------------------------------------*/
             /*  CALLING SEQ.                                    */
             /*                    CALL 'UTLR15B'                */
             /*                    PARM           PSHIN1  5      */
             /*                    PARM           PSHIN2  5      */
             /*                    PARM           PSHIN3  2      */
             /*                    PARM           PLOC    6      */
             /*                    PARM           PPRC1   3      */
             /*                    PARM           PPRC    3      */
             /*                    PARM           PMCN1   3      */
             /*                    PARM           PMCN    3      */
             /*                    PARM           PBMN1   4      */
             /*                    PARM           PBMN    4      */
             /*                    PARM           PBNAM  10      */
             /*                    PARM           PPRCA   3      */
             /*                    PARM           PMCNA   3      */
             /*                    PARM           PBMNA   4      */
             /*                    PARM           PRTN    1      */
             /****************************************************/
             PGM        PARM(&SHN1 &SHN2 &SHN3 &LOC)

             DCL        VAR(&LOC  ) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SHN1 ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&SHN2 ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&SHN3 ) TYPE(*CHAR) LEN(2)

             DCL        VAR(&PPRC1) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PPRC ) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PMCN1) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PMCN ) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PBMN1) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PBMN ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PBNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPRCA) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PMCNA) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PBMNA) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PRTN ) TYPE(*CHAR) LEN(1)

             CALL       PGM(UTLR15B) PARM(&SHN1 &SHN2 &SHN3 &LOC +
                          &PPRC1 &PPRC  &PMCN1 &PMCN  &PBMN1 &PBMN +
                          &PBNAM &PPRCA &PMCNA &PBMNA &PRTN)
 END:        ENDPGM
