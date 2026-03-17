             PGM        PARM(&IPGM &ILIB &SFIL &SLIB &SMBR &SDATE)

   /*********************************************************************/
   /*  RETRIEVE SOURCE INFORMATION FOR RPGLE PROGRAM OBJECTS            */
   /*  LEC     2021/05/28                                               */
   /*  ===========================================================      */
   /***PARAMETER***                                                     */
   /*  IN: $IPGM  10A: PROGRAM OBJECT                                   */
   /*    : $ILIB  10A: PROGRAM OBJECT LIBRARY                           */
   /* OUT: $SFIL  10A: SOURCE PROGRAM FILE                              */
   /*    : $SLIB  10A: SOURCE LIBRARY                                   */
   /*    : $SMBR  10A: SOURCE MEMBER                                    */
   /*    : $SDATE 13A: SOURCE CHAHNGED DATE (C + YYMMDD + HHMMSS)       */
   /***SAMPLE***                                                        */
   /*  IN: CALL VVVC99 ('MBDRT8' 'HOBJ1' '' '' '' '')                   */
   /* OUT: CALL VVVC99 ('MBDRT8' 'HOBJ1' +                              */
   /*                   'MRPGSRC' 'HSRC1''MBDRT8' '1210518094959'       */
   /*********************************************************************/

       /* INPUT -  Pgm Object Name and Library             */
             DCL        VAR(&IPGM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ILIB) TYPE(*CHAR) LEN(10)

             DCL        VAR(&OBJ) TYPE(*CHAR) LEN(20)
             DCL        VAR(&USPC) TYPE(*CHAR) LEN(20)
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(8)
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(36)

       /* OUTPUT - Pgm Source File, Library and Member Name*/
             DCL        VAR(&SFIL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SMBR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SDATE) TYPE(*CHAR) LEN(13)

             CHGVAR     VAR(&OBJ) VALUE(&IPGM *CAT &ILIB)
             CHGVAR     VAR(&USPC) VALUE('RPGSRC    QTEMP     ')
             CHGVAR     VAR(&FMT)  VALUE('PGML0100')

       /* Create User Space for IBM API to use             */
             CRTUSRSPC  USRSPC(QTEMP/RPGSRC) REPLACE(*YES)

       /* IBM API Populates User Space with Source Info    */
             CALL       PGM(QBNLPGMI) PARM(&USPC &FMT &OBJ &RTN)

       /* Retrieve Source Info from User Space             */
             RTVUSRSPC  USRSPC(QTEMP/RPGSRC) STRPOS(301) LENGTH(10) +
                          RCVDTA(&SFIL)

             RTVUSRSPC  USRSPC(QTEMP/RPGSRC) STRPOS(311) LENGTH(10) +
                          RCVDTA(&SLIB)

             RTVUSRSPC  USRSPC(QTEMP/RPGSRC) STRPOS(321) LENGTH(10) +
                          RCVDTA(&SMBR)

             RTVUSRSPC  USRSPC(QTEMP/RPGSRC) STRPOS(354) LENGTH(13) +
                          RCVDTA(&SDATE)

             ENDPGM
