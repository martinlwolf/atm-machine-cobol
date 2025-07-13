      ******************************************************************
      * Author:
      * Date:
      * Purpose:
      * Tectonics: cobc
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. YOUR-PROGRAM-NAME.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT TRANS-FILE ASSIGN TO "TRANSACTIONS.txt"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS TRANSF-STATUS.
           SELECT ACCOUNTS-FILE ASSIGN TO "ACCOUNTS.DAT"
               ORGANIZATION IS INDEXED
               ACCESS MODE IS DYNAMIC
               RECORD KEY IS FS-CBU
               FILE STATUS IS ACCOUNTSF-STATUS.
       DATA DIVISION.
       FILE SECTION.
       FD  TRANS-FILE.
       01  TRANS-RECORD.
           05 TF-RECIPIENT-CBU         PIC 9(22).
           05 TF-DESTINATION-USERNAME  PIC A(35).
           05 TF-DESTINATION-CBU       PIC 9(22).
           05 TF-AMOUNT                PIC 9(20).
           05 TF-DATE                  PIC X(8).

       FD  ACCOUNTS-FILE.
       01  ACCOUNTS-RECORD.
           05 FS-CBU                    PIC 9(22).
           05 FS-USERNAME               PIC A(35).
           05 FS-BALANCE                PIC 9(20).
           05 FS-PIN                    PIC 9(04).

       WORKING-STORAGE SECTION.

       01  FS-STATUS.
           05 TRANSF-STATUS                PIC 9(2).
           05 ACCOUNTSF-STATUS             PIC 9(2).

       01  WS-AREAS.
           05 WS-INPUTS.
               10 WS-INPUT-PIN             PIC 9(04).
               10 WS-INPUT-MENU            PIC 9(01).
               10 WS-INPUT-CBU             PIC 9(22).
               10 WS-INPUT-TRANSFER-TO-CBU PIC 9(22).
           05 WS-FLAG-LOGIN                PIC A(01) VALUE "N".
               88 WS-LOGGED                VALUE "Y".
               88 WS-NOT-LOGGED            VALUE "N".
           05 WS-PIN-SECURITY-COUNT        PIC 9(01) VALUE 1.
           05 WS-USER-POINTERS.
               10 WS-USER-POINTER          PIC 9(01) VALUE ZERO.
               10 WS-TRANSFER-POINTER      PIC 9(01) VALUE ZERO.
           05 WS-WITHDRAW-OPTION           PIC 9(01) VALUE ZERO.
           05 WS-TRANSACTION-OPTION        PIC 9(01) VALUE ZERO.
           05 WS-AMOUNTS.
               10 WS-TRANSFER-AMOUNT       PIC 9(22) VALUE ZERO.
               10 WS-WITHDRAW-AMOUNT       PIC 9(6) VALUE ZERO.
               10 WS-CASH-MODULE-AMOUNT    PIC 9(6) VALUE ZERO.
               10 WS-DEPOSIT-AMOUNT        PIC 9(22) VALUE ZERO.
           05 WS-PIN-MODIFIER              PIC 9(04).
           05 WS-BALANCE-DISPLAY           PIC $ZZZZZZZZZZZZZZZZZZ.99.

       01  WS-TRANSACTIONS.
           05 WS-TRANS OCCURS 5 TIMES
               INDEXED BY IDX-TRANS.
               10 WS-RECIPIENT-CBU         PIC 9(22).
               10 WS-DESTINATION-USERNAME  PIC A(35).
               10 WS-DESTINATION-CBU       PIC 9(22).
               10 WS-AMOUNT                PIC 9(20).
               10 WS-DATE                  PIC X(8).

       01  WS-TEMP-USERS-FOR-TRANSACTIONS.
           05 WS-TEMP-RECIPIENT-CBU        PIC 9(22).
           05 WS-TEMP-RECIPIENT-USERNAME   PIC A(35).
           05 WS-TEMP-RECIPIENT-BALANCE    PIC 9(20).
           05 WS-TEMP-DESTINATION-CBU      PIC 9(22).
           05 WS-TEMP-DESTINATION-USERNAME PIC A(35).
           05 WS-TEMP-DESTINATION-BALANCE  PIC 9(20).


       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
           DISPLAY "ATM MACHINE"
           DISPLAY "ENTER YOUR CBU"
           ACCEPT WS-INPUT-CBU.
           PERFORM 010-LOG-IN THRU 010-END
           PERFORM 020-MENU THRU 020-END
           STOP RUN.

       010-LOG-IN.
           OPEN I-O ACCOUNTS-FILE

           MOVE WS-INPUT-CBU TO FS-CBU
           READ ACCOUNTS-FILE
               INVALID KEY
                   DISPLAY "ACCOUNT NOT FOUND"
                   CLOSE ACCOUNTS-FILE
                   STOP RUN
               NOT INVALID KEY
                   PERFORM 140-CHECK-PIN THRU 140-END UNTIL WS-LOGGED.
       010-END.EXIT.


       140-CHECK-PIN.

           IF WS-PIN-SECURITY-COUNT LESS OR EQUAL 3
               DISPLAY "ENTER YOUR 4-DIGIT PIN"
               ACCEPT WS-INPUT-PIN
               IF WS-INPUT-PIN NOT EQUAL FS-PIN
                   DISPLAY "Invalid PIN"
                   ADD 1 TO WS-PIN-SECURITY-COUNT
               ELSE
                   DISPLAY "Welcome: " FS-USERNAME
                   SET WS-LOGGED TO TRUE
           ELSE
               DISPLAY "MAX ATTEMPTS REACHED"
               STOP RUN
           END-IF.
       140-END.EXIT.

       020-MENU.
           DISPLAY "---------------------------------------------------"
           DISPLAY "SELECT AN OPTION"
           DISPLAY "1.CHECK BALANCE"
           DISPLAY "2.WITHDRAW FUNDS"
           DISPLAY "3.DEPOSIT FUNDS"
           DISPLAY "4.MODIFY PIN"
           DISPLAY "5.TRANSACTIONS"
           DISPLAY "6.EXIT"
           ACCEPT WS-INPUT-MENU

           EVALUATE WS-INPUT-MENU
               WHEN 1
                   PERFORM 030-DISPLAY-BALANCE THRU 030-END
               WHEN 2
                   PERFORM 040-WITHDRAWAL-MENU THRU 040-END
               WHEN 3
                   PERFORM 050-DEPOSIT THRU 050-END
               WHEN 4
                   PERFORM 060-MODIFY-PIN THRU 060-END
               WHEN 5
                   PERFORM 070-TRANSACTIONS THRU 070-END
               WHEN 6
                   PERFORM 080-ATM-EXIT THRU 080-END
               WHEN OTHER
                   DISPLAY "INCORRECT OPTION"
                   PERFORM 020-MENU THRU 020-END.
       020-END.EXIT.

       030-DISPLAY-BALANCE.
           MOVE FS-BALANCE TO WS-BALANCE-DISPLAY
           DISPLAY "Current balance is: " WS-BALANCE-DISPLAY
           PERFORM 020-MENU THRU 020-END.
       030-END.EXIT.

       040-WITHDRAWAL-MENU.
           DISPLAY "Select an amount"
           DISPLAY "1.10"
           DISPLAY "2.20"
           DISPLAY "3.50"
           DISPLAY "4.100"
           DISPLAY "5.500"
           DISPLAY "6.Other"
           DISPLAY "7.BACK"
           ACCEPT WS-WITHDRAW-OPTION

           EVALUATE WS-WITHDRAW-OPTION
               WHEN 1
                   MOVE 10 TO WS-WITHDRAW-AMOUNT
               WHEN 2
                   MOVE 20 TO WS-WITHDRAW-AMOUNT
               WHEN 3
                   MOVE 50 TO WS-WITHDRAW-AMOUNT
               WHEN 4
                   MOVE 100 TO WS-WITHDRAW-AMOUNT
               WHEN 5
                   MOVE 500 TO WS-WITHDRAW-AMOUNT
               WHEN 6
                   DISPLAY "Enter an amount:"
                   ACCEPT WS-WITHDRAW-AMOUNT
                   IF WS-WITHDRAW-AMOUNT > 99999
                       DISPLAY "Amount musn't be higher than $100.000"
                       PERFORM 040-WITHDRAWAL-MENU THRU 040-END
                   ELSE IF WS-WITHDRAW-AMOUNT < 0
                       DISPLAY "Amount musn't be NEGATIVE"
                       PERFORM 040-WITHDRAWAL-MENU THRU 040-END
               WHEN 7
                   PERFORM 020-MENU THRU 020-END
               WHEN OTHER
                   DISPLAY "INCORRECT OPTION"
                   PERFORM 040-WITHDRAWAL-MENU THRU 040-END
           END-EVALUATE

           PERFORM 090-WITHDRAW THRU 090-END.

       040-END.EXIT.

       050-DEPOSIT.
           DISPLAY "Please deposit the cash into the ATM machine."
           DISPLAY "The amount must be less than $50,000."
           ACCEPT WS-DEPOSIT-AMOUNT
           IF WS-DEPOSIT-AMOUNT LESS OR EQUAL 50000
               ADD WS-DEPOSIT-AMOUNT TO FS-BALANCE

               REWRITE ACCOUNTS-RECORD
               INVALID KEY
                   DISPLAY "System failure. Please try later"
               END-REWRITE

               PERFORM 030-DISPLAY-BALANCE THRU 030-END
               PERFORM 020-MENU THRU 020-END
           ELSE
               DISPLAY "The amount exceeds the maximum deposit limit."
               PERFORM 020-MENU THRU 020-END
           END-IF.
       050-END.EXIT.

       060-MODIFY-PIN.
           DISPLAY "You are modifying your PIN"
           DISPLAY "Enter your current PIN"
           ACCEPT WS-PIN-MODIFIER

           IF WS-PIN-MODIFIER EQUALS FS-PIN
               DISPLAY "Enter the new PIN"
               ACCEPT WS-PIN-MODIFIER
               DISPLAY "Enter the new PIN again"
               ACCEPT WS-INPUT-PIN
               IF WS-INPUT-PIN EQUALS WS-PIN-MODIFIER
                   MOVE WS-INPUT-PIN TO FS-PIN

                   REWRITE ACCOUNTS-RECORD
                   INVALID KEY
                   DISPLAY "System failure. Please try later"
                   END-REWRITE

                   DISPLAY "The PIN has been changed"
                   PERFORM 020-MENU THRU 020-END
               ELSE
                   DISPLAY "PINs don't match"
                   PERFORM 060-MODIFY-PIN THRU 060-END
               END-IF
           ELSE
               DISPLAY "Incorrect PIN"
               PERFORM 020-MENU THRU 020-END
           END-IF.
       060-END.EXIT.

       070-TRANSACTIONS.
           DISPLAY "Select an option"
           DISPLAY "1. Make a transfer (CBU)"
           DISPLAY "2. View last five transactions"
           DISPLAY "3. Go back"
           ACCEPT WS-TRANSACTION-OPTION

           EVALUATE WS-TRANSACTION-OPTION
               WHEN 1
                   PERFORM 100-CHECK-AND-TRANSFER THRU 100-END
                   PERFORM 020-MENU THRU 020-END
               WHEN 2
                   PERFORM 110-LAST-TRANSACTIONS THRU 110-END
                   PERFORM 020-MENU THRU 020-END
               WHEN 3
                   PERFORM 020-MENU THRU 020-END
               WHEN OTHER
                   DISPLAY "Select a valid option".


       070-END.EXIT.

       080-ATM-EXIT.
           DISPLAY "Thank you for using our service".
           STOP RUN.
       080-END.EXIT.

       090-WITHDRAW.
      *    Ensure the user's balance is enough for the requested withdrawal.
           IF WS-WITHDRAW-AMOUNT <= FS-BALANCE
      *    Cash module checks if the atm has enough cash
               MOVE WS-WITHDRAW-AMOUNT TO WS-CASH-MODULE-AMOUNT
               CALL 'CASH-MODULE' USING
               BY REFERENCE WS-CASH-MODULE-AMOUNT
               IF WS-CASH-MODULE-AMOUNT > 0
               PERFORM 040-WITHDRAWAL-MENU THRU 040-END
               END-IF

               COMPUTE FS-BALANCE =
               FS-BALANCE - WS-WITHDRAW-AMOUNT

               REWRITE ACCOUNTS-RECORD
               INVALID KEY
                   DISPLAY "System failure. Please try later"
               END-REWRITE

               MOVE FS-BALANCE TO WS-BALANCE-DISPLAY
               DISPLAY "The new balance is:" WS-BALANCE-DISPLAY
               PERFORM 020-MENU THRU 020-END
           ELSE
               DISPLAY "Not enough money. Select another amount"
               PERFORM 040-WITHDRAWAL-MENU THRU 040-END.
       090-END.EXIT.

       100-CHECK-AND-TRANSFER.
           DISPLAY "Enter 22-digit CBU"
           ACCEPT WS-INPUT-TRANSFER-TO-CBU

           IF WS-INPUT-TRANSFER-TO-CBU = FS-CBU
               DISPLAY "You cannot transfer to your own account"
               PERFORM 070-TRANSACTIONS THRU 070-END
           END-IF
      *    Temporary saving recipient data to transfer
           MOVE FS-CBU TO WS-TEMP-RECIPIENT-CBU
           MOVE FS-USERNAME TO WS-TEMP-RECIPIENT-USERNAME
           MOVE FS-BALANCE TO WS-TEMP-RECIPIENT-BALANCE

           MOVE WS-INPUT-TRANSFER-TO-CBU TO FS-CBU
           READ ACCOUNTS-FILE
               INVALID KEY
                   DISPLAY "Invalid CBU"
      *    To retain the current user's account information in the record
                   MOVE WS-INPUT-CBU TO FS-CBU
                   READ ACCOUNTS-FILE
                   PERFORM 070-TRANSACTIONS THRU 070-END

               NOT INVALID KEY
      *    Temporary saving destination data to transfer
                   MOVE FS-CBU TO WS-TEMP-DESTINATION-CBU
                   MOVE FS-USERNAME TO WS-TEMP-DESTINATION-USERNAME
                   MOVE FS-BALANCE TO WS-TEMP-DESTINATION-BALANCE.
                   PERFORM 120-TRANSFER THRU 120-END.

       100-END.EXIT.

       110-LAST-TRANSACTIONS.
           DISPLAY "Showing last five transactions done:"
           CALL 'LAST-TRANSACTIONS' USING
               BY CONTENT      FS-CBU
               BY REFERENCE    WS-TRANSACTIONS
           SET IDX-TRANS TO 1
           PERFORM UNTIL IDX-TRANS > 5
           IF NOT (WS-DESTINATION-CBU(IDX-TRANS) = 0)
               DISPLAY "DESTINATION: "WS-DESTINATION-USERNAME(IDX-TRANS)
               DISPLAY "CBU: " WS-DESTINATION-CBU(IDX-TRANS)
               DISPLAY "AMOUNT: " WS-AMOUNT(IDX-TRANS)
               DISPLAY "DATE: " WS-DATE(IDX-TRANS)
               DISPLAY "-----------------------------------------------"
           END-IF
               ADD 1 TO IDX-TRANS
           END-PERFORM
           SET IDX-TRANS TO 0.
       110-END.EXIT.

       120-TRANSFER.
           DISPLAY "Enter an amount to transfer to "
           FS-USERNAME
           ACCEPT WS-TRANSFER-AMOUNT

           IF WS-TRANSFER-AMOUNT <= WS-TEMP-RECIPIENT-BALANCE
               COMPUTE WS-TEMP-DESTINATION-BALANCE =
               WS-TEMP-DESTINATION-BALANCE + WS-TRANSFER-AMOUNT
               COMPUTE WS-TEMP-RECIPIENT-BALANCE =
               WS-TEMP-RECIPIENT-BALANCE - WS-TRANSFER-AMOUNT
               PERFORM 130-TRANSFER-LOG THRU 130-END
               PERFORM 030-DISPLAY-BALANCE THRU 030-END
           ELSE
               DISPLAY "Not enough money. Select another amount"
      *    To retain the current user's account information in the record
               MOVE WS-INPUT-CBU TO FS-CBU
               READ ACCOUNTS-FILE
               PERFORM 070-TRANSACTIONS THRU 070-END
           END-IF.
       120-END.EXIT.

       130-TRANSFER-LOG.
           OPEN EXTEND TRANS-FILE
           IF TRANSF-STATUS NOT = 00
               DISPLAY "TRANSFERENCIES ARE UNAVAILABLE"
               DISPLAY "FS-STATUS: " FS-STATUS
               STOP RUN
           END-IF

      *    Saving log data on local memory, not writing yet to ensure consistency
           MOVE WS-TEMP-RECIPIENT-CBU TO TF-RECIPIENT-CBU
           MOVE WS-TEMP-DESTINATION-USERNAME TO TF-DESTINATION-USERNAME
           MOVE WS-TEMP-DESTINATION-CBU TO TF-DESTINATION-CBU
           MOVE WS-TRANSFER-AMOUNT TO TF-AMOUNT
           MOVE FUNCTION CURRENT-DATE TO TF-DATE.

      *    Rewriting updated destination user data
           MOVE WS-TEMP-DESTINATION-CBU TO FS-CBU
           MOVE WS-TEMP-DESTINATION-USERNAME TO FS-USERNAME
           MOVE WS-TEMP-DESTINATION-BALANCE TO FS-BALANCE
           REWRITE ACCOUNTS-RECORD
               INVALID KEY
                   DISPLAY "System failure. Please try later"
                   PERFORM 020-MENU THRU 020-END
               END-REWRITE

      *    Rewriting updated recipient user data
           MOVE WS-TEMP-RECIPIENT-CBU TO FS-CBU
           READ ACCOUNTS-FILE
               INVALID KEY
                   DISPLAY "System failure. Please try later"
                   PERFORM 020-MENU THRU 020-END
               NOT INVALID KEY
                   MOVE WS-TEMP-RECIPIENT-USERNAME TO FS-USERNAME
                   MOVE WS-TEMP-RECIPIENT-BALANCE TO FS-BALANCE
           REWRITE ACCOUNTS-RECORD
               INVALID KEY
                   DISPLAY "System failure. Please try later"
                   PERFORM 020-MENU THRU 020-END
               END-REWRITE.

      *    Finally writing on log transferencies file
           WRITE TRANS-RECORD

           CLOSE TRANS-FILE.

       130-END.EXIT.
       END PROGRAM YOUR-PROGRAM-NAME.
