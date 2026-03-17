
      **************************************************************
      * Read a text file on the IFS                                *
      * ---------------------------------------------------------- *
      *  Maintenance:                                              *
      *  Mod#    Pgmr       Date        Description                *
      * ---------------------------------------------------------- *
      **************************************************************
       ctl-opt debug  indent('. ') option(*srcstmt: *nodebugio)
       dftactgrp(*no);

       dcl-pr OpenFile int(10) extproc('open');
          *n pointer value options(*string);
          *n int(10) value;
          *n uns(10) value options(*nopass);
          *n uns(10) value options(*nopass);
          *n uns(10) value options(*nopass);
       end-pr ;

       dcl-pr ReadFile int(10) extproc('read');
          *n int(10) value;
          *n pointer value;
          *n uns(10) value;
       end-pr ;

       dcl-pr CloseFile int(10) extproc('close') ;
          *n  int(10) value ;
       end-pr ;

       dcl-pr QCMDEXC extpgm('QCMDEXC');
          *n char(3000) options(*varsize) const;
          *n packed(15:5) const;
       end-pr ;


      //-------------------------------------*
      // Declare File Fields
      //-------------------------------------*
       dcl-c O_RDONLY 1;           //Read only
       dcl-c O_TEXTDATA 16777216;  //Open in text mode
       dcl-c O_CCSID 32;           //CCSID
       dcl-c S_IRGRP 32;           //Group authority

       dcl-s fd int(10);
       dcl-s Length int(10);
       dcl-s Data char(200);
       dcl-s Array char(200) dim(50);
       dcl-s elm packed(3);
       dcl-s Start packed(3);
       dcl-s End like(Start);

      //-------------------------------------*
      // Work Fields
      //-------------------------------------*
       dcl-s OFF   ind inz('0');
       dcl-s ON    ind inz('1');
       dcl-s YES   ind inz('1');
       dcl-s NO    ind inz('0');
       dcl-c QUOTE  const(x'7D');
       dcl-c CRLF x'0D25';  // Carriage Return + Line Feed
       dcl-s exitLoop ind inz('0');

       dcl-s Path char(500);
       dcl-s errMsg char(200) inz(' ');
       dcl-s currentLine char(200);

       dcl-s aryStr200 char(200) dim(7) inz;
       dcl-s fnd char(1) inz;
       dcl-s sendMsg ind inz('0');


       // CSV field variables
       dcl-s lineNumber int(10);
       dcl-s message varchar(200);
       dcl-s severity packed(3:0);
       dcl-s jobNumber packed(6:0);
       dcl-s jobName varchar(10);
       dcl-s userName varchar(10);
       dcl-s itUsers varchar(55) inz;


       //------------
       //Code area *
       //------------
       // I0775 Mark Snyder, I0777 Kaz Watanabe, I0779 George Alderton
       itUsers = 'I0775 I0777 I0779';
