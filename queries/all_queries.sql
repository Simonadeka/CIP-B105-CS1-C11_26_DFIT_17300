-- CRAIGSLIST FORENSIC QUERIES
-- Timestamp Conversion: datetime(col/1000000 - 11644473600,'unixepoch')

-- FIG 1: SCHEMA
.schema downloads;
.schema urls;
.schema visits;

-- FIG 2: CRAIGSLIST
SELECT u.id, u.url, datetime(v.visit_time/1000000 - 11644473600,'unixepoch') as visit_time_utc, v.transition 
FROM urls u JOIN visits v ON u.id = v.url 
WHERE u.url LIKE '%craigslist.org%';

-- FIG 3: GMAIL
SELECT u.id, u.url, datetime(v.visit_time/1000000 - 11644473600,'unixepoch') as visit_time_utc, v.transition 
FROM urls u JOIN visits v ON u.id = v.url 
WHERE u.url LIKE '%mail.google.com%';

-- FIG 4: DOWNLOAD
SELECT id, target_path, tab_url, datetime(start_time/1000000 - 11644473600,'unixepoch') as start_time_utc 
FROM downloads 
WHERE target_path LIKE '%proof_of_payment.png%';

-- FIG 5: BLOCKCHAIN
SELECT u.id, u.url, datetime(v.visit_time/1000000 - 11644473600,'unixepoch') as visit_time_utc 
FROM urls u JOIN visits v ON u.id = v.url 
WHERE u.url LIKE '%blockchain.com/btc/tx/517b2156914944339a96137ad8978408ea52b2fc144c98d3b0b16b21888afdc5%';
