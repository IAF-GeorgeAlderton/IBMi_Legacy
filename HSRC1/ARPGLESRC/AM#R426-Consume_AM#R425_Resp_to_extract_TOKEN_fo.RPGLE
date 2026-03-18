       ctl-opt  DftActgrp(*No)    BndDir('YAJL')  DatFmt(*ISO)
                Option(*SrcStmt:*NoDebugIO);

         //====================================================================================
         // AM#R426
         // LEC          2024/04/01
         // This program consumes the resulting messages from Get Token to Extract the TOKEN.
         //
         // For Mass Production
         //
         //====================================================================================
         //

       DCL-F AM#PP400   DISK(*EXT) USAGE(*INPUT) KEYED;

       DCL-DS pgm_stat PSDS;
              pgm    *PROC;
              status *STATUS;
              routine *ROUTINE;
              library CHAR(10) POS(81);
       END-DS;


       dcl-ds results qualified inz;
         token_type varchar(10);
         expires_in  varchar(4);
         ext_expires_in  varchar(4);
         expires_on   varchar(10);
         not_before   varchar(10);
         resource  varchar(100);
         access_token varchar(2500);
             end-ds;

        dcl-c options  'doc=file case=any countprefix=num_  +
                       allowmissing=yes  allowextra=yes';

       dcl-s SysDtTm  timestamp(0) inz(*sys) ;
       dcl-s  resultname  VarChar(500) Inz;

       dcl-pr   AM#C408   extpgm('AM#C408');
       end-pr;

         // Input parameters...
        dcl-pr   Main      extpgm('AM#R426');
                 *N   Char(20);
                 *N   Char(50);
                 *N   Char(2500);
        end-pr;

        dcl-pi   Main;
                appid Char(20);
                file Char(50);
                token Char(2500);
        end-pi;

         //--------------------------------------------------------------------------------
         // Main Processing


         //--------------------------------------------------------------------------------
         // get values from TSCS control file...

        chain (appid) AM#PP400;
         If  %found(AM#PP400);

           resultname = %trim(T1RSLT) + %trim(File);

         //--------------------------------------------------------------------------------
         // load message results into data structure....

            Monitor;
            data-into results
            %data(%trim(resultname) : options)
            %parser('YAJLINTO');
            On-error;
               AM#C408();
            EndMon;

         //--------------------------------------------------------------------------------

            token = results.access_token;

         EndIf;

        *InLR = *on;
        Return;
