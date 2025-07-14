# COBOL ATM System 💳💻

This is an **ATM (Automated Teller Machine)** system project developed in **COBOL**, designed to simulate banking operations using indexed and sequential files.

## 📌 Main Features

- **User login** with PIN validation and attempt limit.
- **Balance inquiry**.
- **Cash withdrawal** with fund validation and cash module.
- **Cash deposit** with amount limit.
- **PIN modification** with double confirmation.
- **Transfers between accounts** using CBU (unique banking code).
- **Transfer logging** in a sequential file.
- **View last 5 transfers** using a reverse-scan algorithm, simulating an stack behaviour.

## 📂 File Structure

- `ACCOUNTS.DAT` → **Indexed** file containing account data (key: CBU).
- `TRANSACTIONS.txt` → **Sequential** file used as a log of transfers.
- `CASH-MODULE.txt` → Sequential file simulating physical bills in the ATM (used by `CASH-MODULE`).
- `ATM-MACHINE.cbl` → Main program.
- `CASH-MODULE.cbl` → Subprogram that simulates bill handling.
- `LAST-TRANSACTIONS.cbl` → Subprogram that retrieves the last 5 transfers made by a user.

## 🧪 Requirements

- [OpenCobolIDE](https://opencobolide.readthedocs.io/en/latest/) (with GnuCOBOL installed).
- Environment with `cobc` compiler.
- Initial data files:
  - `ACCOUNTS.DAT` (can be preloaded manually or generated).
  - `CASH-MODULE.txt` with the initial amount of bills.

## ▶️ How to Compile and Run

1. **Clone the repository:**  
   ```bash  
   git clone https://github.com/martinlwolf/atm-machine-cobol.git  
2. **Open OpenCobolIDE**  
3. **Compile subprograms:**  
   LAST-TRANSACTIONS.cbl and CASH-MODULE.cbl on OpenCobolIde  
4. **Compile and run main program:**  
   ATM-MACHINE.cbl  

**📁 ACCOUNTS.DAT Structure**
Field	Type	Description
CBU	9(22)	Unique banking code (key)
USERNAME	A(35)	Account holder's name
BALANCE	9(20)	Available balance
PIN	9(04)	4-digit PIN

**💵 Cash Module**
The system calls the CASH-MODULE subprogram to validate whether the ATM has enough bills for the requested withdrawal. It reads from CASH.txt and uses a denomination selection algorithm to deliver the best combination of bills available.

**📖 Last Transfers**
The LAST-TRANSACTIONS subprogram scans TRANSACTIONS.txt, filters by CBU, and displays the 5 most recent transfers performed by the user.

**🔒 Security**
PIN security with max 3 attempts.

Validation for destination CBU (self-transfers are not allowed).

Deposit amount limit.

Error messages when file access or write operations fail.

**🛠️ Future Improvements**
Graphical or web interface (e.g. Java Swing or REST API frontend).

**🧑‍💻 Author**
Project created by Martin L. Wolf as a demonstration of COBOL skills for mainframe and legacy environments.  
GitHub: [martinlwolf](https://github.com/martinlwolf)

To test the program:  
ACCOUNT 1:  
CBU: 2850111111111111111111  
NAME: "JUAN PEREZ"  
BALANCE: 100000  
PIN: 1234  

ACCOUNT 2:  
CBU: 2850222222222222222222  
NAME: "MARIA GOMEZ"  
BALANCE: 20000  
PIN: 2345  
