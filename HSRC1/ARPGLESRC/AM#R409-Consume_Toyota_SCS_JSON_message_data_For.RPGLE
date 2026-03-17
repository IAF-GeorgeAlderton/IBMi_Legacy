       ctl-opt  DftActgrp(*No)    BndDir('YAJL')  DatFmt(*ISO)
                Option(*SrcStmt:*NoDebugIO);

         //====================================================================================
         // AM#R409
         // LEC          2022/02/11
         // This program consumes the resulting messages from Service Parts JSON - Trailer Build.
         //====================================================================================
         //

       DCL-F AM#PP400   DISK(*EXT) USAGE(*INPUT) KEYED;
       DCL-F AB#PPCT    DISK(*EXT) USAGE(*UPDATE) KEYED;
       DCL-F AM#PP400LG DISK(*EXT) USAGE(*OUTPUT);
       DCL-F AM#PP400MG DISK(*EXT) USAGE(*OUTPUT);
       DCL-F AM#PP21LG  DISK(*EXT) USAGE(*OUTPUT);

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
         pickupID  varchar(30);
         responseCaseBuildDetails varchar(200);
         num_vendors   int(10);
         dcl-ds  vendors  dim(2);
            vendorCode  varchar(5);
            shipmentID  varchar(15);
            num_cases   int(10);
            dcl-ds cases  dim(50);
                caseNumber  varchar(8);
            end-ds;
         end-ds;
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
        dcl-pr   Main      extpgm('AM#R409');
                 *N   Char(20);
                 *N   Char(8);
                 *N   Char(4);
                 *N   Char(20);
                 *N   Char(9);
                 *N   Char(12);
                 *N   Char(9);
                 *N   Char(6);
                 *N   Char(5);
                 *N   Char(6);
        end-pr;

        dcl-pi   Main;
                appid  Char(20);
                shid   Char(8);
                shit   Char(4);
                trlr   Char(20);
                drfn   Char(9);
                drln   Char(12);
                route  Char(9);
                scac   Char(6);
                supp   Char(5);
                worker Char(6);
        end-pi;

         //--------------------------------------------------------------------------------
         // Main Processing


         //--------------------------------------------------------------------------------
         // get values from TSCS control file...

        chain (appid) AM#PP400;
         If  %found(AM#PP400);

           resultname = %trim(T1RSLT) + %trim(shid) + '_'
                      + %trim(route) + '_' + %trim(supp) + '.json';

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
         L1SURT = route;
         L1TRLR = trlr;
         L1SCAC = scac;
         L1DRFN = drfn;
         L1DRLN = drln;
         L1SHID = %dec(shid:8:0);
         L1SHIT = %dec(shit+'00':6:0);
         L1ORD# = results.pickupID;

         L1WKCD = worker;

               Write AM#PPLG1;

        //--------------------------------------------------------------------------------
        // output results to trailer shipment build log file...

         LTKYMD = %dec(%date(SysDtTm));
         LTKTIM = %dec(%time(SysDtTm));
         LTCFM# = results.confirmationNumber;
         LTTRLR = results.confirmedTrailer;
         LTPUID = results.pickupID;


         For v = 1 to results.num_vendors;
           LTSUPP = results.vendors(v).vendorCode;
           LTSID# = results.vendors(v).shipmentID;

            For c = 1 to results.vendors(v).num_cases;
              LTCASE = results.vendors(v).cases(c).caseNumber;

              Write AM#PP21L;

            EndFor;
         EndFor;

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
