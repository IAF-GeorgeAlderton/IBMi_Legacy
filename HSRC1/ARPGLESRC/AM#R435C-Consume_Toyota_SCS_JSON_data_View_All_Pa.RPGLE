       ctl-opt  DftActgrp(*No)    BndDir('YAJL')  DatFmt(*ISO)
                Option(*SrcStmt:*NoDebugIO)  DECEDIT('0.');

         //====================================================================================
         // AM#R435C
         // LEC          2022/03/18
         // This program consumes the resulting json data from SP View All Parts Country/Origin
         //====================================================================================
         //

       /include yajl_h

       DCL-F AM#PP400   DISK(*EXT) USAGE(*INPUT) KEYED;
       DCL-F AM#PP435   DISK(*EXT) USAGE(*OUTPUT);

         dcl-ds records  qualified inz;
         num_content int(10);
         dcl-ds content  dim(9999);
            id  int(10);
            vendorCode varchar(5);
            partNumber  varchar(12);
            countryOfOrigin varchar(2);
            modifiedDate varchar(16);
            modifiedBy varchar(15);
         end-ds;

        dcl-ds pageable;
          dcl-ds sort;
            sorted  varchar(5);
            unsorted varchar(5);
            empty  varchar(5);
          end-ds;
          pageNumber int(10);
          pageSize int(10);
          offset  int(10);
          paged varchar(5);
          unpaged   varchar(5);
        end-ds;
        last   varchar(5);
        totalElements  int(10);
        totalPages  int(10);
        dcl-ds sort;
          sorted  varchar(5);
          unsorted varchar(5);
          empty  varchar(5);
        end-ds;
        first   varchar(5);
        number  int(10);
        numberOfElements  int(10);
        size    int(10);
        empty   varchar(5);
        end-ds;


       dcl-s  resultname      VarChar(500) Inz;
       dcl-s c int(10);
       dcl-s SysDtTm  timestamp(0) inz(*sys) ;

        dcl-c options  'doc=file case=any countprefix=num_  +
                       allowmissing=yes  allowextra=yes';


         // Input parameters...
        dcl-pr   Main      extpgm('AM#R433');
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
         // load view all parts country of origin request data into data structure....

            Monitor;
              data-into records
              %data(%trim(resultname): options)
              %parser('YAJLINTO');
            On-error;
            EndMon;

        //--------------------------------------------------------------------------------
        // output records to parts country of origin file on as400...

              For c = 1 to records.num_content;
               M5RCID = records.content(c).id;
               M5SUPP = records.content(c).vendorCode;
               M5MHIN = records.content(c).partNumber;
               M5COC  = records.content(c).countryOfOrigin;
               M5KODT = %subst(records.content(c).modifiedDate:1:10);
               M5KOTM = %subst(records.content(c).modifiedDate: 12:5);
               M5KOME = records.content(c).modifiedBy;

               write AM#PP43R;
              EndFor;

        EndIf;

        *InLR = *on;
        Return;
