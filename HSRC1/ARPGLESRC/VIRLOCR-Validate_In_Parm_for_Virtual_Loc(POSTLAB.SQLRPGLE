

      **************************************************************
      * Receive a Scan Result (CHAR(512) from ALCR12 and scan file *
      * POSTLABEL (BARCODETEXT) for m match and if Found return    *
      * that Verified Location                                     *
      * ---------------------------------------------------------- *
      *  Maintenance:                                              *
      *  Mod#    Pgmr       Date        Description                *
      * ---------------------------------------------------------- *
      **************************************************************
       ctl-opt debug  indent('. ') option(*srcstmt: *nodebugio)
       dftactgrp(*no) bnddir('RDB2000');


        exec sql set option naming = *sys,commit = *none,usrprf = *user,
          dynusrprf = *user, datfmt = *iso, closqlcsr = *endmod;

        // Paramteres
        dcl-pi *n;
           parm512 char(256);
           parmReply char(01);
        end-pi;

        // Questions
        dcl-s YES ind inz('1');
        dcl-s NO ind inz('0');
        dcl-s inError ind inz;
        dcl-c QUOTE  const(x'7D');


        // Work Fields
        dcl-s parmCount zoned(1:0) inz;
        dcl-s reply char(1) inz('N');
        dcl-s sqlText varchar(200) inz;

        // Code
        parmCount = %parms;
        init();

        if not inError;
          sqlText = 'SELECT ~Y~ ' +
                     'FROM postLabel ' +
                     'WHERE barcodeTxt = ~' + %trim(parm512)  + '~';
          sqlText = %scanrpl('~':QUOTE:sqlText);

          exec SQL prepare sqlStmt from :sqlText;
          exec SQL declare c1 cursor for sqlStmt;
          exec SQL open c1;
          exec SQL fetch next from c1 into :reply;
          if sqlCode = 0 and reply = 'Y'  ;
              parmReply = 'Y';
            else;
              parmReply = 'N';
          endif;
        endif;

         *inlr = '1';
         return;

         // Init procedure to clear the target table before loading new data
         dcl-proc init;
            exec sql
              delete from VIRLOCR;
           // Did I get the all the parameters?
           if parmCount <> 2;
             inError = YES;
             reply = 'E';
           endif;


         end-proc;




