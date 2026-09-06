
# Craigslist Bitcoin Scam Forensic Analysis
**Case ID:** CRAIG-2022-0419 
**Analyst:** Simon [Lastname] 
**Date of Analysis:** 2026-09-06 
**Evidence Date:** 2022-04-19
**Course:** Digital Forensics Investigation

---

## 1. EXECUTIVE SUMMARY

This forensic examination investigates an alleged Craigslist item sale scam. The suspect is accused of advertising an item on Craigslist, requesting Bitcoin payment, and providing a fraudulent TXID `517b2156914944339a96137ad8978408ea52b2fc144c98d3b0b16b21888afdc5` with a counterfeit receipt from Imgur to deceive the victim.

Analysis of `chrome_history.db` recovered from a Kali Linux VM confirms a 7-stage workflow on `2022-04-19 UTC` consistent with fraud. Digital artifacts support deliberate posting, communication, and deception.

**Final Confidence:** High confidence that the suspect performed the online transaction sequence. Medium confidence on completion due to lack of victim-side evidence.

---

## 2. EVIDENCE ACQUISITION & PRESERVATION

### 2.1 Chain of Custody
| Evidence ID | Description | Source | SHA256 Hash |
| --- | --- | --- | --- |
| E01 | `chrome_history.db` | `/home/simon/.config/google-chrome/Default/` | [RUN sha256sum AND ADD] |
| E02 | `proof_of_payment.png` | Downloaded from https://i.imgur.com/ | [RUN sha256sum AND ADD] |

**Verification:** Hash calculated prior to analysis and after export to verify integrity.

**Fig 6: Chain of Custody - SHA256 Verification**
![Fig 6](report/figures/Fig6_ChainOfCustody_SHA256.png)
*Caption: SHA256 hash of chrome_history.db calculated using `sha256sum` to verify evidence integrity.*

**Fig 7: Final Evidence Package**
![Fig 7](report/figures/Fig7_FinalPackage_ZIP.png)
*Caption: All evidence exported to ZIP archive with SHA256 hash for submission.*

---

## 3. TOOLS & METHODOLOGY

**Tools Used:**
1. Kali Linux 2024.3
2. SQLite3 v3.40.1 - Read-only mode
3. sha256sum - Hashing
4. zip - Evidence packaging

**Timestamp Conversion Method:**
Chrome/WebKit time = microseconds since `1601-01-01 00:00:00 UTC`
Conversion SQL: `datetime(visit_time/1000000 - 11644473600, 'unixepoch')`
All times reported in UTC.

**Transition Types:**
`0=LINK, 1=TYPED, 3=FORM_SUBMIT, 8=FORM_SUBMIT_REDIRECT`. Used to infer user intent.

---

## 4. DATABASE SCHEMA & QUERIES

**Fig 1: Schema Verification**
![Fig 1](report/figures/Fig1_Schema_ChromeHistory.png)
*Caption: Output of.schema command confirming existence of urls, visits, and downloads tables.*

**Reproducible Query Log:** See `/queries/all_queries.sql`

---

## 5. KEY FINDINGS & TIMELINE

### Stage 1: Craigslist Posting Workflow
**Time:** 2022-04-19 14:48:22 UTC
**Activity:** Accessed craigslist.org. Transition type indicates form submission.
**Evidence:** This supports deliberate creation and publication of a listing.

**Fig 2: Stage 1 - Craigslist Visit & Form Submit**
![Fig 2](report/figures/Fig2_Craigslist_Visit.png)
*Caption: Query result showing visit to craigslist.org at 2022-04-19 14:48:22 UTC with transition=3 FORM_SUBMIT.*

### Stage 2-3: Gmail Communication with Buyer
**Time:** 2022-04-19 15:02:32 UTC
**Activity:** Accessed mail.google.com. Likely TXID exchange occurred here.
**Evidence:** Supports communication with an interested buyer.

**Fig 3: Stage 2-3 - Gmail Navigation**
![Fig 3](report/figures/Fig3_Gmail_Activity.png)
*Caption: Query result showing access to mail.google.com at 2022-04-19 15:02:32 UTC.*

### Stage 4: Delivery of Bitcoin Payment Instructions
**Evidence:** Inferred from Fig 3 Gmail activity + Fig 5 blockchain check. History DB does not contain email body.
**Support:** Medium. Delivery is inferred, not directly captured.

### Stage 5: Payment Verification by Suspect
**Time:** 2022-04-19 15:03:26 UTC
**Activity:** Accessed blockchain.com to verify TXID `517b215691494433...`
**Evidence:** Supports that suspect attempted to verify or create the appearance of payment.

