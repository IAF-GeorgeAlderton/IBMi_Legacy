             PGM        PARM(&SHIFT)
             /** AB#CAI **********************************************/
             /*  ASJ PARTS PULLED INF                                */
             /*    H.AMANO       APR/26/04                           */
             /*                                                      */
             /*  TCH66 05/27/05 DOWNLOAD VERSION                    */
             /*        COPIED FROM AB#CAI                           */
             /********************************************** AB#CAI **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&SHIFT) TYPE(*CHAR) LEN(1)

             CLRPFM     FILE(HWFILE1/AB#WPAI)
             MONMSG     MSGID(CPF0000)

             CHGJOB     SWS(XX0XXXXX)

             CALL       PGM(AB#RAN) PARM(&SHIFT)

             CRTDTAARA  DTAARA(HOBJ1/ABBR7PACT) TYPE(*CHAR) LEN(14) +
                          TEXT('ABBR7P PROCESSING')
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(HWFILE1/ABBWP7P)

             CALL       PGM(ABBR7P) PARM(&SHIFT)

             DLTDTAARA  DTAARA(HOBJ1/ABBR7PACT)
             MONMSG     MSGID(CPF0000)

             ENDPGM
