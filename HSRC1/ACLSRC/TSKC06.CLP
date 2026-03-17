PGM
             DCL        VAR(&PGM) TYPE(*CHAR) LEN(6) VALUE('AJSC10')
             DCL        VAR(&PGM1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM2) TYPE(*CHAR) LEN(10)
             CHGVAR     VAR(&PGM1) VALUE(&PGM *CAT '1')
             CHGVAR     VAR(&PGM2) VALUE(&PGM *CAT '2')

             RTVCLSRC   PGM(HOBJ1/&PGM) SRCFILE(SAKASITA/QCLSRC2) +
                          SRCMBR(&PGM1)

             CRTCLPGM   PGM(SAKASITA/&PGM) SRCFILE(HSRC1/ACLSRC) +
                          SRCMBR(&PGM)
             RTVCLSRC   PGM(SAKASITA/&PGM) SRCFILE(SAKASITA/QCLSRC2) +
                          SRCMBR(&PGM2)

             CMPPFM     NEWFILE(SAKASITA/QCLSRC2) NEWMBR(&PGM1) +
                          OLDFILE(SAKASITA/QCLSRC2) OLDMBR(&PGM2)

ENDPGM
