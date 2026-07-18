##Dataset Schema
* **Filename:** `layoffs.csv`

| Column Name | Data Type | Description / Purpose |
| :--- | :--- | :--- |
| `company` | `VARCHAR(150)` | The registered name of the tech organization executing the workforce reduction (e.g., *Uber, Booking.com, Airbnb*). |
| `location` | `VARCHAR(100)` | The city or metropolitan hub where the layoffs were anchored or headquartered (e.g., *San Francisco, Bengaluru, London*). |
| `industry` | `VARCHAR(100)` | The specific commercial vertical or sector the business operates within (e.g., *Consumer, Crypto, Retail, Finance*). |
| `total_laid_off` | `INT` | The absolute headcount of personnel terminated during this specific layoff event. |
| `percentage_laid_off` | `DECIMAL(5,4)` | The explicit proportion of the company's total workforce eliminated, represented as a fraction (e.g., `0.1500` for 15%, `1.0000` for a total shutdown). |
| `date` | `DATE` | The exact calendar date the layoff round was publicly announced or executed (`YYYY-MM-DD`). |
| `stage` | `VARCHAR(50)` | The maturity/venture capital tier of the organization at the time of the cuts (e.g., *Seed, Series A, Series B, Post-IPO, Acquired*). |
| `country` | `VARCHAR(100)` | The geographic nation hosting the operation or headquarters (e.g., *United States, India, Sweden*). |
| `funds_raised_millions` | `FLOAT` | The cumulative financial backing or venture funding secured by the firm prior to the event, denominated in Millions of USD. |
