       ctl-opt  DftActgrp(*No)    BndDir('YAJL')  DatFmt(*ISO)
                Option(*SrcStmt:*NoDebugIO);

         //====================================================================================
         // AM#R410
         // LEC          2022/07/27
         // This program consumes the resulting messages from Service Parts JSON - RDAs.
         //====================================================================================
         //

       DCL-F AM#PP400   DISK(*EXT) USAGE(*INPUT) KEYED;
       DCL-F AB#PPCT    DISK(*EXT) USAGE(*UPDATE) KEYED;
       DCL-F AM#PP400LG DISK(*EXT) USAGE(*OUTPUT);
       DCL-F AM#PP400MG DISK(*EXT) USAGE(*OUTPUT);

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
            message  char(100) dim(100);
            type    varchar(10);
          end-ds;
         //  num_confirmedPurchaseOrders  int(10);
         //  confirmedPurchaseOrders char(15)  dim(1);
         //  confirmedTrailer  varchar(30);
         //  pickupID  varchar(30);
         //  responseCaseBuildDetails varchar(200);
         //  num_vendors   int(10);
         //  dcl-ds  vendors  dim(2);
         //   vendorCode  varchar(5);
         //   shipmentID  varchar(15);
         //   num_cases   int(10);
         //   dcl-ds cases  dim(50);
         //       caseNumber  varchar(8);
         //   end-ds;
         //   end-ds;
       end-ds;


       dcl-s  resultname      VarChar(500) Inz;
       dcl-s msg char(52);
       dcl-s v int(10);
       dcl-s c int(10);
       dcl-s m int(10);
       dcl-s g int(10);
       dcl-s SysDtTm  timestamp(0) inz(*sys) ;

        dcl-c options  'doc=file case=any countprefix=num_  +
                       allowmissing=yes  allowextra=yes';

         // Input parameters...
        dcl-pr   Main      extpgm('AM#R410');
                 *N   Char(20);
                 *N   Char(50);
                 *N   Char(5);
                 *N   Char(6);
        end-pr;

        dcl-pi   Main;
                appid  Char(20);
                file   Char(50);
                supp   Char(5);
                worker Char(6);
        end-pi;

         //--------------------------------------------------------------------------------
         // Main Processing


         //--------------------------------------------------------------------------------
         // get values from TSCS control file...

        chain (appid) AM#PP400;
         If  %found(AM#PP400);

           resultname = %trim(T1RSLT) + %trim(file);

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
         L1MSTS = %char(results.code);
         L1CFM# = results.confirmationNumber;
         L1SUPP = supp;
           //  L1ORD# = results.pickupID;

         L1WKCD = worker;

               Write AM#PPLG1;

        //--------------------------------------------------------------------------------

        EndIf;

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

        *InLR = *on;
        Return;
