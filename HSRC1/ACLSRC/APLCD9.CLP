             PGM        PARM(&GET &AB951W0)

             DCL        VAR(&GET) TYPE(*CHAR) LEN(256)
             DCL        VAR(&SYS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&HOST) TYPE(*CHAR) LEN(30)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&LIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SRCL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AB951W0) TYPE(*CHAR) LEN(10)

             RTVNETA    SYSNAME(&SYS)
             RTVJOBA    JOB(&WSID)
             CHGVAR     VAR(&WT) VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&AB951W0) VALUE('AB951W0' *CAT &WT)

          /*システム名称をドメイン付きに変更*/
             IF         COND(&SYS *EQ 'AOYAMA') THEN(DO)
             CHGVAR     VAR(&HOST) VALUE('AOYAMA.ASJ-FASTENERS.CO.JP')
             CHGVAR     VAR(&LIBL) VALUE('ASJWFILE')
             CHGVAR     VAR(&SRCL) VALUE('ASJSRC')
             ENDDO
             IF         COND(&SYS *EQ 'IAFAYM') THEN(DO)
             CHGVAR     VAR(&HOST) VALUE('IAFAYM.ASJ-FASTENERS.CO.JP')
             CHGVAR     VAR(&LIBL) VALUE('ASJWFILE')
             CHGVAR     VAR(&SRCL) VALUE('ASJSRC')
             ENDDO
             IF         COND(&SYS *EQ 'IAF') THEN(DO)
             CHGVAR     VAR(&HOST) VALUE('IAF.ASJ-FASTENERS.CO.JP')
             CHGVAR     VAR(&LIBL) VALUE('HWFILE1')
             CHGVAR     VAR(&SRCL) VALUE('HSRC1')
             ENDDO
             IF         COND(&SYS *EQ 'ATC') THEN(DO)
             CHGVAR     VAR(&HOST) VALUE('ATC.ASJ-FASTENERS.CO.JP')
             CHGVAR     VAR(&LIBL) VALUE('ATCWFILE')
             CHGVAR     VAR(&SRCL) VALUE('ATCSRC')
             ENDDO
             IF         COND(&SYS *EQ 'ACZ') THEN(DO)
             CHGVAR     VAR(&HOST) VALUE('ACZ.ASJ-FASTENERS.CO.JP')
             CHGVAR     VAR(&LIBL) VALUE('ACZWFILE')
             CHGVAR     VAR(&SRCL) VALUE('ACZSRC')
             ENDDO
             IF         COND(&SYS *EQ 'AFS') THEN(DO)
             CHGVAR     VAR(&HOST) VALUE('AFS.ASJ-FASTENERS.CO.JP')
             CHGVAR     VAR(&LIBL) VALUE('AFSWFILE')
             CHGVAR     VAR(&SRCL) VALUE('AFSSRC')
             ENDDO
             IF         COND(&SYS *EQ 'AFD') THEN(DO)
             CHGVAR     VAR(&HOST) VALUE('AFD.ASJ-FASTENERS.CO.JP')
             CHGVAR     VAR(&LIBL) VALUE('AFDWFILE')
             CHGVAR     VAR(&SRCL) VALUE('AFDSRC')
             ENDDO
             IF         COND(&SYS *EQ 'ASI') THEN(DO)
             CHGVAR     VAR(&HOST) VALUE('ASI.ASJ-FASTENERS.CO.JP')
             CHGVAR     VAR(&LIBL) VALUE('ASIWFILE')
             CHGVAR     VAR(&SRCL) VALUE('ASISRC')
             ENDDO
             IF         COND(&SYS *EQ 'CKJ') THEN(DO)
             CHGVAR     VAR(&HOST) VALUE('CKJ.ASJ-FASTENERS.CO.JP')
             ENDDO
             IF         COND(&SYS *EQ 'SNF') THEN(DO)
             CHGVAR     VAR(&HOST) VALUE('SNF.ASJ-FASTENERS.CO.JP')
             ENDDO

             DLTF       FILE(&LIBL/&AB951W0)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&LIBL/&AB951W0) SRCFILE(&SRCL/ADDSSRC) +
                          SRCMBR(AB951W0) OPTION(*NOLIST *NOSRC) +
                          SIZE(5000 1000) LVLCHK(*NO) AUT(*ALL)

             STRPCO     PCTA(*NO)
             MONMSG     MSGID(CPF0000)
             STRPCCMD   PCCMD('C:/AS400/TTO/ANYFTFR2.BAT' *BCAT &HOST +
                          *BCAT &LIBL *BCAT &AB951W0 *BCAT &GET) PAUSE(*NO)

             ENDPGM
