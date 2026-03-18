       ctl-opt  DftActgrp(*No)    BndDir('YAJL')  DatFmt(*ISO)
                Option(*SrcStmt:*NoDebugIO);

         //====================================================================================
         // AM#R408
         // LEC          2020/11/04
         // This program consumes the resulting messages from Service Parts JSON - Case Build.
         //====================================================================================
         //

       DCL-F AM#PP400   DISK(*EXT) USAGE(*INPUT) KEYED;
       DCL-F AB#PPCT    DISK(*EXT) USAGE(*UPDATE) KEYED;
       DCL-F AM#PP400LG DISK(*EXT) USAGE(*OUTPUT);
       DCL-F AM#PP400MG DISK(*EXT) USAGE(*OUTPUT);
       DCL-F AB#PP66LG  DISK(*EXT) USAGE(*OUTPUT);

       DCL-DS pgm_stat PSDS;
              pgm    *PROC;
              status *STATUS;
              routine *ROUTINE;
              library CHAR(10) POS(81);
       END-DS;


       dcl-ds results qualified inz;
         code varchar(4);
         confirmationNumber varchar(20);
         num_messages int(10);
          dcl-ds messages dim(15);
            keyObject varchar(50);
             num_message int(10);
            message  char(100) dim(50);
            type    varchar(10);
          end-ds;
         num_confirmedPurchaseOrders  int(10);
         confirmedPurchaseOrders char(15)  dim(1);
         confirmedTrailer  varchar(30);
         pickupID  varchar(20);
           dcl-ds responseCaseBuildDetails;
              vendorCode  varchar(5);
              num_cases int(10);
              dcl-ds cases  dim(200);
                 caseNumber  varchar(10);
                 status   varchar(15);
                 transportationCode zoned(1);
                 directShipFlag  varchar(1);
                 num_units int(10);
                 dcl-ds units  dim(200);
                     partNumber  varchar(20);
                     poNumber varchar(15);
                     poLineNumber  varchar(5);
                     poLineHomePosition  varchar(1);
                     poLineDeliveryDueDate varchar(10);
                     partPOLineQuantityOrdered int(5);
                     partPOLineQuantityRemaining int(5);
                     partPOLineQuantityAllocated int(5);
                     partPOLineStatus  varchar(12);
                     dealerOrFinalDist  varchar(10);
                     serialNumberDetails  varchar(30);
                  end-ds;
                 end-ds;
                end-ds;
         num_vendors   int(10);
         dcl-ds  vendors  dim(2);
            vencode  varchar(5);
         end-ds;
       end-ds;


       dcl-s  resultname      VarChar(500) Inz;
       dcl-s msg char(52);
       dcl-s c int(10);
       dcl-s p int(10);
       dcl-s u int(10);
       dcl-s m int(10);
       dcl-s g int(10);
       dcl-s SysDtTm  timestamp(0) inz(*sys) ;

        dcl-c options  'doc=file case=any countprefix=num_  +
                       allowmissing=yes  allowextra=yes';

         // Input parameters...
        dcl-pr   Main      extpgm('AM#R408');
                 *N   Char(20);
                 *N   Char(8);
                 *N   Char(6);
        end-pr;

        dcl-pi   Main;
                appid Char(20);
                case  Char(8);
                worker Char(6);
        end-pi;

         //--------------------------------------------------------------------------------
         // Main Processing


         //--------------------------------------------------------------------------------
         // get values from TSCS control file...

        chain (appid) AM#PP400;
         If  %found(AM#PP400);

           resultname = %trim(T1RSLT) + 'Case_' + %trim(CASE) + '.json';

         //--------------------------------------------------------------------------------
         // load message results into data structure....

            Monitor;
            data-into results
            %data(%trim(resultname) : options)
            %parser('YAJLINTO');
            On-error;
            EndMon;


         //--------------------------------------------------------------------------------
         // get control id from control file...

         Chain ('TSCS    ' : appid) AB#PPCT;
          If  %found(AB#PPCT);
              CTNBR1 += 1;
              Update AB#PPCT1;
          Endif;


        //--------------------------------------------------------------------------------
        // output to log file...

         L1CTID = CTNBR1;
         L1DATE = %dec(%date(SysDtTm));
         L1TIME = %dec(%time(SysDtTm));
         L1PGM  = pgm;
         L1METH = 'POST';
         L1APID = appid;
         L1CFM# = results.confirmationNumber;

         L1MSTS = %char(results.code);
         L1SUPP = results.responseCaseBuildDetails.vendorCode;
         L1ORD# = case;
         L1WKCD = worker;

               Write AM#PPLG1;

        //--------------------------------------------------------------------------------
        // output results to case log file...

         L6KYMD = %dec(%date(SysDtTm));
         L6KTIM = %dec(%time(SysDtTm));

         L6SUPP = results.responseCaseBuildDetails.vendorCode;

         For c = 1 to results.responseCaseBuildDetails.num_cases;
           L6CASE = results.responseCaseBuildDetails.cases(c).caseNumber;
           L6STAT = results.responseCaseBuildDetails.cases(c).status;

            For u = 1 to results.responseCaseBuildDetails.cases(c).num_units;
              L6ODRN = results.responseCaseBuildDetails.
                       cases(c).units(u).poNumber;
              L6LIN# = results.responseCaseBuildDetails.
                       cases(c).units(u).poLineNumber;
              L6MHN  = results.responseCaseBuildDetails.
                       cases(c).units(u).PartNumber;
              L6HOME = results.responseCaseBuildDetails.
                       cases(c).units(u).poLineHomePosition;
              L6DDD  = results.responseCaseBuildDetails.
                       cases(c).units(u).poLineDeliveryDueDate;
              L6QTYO = results.responseCaseBuildDetails.
                       cases(c).units(u).partPOLineQuantityOrdered;
              L6QTYA = results.responseCaseBuildDetails.
                       cases(c).units(u).partPOLineQuantityAllocated;
              L6QTYR = results.responseCaseBuildDetails.
                       cases(c).units(u).partPOLineQuantityRemaining;
              L6LNST = results.responseCaseBuildDetails.
                       cases(c).units(u).partPOLineStatus;
              Write AB#PP66L;
            EndFor;
         EndFor;

        //--------------------------------------------------------------------------------
        // output messages to message file...

         For m = 1 to results.num_messages;
            M1APID = appid;
            M1CTID = CTNBR1;
            M1KOBJ = results.messages(m).keyobject;
              For g = 1 to results.messages(m).num_message;
               M1MESG = results.messages(m).message(g);
               write AM#PPMG1;
              EndFor;
         EndFor;
        //--------------------------------------------------------------------------------

        EndIf;

        *InLR = *on;
        Return;
