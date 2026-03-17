       ctl-opt  DFTACTGRP(*NO) ACTGRP('GETURI') BNDDIR('GETURI')
                Option(*SrcStmt:*NoDebugIO);

         //====================================================================================
         // AM#R405
         // LEC          2022/01/06
         // This program GETs TSCS token from website api
         // via GETURI utility and receives actual token in result file.
         //====================================================================================
         //

       DCL-F AM#PP400 DISK(*EXT) USAGE(*INPUT) KEYED;
       DCL-F AM#PP400ER DISK(*EXT) USAGE(*OUTPUT) KEYED;

         // Imports
      /COPY GETURI/QCOPYSRC,GETURICOPY
      /COPY GETURI/QCOPYSRC,P.GETURI

      /free

       dcl-pr   Main      extpgm('AM#R405');
                *N   Char(20);
       end-pr;

       dcl-pi   Main;
               appid Char(20);
       end-pi;

        // Work Variables

       dcl-s  creds     VarChar(500) Inz;
       dcl-s  resultname    VarChar(500) Inz;
       dcl-s  rc int(10);
       dcl-s  err varchar(256);
       dcl-s  errCode char(1);

        // Main Processing

        // get values from TSCS control file for token request...
       chain (appid) AM#PP400;
        if  %found;

           creds = 'client_secret=' + %trim(T1PASS) + '&client_id=' +
                   %trim(T1USID) + '&grant_type=client_credentials';

           resultname = %trim(T1RSLT) + 'response.json';

        geturi_resetValues();
        geturi_setValue('gi_HTTPVer':'1.1');
        geturi_setValue('gi_uri': %trim(T1WEBS));
        geturi_setValue('gi_ContType':'application/x-www-form-urlencoded');
        geturi_setValue('gi_Data': %trim(creds));
        geturi_setValue('gi_ReqMeth':'POST');
        geturi_setValue('gi_Accept':'application/json');
        geturi_setValue('gi_outtype':'*STMF');
        geturi_setValue('gi_stmf': %trim(resultname));
        geturi_setValue('gi_Port':'443');
        geturi_setValue('gi_ssl':'*YES');
        geturi_setValue('gi_sprhead':'*YES');
        geturi_setValue('gi_debug':'*NO');

       rc =  geturi_call(GetUri_Out:GetUri_Head:errCode:GetUri_Msg:err);

       //  if transaction was not complete, log error code and message....
            if errCode <> 'C' and errCode <> *blanks;
               E1APID  =  appid;
               E1MCODE =  errCode;
               E1EMSG  =  err;
               Write AM#PPER1;
            endif;

        endif;

         *InLR = *On;
         Return;

      /end-free