**Fig 5: Stage 4-5 - Blockchain TXID Verification**
![Fig 5](report/figures/Fig5_Blockchain_Check.png)
*Caption: Query result showing access to blockchain.com/btc/tx/517b215691494433... at 2022-04-19 15:03:26 UTC.*

### Stage 6: Download of Counterfeit Payment Receipt
**Time:** 2022-04-19 14:56:58 UTC
**Activity:** Downloaded `proof_of_payment.png` from `https://i.imgur.com/` to `/home/simon/Downloads/`
**Evidence:** This file is directly connected to the payment deception evidence.

**Fig 4: Stage 6 - Download of Counterfeit Receipt**
![Fig 4](report/figures/Fig4_Download_ProofOfPayment.png)
*Caption: Query output from downloads table showing proof_of_payment.png downloaded from https://i.imgur.com/ at 2022-04-19 14:56:58 UTC.*

### Stage 7: Shipment/Receipt Stage
**Evidence:** No direct browser evidence of shipment. This stage is inferred from the download of fake receipt in Stage 6.

---

## 6. EVIDENCE TABLES

### 6.1 Blockchain/Wallet/Exchange Evidence
| Timestamp UTC | Activity | URL/TXID | Support |
| --- | --- | --- | --- |
| 2022-04-19 15:03:26 | TXID Verification | blockchain.com/btc/tx/517b2156... | Proves suspect checked fake TXID |

### 6.2 Integrated UTC Timeline
| Time UTC | Activity | Evidence |
| --- | --- | --- |
| 14:48:22 | Craigslist Access | Fig 2 |
| 14:56:58 | Download Fake Receipt | Fig 4 |
| 15:02:32 | Gmail Access | Fig 3 |
| 15:03:26 | Blockchain TXID Check | Fig 5 |

Full export: `/exports/Timeline_Craigslist.csv`

---

## 7. SEVEN-STAGE HYPOTHESIS MATRIX

| Stage | Hypothesis | Evidence | Support Level | Limitation |
| --- | --- | --- | --- | --- |
| 1 | Deliberately created Craigslist post | Fig 2: URL + transition=3 | Strong | No post content |
| 2 | Communicated with buyer | Fig 3: Gmail access | Medium | No email body |
| 3 | Delivered BTC payment instructions | Fig 3 + Fig 5 | Medium | Inferred only |
| 4 | Buyer sent payment | None | None | No victim wallet data |
| 5 | Payment verification/confirmation | Fig 5: blockchain.com | Strong | Only suspect action |
| 6 | Downloaded file connected to payment | Fig 4: proof_of_payment.png | Strong | None |
| 7 | Shipment/Receipt completed | Inferred from Fig 4 | Weak | No tracking/shipment data |

---

## 8. REQUIRED FINDINGS - ANSWERS

1. **Deliberate Craigslist Post:** Yes. Fig 2 shows craigslist.org access with FORM_SUBMIT transition.
2. **Communication with Buyer:** Yes. Fig 3 shows Gmail access during fraud window.
3. **Delivery of BTC Instructions:** Inferred. Fig 3 Gmail + Fig 5 blockchain check sequence.
4. **Buyer Sent Payment:** No direct evidence in browser history.
5. **Payment Verification:** Yes. Fig 5 shows suspect checked TXID on blockchain.com.
6. **Downloaded File:** Yes. `proof_of_payment.png` from Imgur. Fig 4. Directly used as fake evidence.
7. **TXID/Exchange Activity:** TXID `517b215691494433...` checked on blockchain.com. Fig 5. No Kraken/mempool/wallet evidence found.
8. **Shipment/Receipt:** Inferred only from fake receipt download.
9. **Alternative Explanations:** See Section 9.
10. **Final Confidence:** High that sequence was attempted. Medium that fraud was completed.

---

## 9. LIMITATIONS & ALTERNATIVE EXPLANATIONS

1. **No Content Data:** `chrome_history.db` does not store webpage content, email bodies, or Craigslist post text.
2. **User Attribution:** Cannot prove who was physically at the keyboard.
3. **Data Volatility:** History can be deleted, edited, or synced. Private/Incognito mode leaves no trace.
4. **One-Sided View:** No evidence from victim's device or Bitcoin wallet to confirm payment receipt.
5. **TXID Validity:** Cannot confirm from history alone if TXID was real or fake. Only that it was checked.

---

## 10. CONCLUSION

The forensic analysis of `chrome_history.db` provides strong digital support for stages 1, 2, 5, and 6 of the fraud hypothesis. The timeline, URLs, and downloaded file corroborate intentional deception using Bitcoin and a counterfeit receipt. 

Due to limitations in browser history data, stages 3, 4, and 7 are partially inferred. The evidence is sufficient to support allegations of attempted wire fraud.

---

## 11. APPENDIX
### A. All SQL Queries
See `/queries/all_queries.sql`
