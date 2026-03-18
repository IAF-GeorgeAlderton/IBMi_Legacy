          // ***********************************************************
          //  Toyota SCS - Get - View All Part# Country of Origin Codes
          //  LEC            2022.05.17
          // ***********************************************************
          //

       ctl-opt  DFTACTGRP(*NO) ACTGRP('GETURI') BNDDIR('GETURI')
                Option(*SrcStmt:*NoDebugIO);


       DCL-F AM#PP400 DISK(*EXT) USAGE(*INPUT) KEYED;
       DCL-F ALBPL30  DISK(*EXT) USAGE(*INPUT) KEYED;

          // Imports
       /COPY GETURI/QCOPYSRC,GETURICOPY
       /COPY GETURI/QCOPYSRC,P.GETURI

       dcl-s  resultname    VarChar(500) Inz;
       dcl-s  rc int(10);
       dcl-s  msg varchar(256);
       dcl-s  errCd char(1);
       dcl-s  wait          Char(1);
       dcl-s  pathname      VarChar(500) Inz;
       dcl-s  request       VarChar(100) Inz;
       dcl-s  e             int(10);
       dcl-s  pos           int(10);
       dcl-s  SysDtTm  timestamp(0) inz(*sys) ;
       dcl-s  wkcd        like(ALWKCD);
       dcl-s  NextPage      int(10);

       dcl-ds pgm_stat PSDS;
              pgm    *PROC;
              status *STATUS;
              routine *ROUTINE;
              library CHAR(10) POS(81);
              user    CHAR(10) POS(254);
       end-ds;

       // Get Input Parameters ....
         dcl-pr   Main      extpgm('AM#R435');
                *N    char(6) ;
                *N    char(5) ;
                *N    char(20) ;
                *N    char(2500) ;
         end-pr ;

         dcl-pi   Main;
               Worker char(6);
               SuppCd char(5);
               appid  char(20);
               #token  char(2500);
         end-pi;


      // get worker name for json data...
          wkcd = %dec(worker:6:0);
          chain (wkcd) ALBPL30;
          if NOT %found(ALBPL30);
             ALWKNM = 'IAF TM';
          endif;

      // Main Process Begins ...

      // get file path for saving resulting json data...
          chain (appid) AM#PP400;
           if  %found;

           resultname = %trim(T1RSLT) + %trim(appid) + %trim(SuppCd) + '.json';
           request = 'vendorCode=' + %trim(SuppCd) + '&pageNo=0' +
                                      '&pageSize=6000';

        geturi_resetValues();
        geturi_setValue('gi_HTTPVer':'1.1');
        geturi_setValue('gi_uri': %trim(T1WEBS));
        geturi_setValue('gi_ContType':'application/json');
        geturi_setValue('gi_Data': %trim(request));
        geturi_setValue('gi_ReqMeth':'GET');
        geturi_setValue('gi_Accept':'application/json');
        geturi_setValue('gi_outtype':'*STMF');
        geturi_setValue('gi_stmf': %trim(resultname));
        geturi_setValue('gi_Port':'443');
        geturi_setValue('gi_ssl':'*YES');
        geturi_setValue('gi_sprhead':'*YES');
        geturi_setValue('gi_debug':'*NO');

        geturi_addHeader('Authorization':'Bearer ' + %trimr(#token));

       rc =  geturi_call(GetUri_Out:GetUri_Head:errCd:GetUri_Msg:msg);


        endif;


       *InLr = *On;
       Return;
