             PGM        PARM(&PART# &NONY &SHID &ODRN &NUKE &QPC &WKCD -
                             &W2D &BIN#)
             /** AM#C17H ***********************/
             /* PACKING - SHORTAGES            */
             /*   KIRI             2020.06.09  */
             /**********************************/
             DCL        VAR(&PART#) TYPE(*CHAR) LEN(12)
             DCL        VAR(&NONY ) TYPE(*DEC)  LEN(04 0)
             DCL        VAR(&SHID ) TYPE(*CHAR) LEN(08)
             DCL        VAR(&ODRN ) TYPE(*CHAR) LEN(12)
             DCL        VAR(&NUKE ) TYPE(*CHAR) LEN(04)
             DCL        VAR(&QPC  ) TYPE(*DEC ) LEN(05 0)
             DCL        VAR(&WKCD ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&W2D  ) TYPE(*CHAR) LEN(250)
             DCL        VAR(&BIN# ) TYPE(*DEC)  LEN(02 0)

             DLTF       FILE(QTEMP/ALDWP69)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/ALDWP69) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ALDWP69) OPTION(*NOLIST *NOSRC) +
                          LVLCHK(*NO) AUT(*ALL)


             OVRDBF     FILE(ALDWP69) TOFILE(QTEMP/ALDWP69)


     /* Reduce Order Qty in Order File due to Part "Short"         */

             CALL       PGM(AM#R17H) PARM(&PART# &NONY &SHID &ODRN +
                          &NUKE &QPC &WKCD &W2D &BIN#)


     /* A-PICS RECEIPT DATA ( SHIPPING SHORTAGE DATA )             */

             CALL       PGM(ALDR6H) PARM(&W2D)

 #END:       ENDPGM
