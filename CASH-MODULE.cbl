      ******************************************************************
      * Author:
      * Date:
      * Purpose:
      * Tectonics: cobc
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. CASH-MODULE.
        ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT CASH-FILE ASSIGN TO "CASH-MODULE.txt"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS FS-STATUS.
       DATA DIVISION.
       FILE SECTION.
       FD  CASH-FILE.
       01  CASH-RECORD.
           05 FS-CASH-DENOMINATION     PIC 9(3).
           05 FS-CASH-QUANTITY         PIC 9(5).

       WORKING-STORAGE SECTION.
       01  WS-CASH-MODULE.
           05 WS-CASH OCCURS 6 TIMES
               INDEXED BY IDX-CASH.
               10 WS-CASH-DENOMINATION     PIC 9(3).
               10 WS-CASH-QUANTITY         PIC 9(5).
           05 FS-STATUS                    PIC 9(2).

           LINKAGE SECTION.
       01  LK-WITHDRAW-AMOUNT              PIC 9(6).

       PROCEDURE DIVISION USING LK-WITHDRAW-AMOUNT.
       MAIN-PROCEDURE.
           DISPLAY "LO QUE LLEGA EN MODULE" LK-WITHDRAW-AMOUNT
           PERFORM 010-LOAD-FILE THRU 010-END
           PERFORM 020-ALGORITHM THRU 020-END
           EXIT PROGRAM.


       010-LOAD-FILE.
           OPEN INPUT CASH-FILE
           IF FS-STATUS NOT = 00
               DISPLAY "Error reading cash-file"
               DISPLAY "FS-STATUS: " FS-STATUS
               STOP RUN
           END-IF

           SET IDX-CASH TO 1
           PERFORM UNTIL FS-STATUS = 10
               READ CASH-FILE
                   AT END
                       MOVE 10 TO FS-STATUS
                   NOT AT END
                       MOVE FS-CASH-DENOMINATION TO
                       WS-CASH-DENOMINATION(IDX-CASH)
                       MOVE FS-CASH-QUANTITY TO
                       WS-CASH-QUANTITY(IDX-CASH)
                       SET IDX-CASH UP BY 1
           END-PERFORM
           CLOSE CASH-FILE.

       010-END.EXIT.

       020-ALGORITHM.
           SET IDX-CASH TO 1
           PERFORM VARYING IDX-CASH FROM 1 BY 1 UNTIL IDX-CASH > 6
               PERFORM UNTIL LK-WITHDRAW-AMOUNT <
               WS-CASH-DENOMINATION(IDX-CASH) OR
               WS-CASH-QUANTITY(IDX-CASH) = 0
                   COMPUTE LK-WITHDRAW-AMOUNT =
                   LK-WITHDRAW-AMOUNT - WS-CASH-DENOMINATION(IDX-CASH)
                   SUBTRACT 1 FROM WS-CASH-QUANTITY(IDX-CASH)
               END-PERFORM
           END-PERFORM.

           IF LK-WITHDRAW-AMOUNT = 0
               PERFORM 030-WRITE-FILE THRU 030-END
           ELSE
               DISPLAY "Selected amount unavailable."
                           "Please try a different amount"
               EXIT PROGRAM.

       020-END.EXIT.

       030-WRITE-FILE.
           OPEN OUTPUT CASH-FILE
           PERFORM VARYING IDX-CASH FROM 1 BY 1 UNTIL IDX-CASH > 6
               MOVE WS-CASH-DENOMINATION(IDX-CASH) TO
               FS-CASH-DENOMINATION
               MOVE WS-CASH-QUANTITY(IDX-CASH) TO FS-CASH-QUANTITY
               WRITE CASH-RECORD
           END-PERFORM
           CLOSE CASH-FILE.
           EXIT PROGRAM.
       030-END.EXIT.

           END PROGRAM CASH-MODULE.
