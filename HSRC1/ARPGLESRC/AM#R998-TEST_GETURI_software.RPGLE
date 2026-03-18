     HDFTACTGRP(*NO) ACTGRP('GETURI') BNDDIR('GETURI')

       // Imports
      /COPY GETURI/QCOPYSRC,GETURICOPY
      /COPY GETURI/QCOPYSRC,P.GETURI

      /free

        // Work Variables

       dcl-s rc int(10);
       dcl-s response varchar(65535);
       dcl-s head varchar(65535);
       dcl-s msgcd char(1);
       dcl-s msg varchar(65535);
       dcl-s errMsg char(256);
       dcl-s contentType varchar(65535);

       #geturi_resetValues();
       #geturi_setValue('gi_uri':'https://api.toyota.com/tmna/prod/Logistics/v/+
                        SupplierOrderInformation/trailer');
       #geturi_setValue('gi_outtype':'*STMF');
       #geturi_setValue('gi_ContType':'application/json');
       #geturi_setValue('gi_Data':'*STMF');
       #geturi_setValue('gi_DStmf':'/qntc/IAF-AS400-FILE/AS400-TRANS/+
                       PC/Upload/jsontest/JSONtest.txt');
       #geturi_setValue('gi_port':'443');
       #geturi_setValue('gi_ReqMeth':'POST');
       #geturi_setValue('gi_Accept':'application/json');
       #geturi_setValue('gi_HTTPVer':'1.1');
       #geturi_setValue('gi_stmf':'/toyota/scs/json/results/output.txt');
       #geturi_setValue('gi_buser':'55a9d21f-a8db-4477-952c-235fd144921d');
       #geturi_setValue('gi_bpw':'cC5eV6jC4lG4mG6hB1nS6xN2gO8mH1gJ0fH8dR6gW+
                        6pA6bW6jI');
       #geturi_setValue('gi_ssl':'*YES');
       #geturi_setValue('gi_debug':'*YES');
       rc = #geturi_call(GetUri_Out:GetUri_Head:GetUri_MsgCd:GetUri_Msg:errMsg);

         *InLR = *On;
         Return;

      /end-free
