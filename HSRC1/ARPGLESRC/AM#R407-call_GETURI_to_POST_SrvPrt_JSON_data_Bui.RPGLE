       ctl-opt  DFTACTGRP(*NO) ACTGRP('GETURI') BNDDIR('GETURI')
                Option(*SrcStmt:*NoDebugIO);

         //====================================================================================
         // AM#R407
         // LEC          2021/12/17
         // This program POSTs Service Parts JSON data to toyota website api
         // via GETURI utility and receives message results into IFS.
         //====================================================================================
         //

       DCL-F AM#PP400 DISK(*EXT) USAGE(*INPUT) KEYED;
       DCL-F AM#PP400ER DISK(*EXT) USAGE(*OUTPUT) KEYED;

         // Imports
      /COPY GETURI/QCOPYSRC,GETURICOPY
      /COPY GETURI/QCOPYSRC,P.GETURI

      /free

       dcl-pr   Main      extpgm('AM#R407');
                *N   Char(20);
                *N   Char(50);
                *N   Char(2500);
       end-pr;

       dcl-pi   Main;
               appid Char(20);
               file Char(50);
               #token Char(2500);
       end-pi;

        // Work Variables

       dcl-s  pathname      VarChar(500) Inz;
       dcl-s  resultname    VarChar(500) Inz;
       dcl-s  rc int(10);
       dcl-s  err varchar(256);
       dcl-s  errCode char(1);

        // Main Processing

        // get values from TSCS control file for JSON build...
       chain (appid) AM#PP400;
        if  %found;

           pathname = %trim(T1FILE)+%trim(File);
           resultname = %trim(T1RSLT) + %trim(File);

        geturi_resetValues();
        geturi_setValue('gi_uri': %trim(T1WEBS));
        geturi_setValue('gi_outtype':'*STMF');
        geturi_setValue('gi_ContType':'application/json');
        geturi_setValue('gi_Data':'*STMF');
        geturi_setValue('gi_DStmf': %trim(pathname));
        geturi_setValue('gi_port':'443');
        geturi_setValue('gi_ReqMeth':'POST');
        geturi_setValue('gi_Accept':'application/json');
        geturi_setValue('gi_HTTPVer':'1.1');
        geturi_setValue('gi_stmf': %trim(resultname));
        geturi_setValue('gi_ssl':'*YES');
        geturi_setValue('gi_sprhead':'*YES');
        geturi_setValue('gi_debug':'*NO');

        geturi_addHeader('Authorization':'Bearer ' + %trimr(#token));

       rc =  geturi_call(GetUri_Out:GetUri_Head:errCode:GetUri_Msg:err);

       //  if transaction was not complete, log error code and message....
            if errCode <> 'C' and errCode <> *blanks;
               E1APID  =  appid;
               E1PATH  =  pathname;
               E1MCODE =  errCode;
               E1EMSG  =  err;
               Write AM#PPER1;
            endif;

        endif;

         *InLR = *On;
         Return;

      /end-free
