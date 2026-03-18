          // ***********************************************************
          //  Toyota SCS - Create Toyota Packing List
          //  LEC            2024.06.05
          // ***********************************************************
          //

       ctl-opt  DftActgrp(*No)
                Option(*SrcStmt : *NODEBUGIO)  DecEdit('0.');


       DCL-F AM#PL21P DISK(*EXT) USAGE(*INPUT) KEYED;
       DCL-F AM#PL403 DISK(*EXT) USAGE(*INPUT) KEYED;

       dcl-s  SkEXCD  char(2) dim(2);
       dcl-s  SuppTeamFirst Char(9);
       dcl-s  SuppTeamLast Char(12);
       dcl-s  wait          Char(1);
       dcl-s  errMsg        VarChar(500) Inz;
       dcl-s  pathname      VarChar(500) Inz;
       dcl-s  e             int(10);
       dcl-s  pos           int(10);
       dcl-s  SaveORDN      like(R2ORDN);
       dcl-s  SaveNAMC      like(R2NAMC);
       dcl-s  SaveNUKE      like(R2NUKE);
       dcl-s  Surt_route    like(R2SURT);
       dcl-s  Surt_run      like(R2SURT);
       dcl-s  PickUpDtTm    Char(16);
       dcl-c  alpha         'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
       dcl-s  STime         like(R2SHIT);
       dcl-s  SysDtTm  timestamp(0) inz(*sys) ;
       dcl-s  exDate        Char(10);
       dcl-s  exTime        Char(6);
       dcl-s  TT           Char(21);

       dcl-ds pgm_stat PSDS;
              pgm    *PROC;
              status *STATUS;
              routine *ROUTINE;
              library CHAR(10) POS(81);
              user    CHAR(10) POS(254);
       end-ds;

       // Get Input Parameters ....
         dcl-pr   Main      extpgm('AM#R428');
                *N    char(6) ;
                *N    char(5) ;
                *N    char(9) ;
                *N    char(8) ;
                *N    char(4) ;
         end-pr ;

         dcl-pi   Main;
               Worker char(6);
               SuppCd char(5);
               Route char(9);
               SHID char(8);
               SHIT char(4);
         end-pi;


          If %subst(route:1:3) = 'EX-';
          Else;
          STime = SHIT + '00';
          EndIf;

          exists= 'N';

      // verify supplier code/ship date exists...
          chain (SuppCd:SHID:STime:Route) AM#PL28;
          if NOT %found(AM#PL28);
             *InLr = *On;
             Return;
          endif;

      // if expedite route, use current date/time as pickup time...
          if %subst(route:1:3) = 'EX-' or route ='EXPDIT';
           TrEXCD(1) = '99';
           exDate = %char(%date(SysDtTm));
           exTime  = %char(%time(SysDtTm));
           PickUpDtTm = %subst(exDate:1:10) + 'T' + %subst(exTime:1:2) + ':' +
            %subst(exTime:4:2);
          else;
      // string together ship date/time = pickup time...
           PickUpDtTm = %subst(SHID:1:4) + '-' + %subst(SHID:5:2) + '-' +
            %subst(SHID:7:2) + 'T' + %subst(SHIT:1:2) + ':' + %subst(SHIT:3:2);
          endif;

      // extract route and run from the Route scanned from the Truck Ticket...
             route = %trim(route);
             pos = %Scan(' ' : Route : 1);
              if pos > *zero;
                 Surt_route  = %trim(%subst(Route:1:pos-3));
                 Surt_run    = %trim(%subst(Route:pos-2:2));
              else;
                 Surt_route  = %trim(Route);
                 Surt_run    = *blanks;
              endif;

      // if route is an expedite route, leave it alone and make run = 01
             If %subst(route:1:3) = 'EX-';
                Surt_route = %trim(route);
                 Surt_run    = '01';
             EndIf;

      // if route is an expedite route, leave it alone and make run = 01
             If route  = 'EXPDIT';
                Surt_route = 'EX-EXPD';
                 Surt_run    = 'IT';
             EndIf;

             pos = %Scan( ' ': R2USNM);
             SuppTeamFirst = %trim(%subst(R2USNM:1:pos-1));
             SuppTeamLast = %trim(%subst(R2USNM:pos+1:20-pos));


       // Main Process Begins ...


         SetLL (SuppCd:SHID:STime:Route) AM#PL28;
         DoW NOT %eof(AM#PL28);

         ReadE (SuppCd:SHID:STime:Route) AM#PL28;

         If %eof(AM#PL28);
            Leave;
         EndIf;

         If R2SKJY <> *blank  OR R2HNTE <> 'OK' OR R2EXCD ='13';
            Iter;
         EndIf;

          exists= 'Y';


             SetLL (SuppCd:SHID:STime:Route:SaveORDN:SaveNAMC:SaveNUKE) AM#PL28;
             DoW  NOT  %eof(AM#PL28);
             ReadE (SuppCd:SHID:STime:Route:SaveORDN:SaveNAMC:SaveNUKE) AM#PL28;
                         If %eof(AM#PL28);
                            Leave;
                         EndIf;

                         If R2SKJY <> *blank  OR R2HNTE <> 'OK' OR R2EXCD='13';
                            Iter;
                         EndIf;

                     //  check for blowout recovery or expedite supplement...
                         If R2EXCD = '14' OR R2EXCD = '18' OR R2EXCD = '23';
                            SkEXCD(1) = R2EXCD;
                         Else;
                            SkEXCD(1) = *blanks;
                         EndIf;


             EndDo;

             SetGT (SuppCd:SHID:STime:Route:SaveORDN:SaveNAMC:SaveNUKE) AM#PL28;


          EndDo;


       *InLr = *On;
       Return;

             //  --------------------------------------------------------------------------
             //  Write to Error Log AM#PP63...
                  BegSr LogError;
                    JEDATE = %dec(%date());
                    JETIME = %dec(%time());
                    JEUSCD = worker;
                    JEPGM  = pgm;
                    JEEMSG = ErrMsg;
                     Write AM#PP631;
                  EndSr;

