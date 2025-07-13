      ******************************************************************
      * Author:
      * Date:
      * Purpose:
      * Tectonics: cobc
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. LAST-TRANSACTIONS.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT TRANS-FILE ASSIGN TO "TRANSACTIONS.txt"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS FS-STATUS.
       DATA DIVISION.
       FILE SECTION.
       FD  TRANS-FILE.
       01  TRANS-RECORD.
           05 FS-RECIPIENT-CBU         PIC 9(22).
           05 FS-DESTINATION-USERNAME  PIC A(35).
           05 FS-DESTINATION-CBU       PIC 9(22).
           05 FS-AMOUNT                PIC 9(20).
           05 FS-DATE                  PIC X(8).
       WORKING-STORAGE SECTION.
       01  FS-STATUS               PIC 9(2).
       01  WS-OCURRENCIES          PIC 9(2).
       01  WS-START-POINT          PIC 9(2).
       01  IDX                     PIC 9(2).

       LINKAGE SECTION.
       01  LK-CBU                   PIC 9(22).
       01  LK-TRANSACTIONS.
           05 LK-TRANS OCCURS 5 TIMES
               INDEXED BY LK-IDX.
               10 LK-RECIPIENT-CBU         PIC 9(22).
               10 LK-DESTINATION-USERNAME  PIC A(35).
               10 LK-DESTINATION-CBU       PIC 9(22).
               10 LK-AMOUNT                PIC 9(20).
               10 LK-DATE                  PIC X(8).
       PROCEDURE DIVISION USING LK-CBU LK-TRANSACTIONS.
       MAIN-PROCEDURE.
           PERFORM 010-OCURRENCIES THRU 010-END
           PERFORM 020-LAST-TRANSACTIONS THRU 020-END
           EXIT PROGRAM.

       010-OCURRENCIES.
           OPEN INPUT TRANS-FILE
            IF NOT FS-STATUS = 00
                DISPLAY "ERROR"
                DISPLAY FS-STATUS
                EXIT PROGRAM
            END-IF.

            PERFORM UNTIL FS-STATUS = "10"
               READ TRANS-FILE
                   AT END
                       MOVE 10 TO FS-STATUS
                   NOT AT END
                       IF FS-RECIPIENT-CBU = LK-CBU
                           ADD 1 TO WS-OCURRENCIES
               END-READ
            END-PERFORM
           CLOSE TRANS-FILE.
       010-END.EXIT.

       020-LAST-TRANSACTIONS.
           OPEN INPUT TRANS-FILE
            IF NOT FS-STATUS = 00
                DISPLAY "ERROR"
                DISPLAY FS-STATUS
                EXIT PROGRAM
            END-IF.

           COMPUTE WS-START-POINT = FUNCTION MAX(1, WS-OCURRENCIES - 5)
           MOVE 0 TO WS-OCURRENCIES
           SET LK-IDX TO 1

            PERFORM UNTIL FS-STATUS = "10"
               READ TRANS-FILE
                   AT END
                       MOVE 10 TO FS-STATUS
                   NOT AT END
                       IF FS-RECIPIENT-CBU = LK-CBU
                           ADD 1 TO WS-OCURRENCIES
                           IF WS-OCURRENCIES >= WS-START-POINT
                               MOVE FS-RECIPIENT-CBU
                               TO LK-RECIPIENT-CBU(LK-IDX)
                               MOVE FS-DESTINATION-USERNAME
                               TO LK-DESTINATION-USERNAME(LK-IDX)
                               MOVE FS-DESTINATION-CBU
                               TO LK-DESTINATION-CBU(LK-IDX)
                               MOVE FS-AMOUNT
                               TO LK-AMOUNT(LK-IDX)
                               MOVE FS-DATE
                               TO LK-DATE(LK-IDX)
                               SET LK-IDX UP BY 1
                           END-IF
                       END-IF
               END-READ
            END-PERFORM
            CLOSE TRANS-FILE.

       020-END.EXIT.
       END PROGRAM LAST-TRANSACTIONS.
