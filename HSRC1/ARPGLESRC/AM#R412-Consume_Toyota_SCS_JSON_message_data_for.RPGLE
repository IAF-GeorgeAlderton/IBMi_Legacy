       ctl-opt  DftActgrp(*No)    BndDir('YAJL')  DatFmt(*ISO)
                Option(*SrcStmt:*NoDebugIO);

         //====================================================================================
         // AM#R412
         // LEC          2021/02/22
         // This program consumes the resulting messages from Mass Prod JSON - Skid Build.
         //====================================================================================
         //

       DCL-F AM#PP400   DISK(*EXT) USAGE(*INPUT) KEYED;
       DCL-F AB#PPCT    DISK(*EXT) USAGE(*UPDATE) KEYED;
       DCL-F AM#PL0C DISK(*EXT) USAGE(*UPDATE) KEYED;
       DCL-F AM#PP400LG DISK(*EXT) USAGE(*OUTPUT);
       DCL-F AM#PP400MG DISK(*EXT) USAGE(*OUTPUT);
       DCL-F AM#PP25    DISK(*EXT) USAGE(*OUTPUT);

       DCL-DS pgm_stat PSDS;
              pgm    *PROC;
              status *STATUS;
              routine *ROUTINE;
              library CHAR(10) POS(81);
       END-DS;


       dcl-ds results qualified inz;
         code int(10);
         num_messages int(10);
          dcl-ds messages dim(15);
            keyObject varchar(50);
             num_message int(10);
            message  char(50) dim(50);
            type    varchar(10);
          end-ds;
         confirmationNumber varchar(30);

          num_confirmedOrders int(10);
          dcl-ds confirmedOrders  dim(2);
            order    char(12);
            supplier char(5);
            plant    char(5);
            dock     char(2);
          end-ds;

         dcl-ds confirmedTrailer;
           supplier  varchar(5);
           route     varchar(7);
           run       varchar(2);
           trailerNumber varchar(20);
           pickUp  varchar(16);
         end-ds;
       end-ds;


       dcl-s  resultname      VarChar(500) Inz;
       dcl-s msg char(52);
       dcl-s m int(10);
       dcl-s p int(10);
       dcl-s g int(10);
       dcl-s mfbc char(50);
       dcl-s SysDtTm  timestamp(0) inz(*sys) ;
        dcl-c options  'doc=file case=any countprefix=num_  +
                       allowmissing=yes  allowextra=yes';

        dcl-pr   AM#C406   extpgm('AM#C406');
        end-pr;

        dcl-pr   AM#C407   extpgm('AM#C407');
        end-pr;

         // Input parameters...
        dcl-pr   Main      extpgm('AM#R412');
                 *N   Char(20);
                 *N   Char(6);
                 *N   Char(12);
                 *N   Char(5);
                 *N   Char(2);
                 *N   Char(2);
                 *N   Char(3);
        end-pr;

        dcl-pi   Main;
                appid   Char(20);
                worker  Char(6);
                ord#    Char(12);
                namc    Char(5);
                nuke    Char(2);
                palt    Char(2);
                skid    Char(3);
        end-pi;

         //--------------------------------------------------------------------------------
         // Main Processing

         // get values from TSCS control file...
        chain (appid) AM#PP400;
         If  %found(AM#PP400);

           resultname = %trim(T1RSLT) + %trim(ord#) + '_' + %trim(NAMC) + '_' +
            %trim(nuke) + '_' + %trim(palt) + '_' + %trim(skid) + '.json';
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

         L1ORD# = ord#;
         L1SUPP = results.confirmedOrders(1).supplier;
         L1NAMC = namc;
         L1DOCK = nuke;

         L1PALT = palt;
         L1SKID = skid;
         L1WKCD = worker;

         L1MSTS = %char(results.code);

               Write AM#PPLG1;

        // if Post to SCS Failed, send email...
               If L1MSTS = '500';
                  AM#C406();
               EndIf;

        //--------------------------------------------------------------------------------
        //  if skid manifest was confirmed                             -------------------

        If L1CFM# <> '*NULL' and L1CFM# <> *blanks ;
          SetLL (L1ORD#:L1NAMC:L1DOCK:L1PALT:L1SKID) AM#PL0C;
          DoW NOT %eof(AM#PL0C);
          ReadE (L1ORD#:L1NAMC:L1DOCK:L1PALT:L1SKID) AM#PL0C;
          If %eof(AM#PL0C);
             Leave;
          EndIf;
        // update packing file with confirmation# for this skid manifest
          If R1HNTE = 'OK' AND R1EXCD <> '12';
             MFBC = R1MFBC;
             R1FLDC = L1CFM#;
               If R1SHME = 'CUT';
                  R1EXCD = '12';
                  R1SHME = 'SHORT';
                  R1FLDA = 'CUT';
               EndIf;
             Update AM#PL0C1;
          EndIf;
          EndDo;

        // output to wrapper scan file if skid send was confirmed by SCS...
         R5MFBC = MFBC;
         R5SSHZ = L1DATE;
         R5SSTI = L1TIME;
         R5ORDN = L1ORD#;
         R5APIT = appid;
         R5APIR = L1MSTS;
         R5APIC = L1CFM#;
         R5APCT = *blanks;
         R5IEID = %char(L1CTID);
         R5CRHZ = L1DATE;
         R5CRTI = L1TIME;

         R5NAMC = L1NAMC;
         R5SUPP = L1SUPP;
         R5NUKE = L1DOCK;
         R5ORD# = L1ORD#;
         R5PLTC = palt;
         R5MROS = %subst(R5MFBC:39:2);
         R5SKID = skid;
          Write AM#PP251;
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
