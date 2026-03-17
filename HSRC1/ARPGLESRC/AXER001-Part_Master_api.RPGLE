      //=========================================================
      // AXER001
      // LEC          2023/04/12
      // Part Master api
      //=========================================================
      //

       ctl-opt  DFTACTGRP(*NO) PGMINFO(*PCML:*MODULE)
                Option(*SrcStmt:*NoDebugIO);

       dcl-f  FCEPL01  DISK(*EXT) USAGE(*INPUT) KEYED;
       dcl-f  AX#PP001 DISK(*EXT) USAGE(*OUTPUT) KEYED;

       dcl-s  bhb1      like(a2bhb1);
       dcl-s  bhb2      like(a2bhb2);
       dcl-s  bhb3      like(a2bhb3);
       dcl-s  #today  zoned(8:0);
       dcl-s  #now    zoned(6:0);
       dcl-s  MsgKey  char(4);
       dcl-s  MsgDta  varchar(1000);


       dcl-pr   RtvPartInfo  extpgm('AXER001');
                *N   Char(12);
                *N   Char(15);
                *N   Char(6);
                *N   Char(1);
                *N   Char(100);
       end-pr;

       dcl-pi   RtvPartInfo;
               partNo Char(12);
               partDesc Char(15);
               partLocn Char(6);
               errCode  Char(1);
               errMessage Char(100);
       end-pi;

       dcl-pr  QMHSNDPM ExtPgm;
         MessageID   char(7)  Const;
         QualMsgF    char(20) Const;
         MsgData     char(32767) Const  options(*varsize);
         MsgDtaLen   int(10)  Const;
         MsgType     char(10) Const;
         CallStkEnt  char(10) Const;
         CallStkCnt  int(10)  Const;
         MessageKey  char(4);
         ErrorCode   char(32767) options(*varsize);
       end-pr;

       dcl-ds  err qualified;
         bytesProv   int(10)inz(0);
         bytesAvail  int(10)inz(0);
       end-ds;


       dcl-ds pgm_stat PSDS;
              pgm    *PROC;
              status *STATUS;
              routine *ROUTINE;
              library CHAR(10) POS(81);
              user    CHAR(10) POS(254);
       end-ds;

       #today = %dec(%date():*iso);
       #now = %dec(%time():*hms);

      //
      //---------------------------------------------------//
      // check parts master file....

       bhb1 = %subst(partNo:1:5);
       bhb2 = %subst(partNo:6:5);
       bhb3 = %subst(partNo:11:2);

       chain (bhb1:bhb2:bhb3) FCEPL01;

          if %found(FCEPL01);

             if a2gskd = 'D';
               errMessage = 'Part Number Has Been Deleted';
               errCode = '1';
               MsgDta = errMessage;
             else;
               partDesc = a2smei;
               partLocn = a2strk + a2strt + a2strr + a2strd;
               errCode = '0';
             endif;

          else;
            errMessage = 'Part Number Not Found in Master';
               errCode = '1';
               MsgDta = errMessage;
          endif;

       exsr LogIt;

       if errCode = '1';
          QMHSNDPM('CPF9897':'QCPFMSG   *LIBL':msgdta:%len(msgdta):'*ESCAPE'
          :'*PGMBDY':1:MsgKey:err );
       endif;

       *InLr = *on;
       Return;

      //
      //---------------------------------------------------//
      //  write to log file...
       BegSr LogIt;
         L1DATE = #today;
         L1TIME = #now;
         L1PART = partNo;
         L1DESC = partDesc;
         L1LOCN = partLocn;
         L1EMSG = errMessage;
         Write AX#PP001R;
       EndSr;