0
       exec sql set option naming = *sys,commit = *none,usrprf = *user,
        dynusrprf = *user, datfmt = *iso, closqlcsr = *endmod;

       // Run the java program to read the QSYSOPR message queue
       // and write to the CSV file before attempting to read the file
       ExecuteJavaMsgQ();

       // Set the IFS file path
       path = '/home/I0775/Code/qsysopr.csv';

       // attempt to open the file
       fd = openFile(%trim(Path):
          O_RDONLY + O_TEXTDATA + O_CCSID:S_IRGRP:37);

       if (fd < 0) ;
          errMsg = 'IFS file ' + %trim(path) + ' could not be opened';
          *inlr = *on;
         return;
       endif;

       // Read through the file
       dow not exitLoop;
          Length  = ReadFile(fd:%addr(Data):%size(Data)) ;
          if (Length <= 0) ;
             exitloop = YES;
          elseif (Length < %size(Data)) ;
             %subst(Data:(length + 1)) = ' ' ;
          endif;

          Start = 0 ;
          exitLoop = NO;

          // read the lines
          // elm is the element (character position) in the Array
          dow not exitLoop and length > 0 ;
             elm += 1 ;
             End = %scan(x'25':Data:(Start + 1)) ;
             if (End > 0) ;

                if (Array(elm) = ' ') ;
                   Array(elm) = %subst(Data:(Start + 1):((End-Start) - 1));
                else;
                   Array(elm) = %trimr(Array(elm)) +
                   %subst(Data:(Start + 1):((End - Start) - 1)) ;
                endif ;
                currentLine = Array(elm);
                ProcessCSV();
                Start = End ;
             else ;
                Array(elm) = %subst(Data:(Start + 1)) ;
                currentLine = Array(elm);
                ProcessCSV();
                elm -= 1 ;
                exitLoop = YES;
             endif ;
          enddo ;
       enddo ;

       fd = CloseFile(fd) ;
       *inlr = *on ;

       // ==================================
       // Process the CSV data in the Array
       // ==================================
       dcl-proc ProcessCSV;
         dcl-s emailTo varchar(100) inz;

         // Are there messages to process?
         if %trim(currentLine) = '***-No Messages' or
           CountCommas(currentLine) < 5;
           return;
         endif;

         // Assuming the CSV format is: lineNumber,severity,message,jobNumber,jobName,userName
         aryStr200 = %split(currentLine: ',');

         lineNumber = %dec(aryStr200(1): 10: 0);
         severity = %dec(aryStr200(2): 3: 0);
         message = %trim(aryStr200(3));
         jobNumber = %dec(aryStr200(4): 6: 0);
         jobName = %trim(aryStr200(5));
         userName = %trim(aryStr200(6));


         // Some messages that can be skipped (e.g. QSYSOPR messages about the Java program itself)
         if %scan('SET TAPE':message) > 0;
           return;
         endif;


         // verify that this message for this job has not been logged before by
         // checking against the QMSGLOGPF file.
         sendMsg = NO;
         fnd = 'N';
         exec sql
         select 'Y' into :fnd
         from QMSGLOGPF
         where  jobNumber = :jobNumber and jobName = :jobName
         and userName = :userName;
         if (fnd = 'N');
            sendMsg = YES;
            // insert the message into QMSGLOGPF
            exec sql
            insert into QMSGLOGPF
            (severity, message, jobNumber, jobName, userName,created)
            values
            (:severity, :message, :jobNumber, :jobName, :userName,
             current_timestamp);

            if %scan(userName: itUsers) = 0;
              // Send email alert for new message
              emailTo = 'mark.snyder@iafi.com';
              SendEmailAlert(emailTo);

              emailTo = 'jonathon.julson@iafi.com';
              SendEmailAlert(emailTo);

              emailTo = 'Kaz.Watanabe@iafi.com';
              SendEmailAlert(emailTo);

              emailTo = 'George.Alderton@iafi.com';
              SendEmailAlert(emailTo);
            else;
              Select;
                  when %trim(userName) = 'I0775';
                    emailTo = 'Mark.Snyder@iafi.com';
                  when %trim(userName) = 'I0777';
                    emailTo = 'Kaz.Watanabe@iafi.com';
                  when %trim(userName) = 'I0779';
                    emailTo = 'George.Alderton@iafi.com';
              endsl;
              SendEmailAlert(emailTo);
            endif;

         endif;
         end-Proc;

       // ==================================
       // Send Email Alert
       // ==================================
       dcl-proc SendEmailAlert;
         dcl-pi *n;
           pEmailTo varchar(100);
         end-pi;

         dcl-s emailBody varchar(1000);
         dcl-s emailSubject varchar(100);
         dcl-s cmdString varchar(3000);
         dcl-s cmdLen packed(15:5);
         emailSubject = 'Alert - Unanswered QSYSOPR Message';

         // Build email body with message details
         emailBody = 'A new QSYSOPR message requires attention:' +
                       CRLF +
                     'Severity: ' + %char(severity) +  CRLF + CRLF +
                     'Message: ' + %trim(message) +  CRLF + CRLF +
                     'Job Number: ' + %char(jobNumber) +  CRLF +
                     'Job Name: ' + %trim(jobName) +  CRLF +
                     'User Name: ' + %trim(userName) +  CRLF +
                      CRLF +
                     'Please review and respond to this message.';

         // Build and execute SNDSMTPEMM command
         cmdString = 'SNDSMTPEMM RCP((~' + %trim(pEmailTo) + '~)) ' +
                     'SUBJECT(~' + %trim(emailSubject) + '~) ' +
                     'NOTE(~' + %trim(emailBody) + '~)';

         cmdString = %scanrpl('~':QUOTE:cmdString);
         cmdLen = %len(%trim(cmdString));

         monitor;
           QCMDEXC(cmdString: cmdLen);
         on-error;
           errMsg = 'Email send failed via SNDSMTPEMM';
         endmon;

       end-Proc;

       // ==================================
       // Execute Java Message Queue Program
       // ==================================
       dcl-proc ExecuteJavaMsgQ;
         dcl-s javaCmd varchar(1000);
         dcl-s javaCmdLen packed(15:5);

         // Build RUNJVA command to execute msgQ.class
         javaCmd =
           'RUNJVA CLASS(msgQ) +
             CLASSPATH(''/home/I0775/Code:/home/I0775/Code/jt400.jar'') +
                    OUTPUT(* *CONTINUE)';
         javaCmdLen = %len(%trim(javaCmd));

         // Execute the Java program
         monitor;
           QCMDEXC(javaCmd: javaCmdLen);
         on-error;
           errMsg = 'Failed to execute Java msgQ program';
         endmon;

       end-Proc;

       // ==================================
       // Count Commas in String
       // ==================================
       dcl-proc CountCommas;
         dcl-pi *n int(10);
           inputString char(1000) const;
         end-pi;

         dcl-s commaCount int(10) inz(0);
         dcl-s position int(10) inz(1);

         dow position > 0;
           position = %scan(',': inputString: position);
           if position > 0;
             commaCount += 1;
             position += 1;  // Move past the found comma
           endif;
         enddo;

         return commaCount;
       end-proc;


