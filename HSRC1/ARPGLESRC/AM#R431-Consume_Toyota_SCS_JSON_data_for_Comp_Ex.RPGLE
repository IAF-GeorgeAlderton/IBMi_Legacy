       ctl-opt  DftActgrp(*No)    BndDir('YAJL')  DatFmt(*ISO)
                Option(*SrcStmt:*NoDebugIO)  DECEDIT('0.');

         //====================================================================================
         // AM#R431
         // LEC          2022/03/07
         // This program consumes the resulting json data rom SP Compliance Exceptions - RDA.
         //====================================================================================
         //

       /include yajl_h

       DCL-F AM#PP400   DISK(*EXT) USAGE(*INPUT) KEYED;
       DCL-F AM#PP430   DISK(*EXT) USAGE(*OUTPUT);


       DCL-DS pgm_stat PSDS;
         num_records int(20) pos(372);
       END-DS;


        dcl-ds records  dim(9999) qualified inz;
           id varchar(10);
           complianceID varchar(20);
           poNumber  varchar(12);
           partNumber  varchar(12);
           orginalDDD varchar(10);
           requestedDDD varchar(10);
           qty int(10);
           reasonCode varchar(10);
           reasonComment varchar(20);
           reasonDesc varchar(20);
        end-ds;


       dcl-s  resultname      VarChar(500) Inz;
       dcl-s c int(10);
       dcl-s SysDtTm  timestamp(0) inz(*sys) ;

        dcl-c options  'doc=file case=any countprefix=num_  +
                       allowmissing=yes  allowextra=yes';


         // Input parameters...
        dcl-pr   Main      extpgm('AM#R431');
                 *N   Char(20);
                 *N   Char(5);
        end-pr;

        dcl-pi   Main;
                appid Char(20);
                SuppCd Char(5);
        end-pi;

         //--------------------------------------------------------------------------------
         // Main Processing

         // get values from TSCS control file...
        chain (appid) AM#PP400;
         If  %found(AM#PP400);

           resultname = %trim(T1RSLT) + %trim(appid) + %trim(SuppCd) + '.json';

         //--------------------------------------------------------------------------------
         // load compliance exception results into data structure....

            Monitor;
              data-into records
              %data(%trim(resultname): options)
              %parser('YAJLINTO');
            On-error;
            EndMon;

        //--------------------------------------------------------------------------------
        // output records to compliance exception file on as400...

              For c = 1 to num_records;
               M1ID   =  records(c).id;
               M1CMID =  records(c).complianceID;
               M1ODRN =  records(c).poNumber;
               M1MHN  =  records(c).partNumber;
               M1ODDD =  records(c).orginalDDD;
               M1RDDD =  records(c).requestedDDD;
               M1QTY  =  records(c).qty;
         //    M1RSCD =  records(c).reasonCode;
               M1RCMT =  records(c).reasonComment;
               M1RDSC =  records(c).reasonDesc;
               write AM#PP43R;
              EndFor;

        EndIf;

        *InLR = *on;
        Return;
