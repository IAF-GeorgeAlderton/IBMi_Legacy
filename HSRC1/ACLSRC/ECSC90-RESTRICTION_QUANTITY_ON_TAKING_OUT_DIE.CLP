             PGM
            /** ECSC90 **********************************************/
            /*  RESTRICTION QUANTITY ON TAKING OUT DIE              */
            /*          2017.09.12  ITS.  T.MITSUI                  */
            /********************************************************/
             DCL        VAR(&WSID)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRNT)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&DEVT)     TYPE(*CHAR) LEN(6)
             DCL        VAR(&IGCD)     TYPE(*CHAR) LEN(4)
             DCL        VAR(&WS3)      TYPE(*CHAR) LEN(3)


 #STEP01:   /*======================================================*/
            /*   INITIALAIZE                                        */
            /*======================================================*/
             RTVJOBA    JOB(&WSID)     USER(&USER)
             CALL       PGM(AGAR01)    PARM(&WSID &DEVT &IGCD)
             CALL       PGM(AGAR00)    PARM(&WSID &PRNT &TYPE &PRTG)

             CHGVAR     VAR(&WS3)     VALUE(%SST(&WSID 1 3))


 #STEP02:   /*======================================================*/
            /*   RESTRICTION QUANTITY ON TAKING OUT DIE             */
            /*======================================================*/
             CALL       PGM(ECSR90)


 #STEP99:   /*======================================================*/
            /*  END                                                 */
            /*======================================================*/
             ENDPGM

