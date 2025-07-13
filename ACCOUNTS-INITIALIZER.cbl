      ******************************************************************
      * Author:
      * Date:
      * Purpose:
      * Tectonics: cobc
      ******************************************************************
        IDENTIFICATION DIVISION.
       PROGRAM-ID. CREATE-ACCOUNTS.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT ACCOUNTS-FILE ASSIGN TO "accounts.dat"
               ORGANIZATION IS INDEXED
               ACCESS MODE IS DYNAMIC
               RECORD KEY IS FS-CBU
               FILE STATUS IS FS-STATUS.

       DATA DIVISION.
       FILE SECTION.
       FD ACCOUNTS-FILE.
       01 ACCOUNTS-RECORD.
           05 FS-CBU        PIC 9(22).
           05 FS-USERNAME   PIC A(35).
           05 FS-BALANCE    PIC 9(20).
           05 FS-PIN        PIC 9(04).

       WORKING-STORAGE SECTION.
       01 FS-STATUS         PIC XX.
       01 IDX               PIC 9(02) VALUE 1.

       01 TEMP-CBU-TABLE.
           05 TEMP-CBU      OCCURS 10 TIMES.
               10 VAL-CBU   PIC 9(22) VALUE ZEROS.

       01 TEMP-USER-TABLE.
           05 TEMP-USER     OCCURS 10 TIMES.
               10 VAL-USER  PIC A(35) VALUE SPACES.

       01 TEMP-BAL-TABLE.
           05 TEMP-BAL      OCCURS 10 TIMES.
               10 VAL-BAL   PIC 9(20) VALUE ZEROS.

       01 TEMP-PIN-TABLE.
           05 TEMP-PIN      OCCURS 10 TIMES.
               10 VAL-PIN   PIC 9(04) VALUE ZEROS.

       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
           PERFORM 000-INIT-TABLES
           OPEN OUTPUT ACCOUNTS-FILE

           PERFORM VARYING IDX FROM 1 BY 1 UNTIL IDX > 10
               MOVE VAL-CBU(IDX)  TO FS-CBU
               MOVE VAL-USER(IDX) TO FS-USERNAME
               MOVE VAL-BAL(IDX)  TO FS-BALANCE
               MOVE VAL-PIN(IDX)  TO FS-PIN

               WRITE ACCOUNTS-RECORD INVALID KEY
                   DISPLAY "ERROR WRITING RECORD WITH CBU: " FS-CBU
                   DISPLAY "FS-STATUS: " FS-STATUS
               END-WRITE
           END-PERFORM

           CLOSE ACCOUNTS-FILE
           DISPLAY "accounts.dat created successfully."
           STOP RUN.

       000-INIT-TABLES.
           MOVE 2850111111111111111111 TO VAL-CBU(1)
           MOVE 2850222222222222222222 TO VAL-CBU(2)
           MOVE 2850333333333333333333 TO VAL-CBU(3)
           MOVE 2850444444444444444444 TO VAL-CBU(4)
           MOVE 2850555555555555555555 TO VAL-CBU(5)
           MOVE 2850666666666666666666 TO VAL-CBU(6)
           MOVE 2850777777777777777777 TO VAL-CBU(7)
           MOVE 2850888888888888888888 TO VAL-CBU(8)
           MOVE 2850999999999999999999 TO VAL-CBU(9)
           MOVE 2850100000000000000000 TO VAL-CBU(10)

           MOVE "JUAN PEREZ"     TO VAL-USER(1)
           MOVE "MARIA GOMEZ"    TO VAL-USER(2)
           MOVE "CARLOS LOPEZ"   TO VAL-USER(3)
           MOVE "ANA TORRES"     TO VAL-USER(4)
           MOVE "ROBERTO DIAZ"   TO VAL-USER(5)
           MOVE "LUCIA FERNANDEZ"TO VAL-USER(6)
           MOVE "PEDRO MARTINEZ" TO VAL-USER(7)
           MOVE "SOFIA LUNA"     TO VAL-USER(8)
           MOVE "JORGE MORALES"  TO VAL-USER(9)
           MOVE "VALENTINA CRUZ" TO VAL-USER(10)

           MOVE 100000 TO VAL-BAL(1)
           MOVE 20000  TO VAL-BAL(2)
           MOVE 30000  TO VAL-BAL(3)
           MOVE 40000  TO VAL-BAL(4)
           MOVE 50000  TO VAL-BAL(5)
           MOVE 60000  TO VAL-BAL(6)
           MOVE 70000  TO VAL-BAL(7)
           MOVE 80000  TO VAL-BAL(8)
           MOVE 90000  TO VAL-BAL(9)
           MOVE 100000 TO VAL-BAL(10)

           MOVE 1234 TO VAL-PIN(1)
           MOVE 2345 TO VAL-PIN(2)
           MOVE 3456 TO VAL-PIN(3)
           MOVE 4567 TO VAL-PIN(4)
           MOVE 5678 TO VAL-PIN(5)
           MOVE 6789 TO VAL-PIN(6)
           MOVE 7890 TO VAL-PIN(7)
           MOVE 8901 TO VAL-PIN(8)
           MOVE 9012 TO VAL-PIN(9)
           MOVE 0123 TO VAL-PIN(10).
       END PROGRAM CREATE-ACCOUNTS.
