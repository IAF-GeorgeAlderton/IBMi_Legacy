/** ALGC40 ************************************************/
/*  Pull OQ Scans from SQL server - TVAPP05, TVAPP06.     */
/*       Write to ALGPP01, ALGPP11.                       */
/*       Update the Status in TVAPP05.                    */
/*                                                        */
/* LEC  2023/02/20 - Create                               */
/**********************************************************/

             PGM

             DCL        VAR(&NUMRCD) TYPE(*DEC) LEN(10 0)


/*************************************************************************/
             CLRPFM     FILE(RDBWP41)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(RDBWP42)
             MONMSG     MSGID(CPF0000)

/*************************************************************************/
/*  pull OQ records from SQL server with Status = '1' (Ready)            */
             CALL       PGM(RDBR41)

             CPYF       FROMFILE(RDBWP42) TOFILE(SHIBATA/RDBWP42) +
                          MBROPT(*ADD) CRTFILE(*YES) FMTOPT(*NOCHK)

             RTVMBRD    FILE(RDBWP41) NBRCURRCD(&NUMRCD)

/*************************************************************************/
/*  write OQ records from SQL server to ALGPP01 and ALGPP11...           */
             RTVMBRD    FILE(RDBWP41) NBRCURRCD(&NUMRCD)

             IF         COND(&NUMRCD > 0) +
                        THEN(DO)

                         CALL       PGM(ALGR40)

/*************************************************************************/
/*  update the record status in TVAPP05, 06  Status = '2' (Uploaded)...  */
                         CALL       PGM(RDBR42)

                        ENDDO

/*************************************************************************/


             ENDPGM
