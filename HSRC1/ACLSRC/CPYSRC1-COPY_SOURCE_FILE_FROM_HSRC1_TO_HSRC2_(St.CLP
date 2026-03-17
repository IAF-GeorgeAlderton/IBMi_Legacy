             PGM
             /** CPYSRC1 *********************************************/
             /*  COPY SOURCE FILE FROM HSRC1 TO HSRC2 (STEP1)        */
             /*  J.WATANABE 2026.01.15                               */
             /********************************************************/

 /* CLEAR SOURCE FILE */
             CLRPFM     FILE(HSRC2/ACLSRC ) MBR(*ALL)
             MONMSG     MSGID(CPF3133)

             CLRPFM     FILE(HSRC2/ACMDSRC) MBR(*ALL)
             MONMSG     MSGID(CPF3133)

             CLRPFM     FILE(HSRC2/ADDSSRC) MBR(*ALL)
             MONMSG     MSGID(CPF3133)

             CLRPFM     FILE(HSRC2/ADSPSRC) MBR(*ALL)
             MONMSG     MSGID(CPF3133)

             CLRPFM     FILE(HSRC2/APRTSRC) MBR(*ALL)
             MONMSG     MSGID(CPF3133)

             CLRPFM     FILE(HSRC2/ARPGLESRC) MBR(*ALL)
             MONMSG     MSGID(CPF3133)

             CLRPFM     FILE(HSRC2/ARPGSRC) MBR(*ALL)
             MONMSG     MSGID(CPF3133)

 /* COPY SOURCE FILE MEMBER */
             CALL       PGM(HOBJ1/CPYR01)

             ENDPGM
