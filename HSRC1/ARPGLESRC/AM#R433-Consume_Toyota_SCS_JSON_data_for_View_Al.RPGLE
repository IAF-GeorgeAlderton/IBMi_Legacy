       ctl-opt  DftActgrp(*No)    BndDir('YAJL')  DatFmt(*ISO)
                Option(*SrcStmt:*NoDebugIO)  DECEDIT('0.');

         //====================================================================================
         // AM#R433
         // LEC          2022/03/18
         // This program consumes the resulting json data from SP View All POs.
         //====================================================================================
         //

       /include yajl_h

       DCL-F AM#PP400   DISK(*EXT) USAGE(*INPUT) KEYED;
       DCL-F AM#PP432   DISK(*EXT) USAGE(*OUTPUT);

         dcl-ds records  qualified inz;
         num_content int(10);
         dcl-ds content  dim(9999);
            partNumber  varchar(12);
            deliveryDueDate varchar(10);
            unFulFilledQuantity  int(10);
            status varchar(10);
            serialNumberFlag ind;
            lineItemNumber varchar(5);
            orderQuantity int(10);
            vendorPartNumber varchar(12);
            homePosition  varchar(1);
            transmissionDate  varchar(10);
            orderRefNumber  varchar(12);
            containerID varchar(10);
            serialNumber varchar(10);
            subPartNumber int(10);
            eda varchar(10);
            orginalDDD varchar(10);
            poNumber  varchar(12);
            orderType varchar(1);
            finalDestination varchar(7);
            dealerCode varchar(1);
            transportationCode  varchar(1);
            dealerOrder  varchar(12);
            directShipFlag  ind;
            orderPriority  varchar(1);
            vendorCode  varchar(5);
            finalDestDesc varchar(20);
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
          unpaged varchar(5);
          paged   varchar(5);
        end-ds;
        last   varchar(5);
        totalPages  int(10);
        totalElements  int(10);
        dcl-ds sort;
          sorted  varchar(5);
          unsorted varchar(5);
          empty  varchar(5);
        end-ds;
        first   varchar(5);
        number  int(10);
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
         // load view all pos request data into data structure....

            Monitor;
              data-into records
              %data(%trim(resultname): options)
              %parser('YAJLINTO');
            On-error;
            EndMon;

        //--------------------------------------------------------------------------------
        // output records to compliance exception file on as400...

              For c = 1 to records.num_content;
               M1MHN  = records.content(c).partNumber;
               M1DDD  = records.content(c).deliveryDueDate;
               M1UQTY = records.content(c).unFulFilledQuantity;
               M1STAT = records.content(c).status;

               M1SNFL = records.content(c).serialNumberFlag;
               M1LINO =  records.content(c).lineItemNumber;
               M1OQTY =  records.content(c).orderQuantity;
               M1SHIN =  records.content(c).vendorPartNumber;
               M1HOME =  records.content(c).homePosition;
               M1TRDT =  records.content(c).transmissionDate;
               M1OREF =  records.content(c).orderRefNumber;
               M1CNID =  records.content(c).containerID;
               M1SERL =  records.content(c).serialNumber;
               M1SUB# =  records.content(c).subPartNumber;
               M1EDA  =  records.content(c).eda;
               M1ODDD =  records.content(c).orginalDDD;
               M1ODRN =  records.content(c).poNumber;
               M1TYPE =  records.content(c).orderType;
               M1DEST =  records.content(c).finalDestination;
               M1DCOD =  records.content(c).dealerCode;
               M1DSFL = records.content(c).directShipFlag;
               M1PRTY =  records.content(c).orderPriority;
               M1SUPP =  records.content(c).vendorCode;
               M1FDSC =  records.content(c).finalDestDesc;

               M1PSIZ =  records.pageable.pageSize;
               M1OSET =  records.pageable.offset;
               M1PGNO =  records.pageable.pageNumber;
               M1TOTP =  records.totalPages;
               write AM#PP43R;
              EndFor;

        EndIf;

        *InLR = *on;
        Return;
