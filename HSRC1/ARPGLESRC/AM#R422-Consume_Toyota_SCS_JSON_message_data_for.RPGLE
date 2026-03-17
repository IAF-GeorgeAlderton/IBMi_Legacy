       ctl-opt  DftActgrp(*No)    BndDir('YAJL')  DatFmt(*ISO)
                Option(*SrcStmt:*NoDebugIO);

         //====================================================================================
         // AM#R422
         // LEC          2020/12/02
         // This program consumes the resulting messages from Mass Prod JSON - Trailer Build.
         //====================================================================================
         //

       DCL-F AM#PP400   DISK(*EXT) USAGE(*INPUT) KEYED;
       DCL-F AB#PPCT    DISK(*EXT) USAGE(*UPDATE) KEYED;
       DCL-F AM#PP400LG DISK(*EXT) USAGE(*OUTPUT);
       DCL-F AM#PP400MG DISK(*EXT) USAGE(*OUTPUT);
       DCL-F AM#PL21F   DISK(*EXT) USAGE(*UPDATE) KEYED;

       DCL-DS pgm_stat PSDS;
              pgm    *PROC;
              status *STATUS;
              routine *ROUTINE;
              library CHAR(10) POS(81);
       END-DS;


       dcl-ds results qualified inz;
         code int(10);
         num_messages int(10);
          dcl-ds messages dim(50);
            keyObject varchar(50);
             num_message int(10);
            message  char(100) dim(50);
            type    varchar(10);
          end-ds;
         confirmationNumber varchar(30);
          num_confirmedOrders int(10);
         confirmedOrders  char(15) dim(1);
         dcl-ds confirmedTrailer;
           supplier  varchar(5);
           route     varchar(7);
           run       varchar(2);
           trailerNumber varchar(20);
           pickUp  varchar(16);
         end-ds;
         ASNShipment  varchar(30);
       end-ds;


       dcl-s  resultname      VarChar(500) Inz;
       dcl-s msg char(52);
       dcl-s m int(10);
       dcl-s p int(10);
       dcl-s g int(10);
       dcl-s shit6 char(6);
       dcl-s today zoned(8:0);
       dcl-s now   zoned(6:0);
       dcl-s SysDtTm  timestamp(0) inz(*sys) ;
        dcl-c options  'doc=file case=any countprefix=num_  +
                       allowmissing=yes  allowextra=yes';


        dcl-pr   AM#C406   extpgm('AM#C406');
        end-pr;

        dcl-pr   AM#C407   extpgm('AM#C407');
        end-pr;

         // Input parameters...
        dcl-pr   Main      extpgm('AM#R422');
                 *N   Char(20);
                 *N   Char(9);
                 *N   Char(8);
                 *N   Char(4);
                 *N   Char(5);
                 *N   Char(2);
                 *N   Char(6);
                 *N   Char(9);
                 *N   Char(12);
                 *N   Char(20);
        end-pr;

        dcl-pi   Main;
                appid Char(20);
                surt  Char(9);
                shid  Char(8);
                shit  Char(4);
                suppcd  Char(5);
                cfmstatus  Char(2);
                scac  Char(6);
                drfn  Char(9);
                drln  Char(12);
                trlr# Char(20);
        end-pi;

         //--------------------------------------------------------------------------------
         // Main Processing

            CfmStatus = *blanks;
            shit6 = shit + '00';
            today = %dec(%date());
            now   = %dec(%time());

         // get values from TSCS control file...
        chain (appid) AM#PP400;
         If  %found(AM#PP400);

           resultname = %trim(T1RSLT) + %trim(shid) + '_' + %trim(surt) +
                        '_' + suppcd + '.json';

         //--------------------------------------------------------------------------------
         // load message results into data structure....

            Monitor;
              data-into results
              %data(%trim(resultname): options)
              %parser('YAJLINTO');
            On-error;
               AM#C407();
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
         L1SUPP = results.confirmedTrailer.supplier;
         L1SURT = surt;
         L1TRLR = results.confirmedTrailer.trailerNumber;
         If shid <> *blanks;
         L1SHID = %dec(shid:8:0);
         else;
         L1SHID = *ZERO;
         EndIf;
         L1ORD# = results.ASNShipment;

         If shit <> *blanks;
         L1SHIT = %dec(shit+'00':6:0);
         else;
         L1SHIT = *ZERO;
         EndIf;

         L1MSTS = %char(results.code);

         If L1CFM# = *blanks OR L1CFM# = '*NULL';
            CfmStatus = 'NG';
         Else;
            CfmStatus = 'OK';
         EndIf;

         L1SCAC = scac;
         L1DRFN = drfn;
         L1DRLN = drln;
         L1TRLR = trlr#;

               Write AM#PPLG1;

        // if confirmed, update truck/load file with send date/time ...
         If L1CFM# <> *blanks AND L1CFM# <> '*NULL';
            SetLL (surt:shid:shit6) AM#PL21F;
            DoW NOT %eof(AM#PL21F);
            ReadE (surt:shid:shit6) AM#PL21F;
            If %eof(AM#PL21F);
               Leave;
            EndIf;
            If R2HNTE = 'OK' AND R2SKJY = ' ';
               R2LSDT = today;
               R2LSTM = now;
               Update AM#PP211;
            EndIf;
            EndDo;
         EndIf;


        // if Post to SCS Failed, send email...
               If L1MSTS = '500';
                  AM#C406();
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

        EndIf;

        *InLR = *on;
        Return;
