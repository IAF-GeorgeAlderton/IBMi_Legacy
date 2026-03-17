             PGM
             /** CPYLIB1**************************/
             /*  COPY GENTRAN LIBRARY TO XG*     */
             /*  J.W.   2017.11.21               */
             /************************************/

             CPYLIB     FROMLIB(GENSTD    ) TOLIB(XXGENSTD   ) CRTLIB(*YES)
             CPYLIB     FROMLIB(G3X1CUSOBJ) TOLIB(XXG3X1CUSO ) CRTLIB(*YES)
             CPYLIB     FROMLIB(G3X1DTA   ) TOLIB(XXG3X1DTA  ) CRTLIB(*YES)
             CPYLIB     FROMLIB(G3X4DTA   ) TOLIB(XXG3X4DTA  ) CRTLIB(*YES)
             CPYLIB     FROMLIB(G3X6DTA   ) TOLIB(XXG3X6DTA  ) CRTLIB(*YES)

       /*    CPYLIB     FROMLIB(G3X1HIST  ) TOLIB(XG3X1HIST  ) CRTLIB(*YES) */
       /*    CPYLIB     FROMLIB(G3X1PGM   ) TOLIB(XG3X1PGM   ) CRTLIB(*YES) */
       /*    CPYLIB     FROMLIB(G3X1SAMP  ) TOLIB(XG3X1SAMP  ) CRTLIB(*YES) */
       /*    CPYLIB     FROMLIB(G3X1TOOL  ) TOLIB(XG3X1TOOL  ) CRTLIB(*YES) */
       /*    CPYLIB     FROMLIB(G3X1TST   ) TOLIB(XG3X1TST   ) CRTLIB(*YES) */
       /*    CPYLIB     FROMLIB(G3X4PGM   ) TOLIB(XG3X4PGM   ) CRTLIB(*YES) */
       /*    CPYLIB     FROMLIB(G3X4SAMP  ) TOLIB(XG3X4SAMP  ) CRTLIB(*YES) */
       /*    CPYLIB     FROMLIB(G3X4TOOL  ) TOLIB(XG3X4TOOL  ) CRTLIB(*YES) */
       /*    CPYLIB     FROMLIB(G3X4TST   ) TOLIB(XG3X4TST   ) CRTLIB(*YES) */
       /*    CPYLIB     FROMLIB(G3X6PGM   ) TOLIB(XG3X6PGM   ) CRTLIB(*YES) */
             MONMSG     MSGID(CPF2358)

             ENDPGM
