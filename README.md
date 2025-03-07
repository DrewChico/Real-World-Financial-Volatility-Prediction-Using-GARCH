# Stock Market Volatility Modeling Using GARCH in R

## Overview
This project implements a **Generalized Autoregressive Conditional Heteroskedasticity (GARCH) model** to analyze and forecast stock market volatility using real-world financial data. By leveraging **Yahoo Finance data** and the `rugarch` package in R, this script captures time-dependent volatility patterns, helping investors, analysts, and researchers better understand market risk.

---

## What This Project Does
- Fetches **real-time stock price data** from Yahoo Finance via `tidyquant`
- Computes **log returns** for accurate volatility modeling
- Implements **GARCH(1,1) with a Student-t distribution** for better tail fit
- Generates **key diagnostic plots**, including:
  - Standardized Residuals
  - Conditional Volatility
  - QQ Plot
  - Autocorrelation Function (ACF)
- Forecasts **future volatility trends** (next 10 days)
- Combines all **visualizations into a final report**

---

## Why This Matters
Financial markets exhibit **volatility clustering**, where periods of high volatility are followed by more volatility. GARCH models help dynamically forecast risk, making them essential for:

- Portfolio risk management
- Stock price prediction
- Option pricing models
- Quantitative finance research

---

## Installation

### 1. Install Required Packages
Before running the script, install the necessary R packages:

```r
install.packages(c("rugarch", "tidyquant", "tidyverse", "patchwork"))
```

### 2. Clone the Repository 
```
git clone https://github.com/DrewChico/Real-World-Financial-Volatility-Prediction-Using-GARCH.git
cd GARCH-Stock-Volatility
```

### 3. Open and Run in RStudio 
- Open garch_volatility_model.R
- Run the script and enter the stock ticker symbol (e.g., AAPL, TSLA).
- The program will fetch stock data, compute volatility, generate plots, and forecast future trends.

## Example Output

### Generated Plots & Volatility Forecasting

![Rplot01](https://github.com/user-attachments/assets/aa06274c-e757-414b-a2f8-9d3f883bade3)

## Key Insights 

**Residuals Plot:** Should resemble white noise, confirming model accuracy.
**Conditional Volatility:** Shows how market risk changes over time.
**QQ Plot:** Assesses whether returns follow a normal distribution.
**ACF Plot:** Ensures there is no significant autocorrelation in residuals.
**Forecast Plot:** Predicts the next 10 days of volatility trends.

## Usage Instructions 

### 1. Modify the Stock Symbol 
Change the stock ticker inside garch_volatility_model.R:

```
stock_symbol <- "AAPL"  # Replace with any stock ticker (e.g., "MSFT", "TSLA")
```

### 2. Run the Script in RStudio 

```
source("garch_volatility_model.R")
```

## Technical Details 

### GARCH Model Specification 

The model follows a **GARCH(1,1)** process:

```
spec <- ugarchspec(
  variance.model = list(model = "sGARCH", garchOrder = c(1,1)),
  mean.model     = list(armaOrder = c(0,0), include.mean = FALSE),
  distribution.model = "std"  # Student-t distribution for heavy tails
)
```

- **ARCH Component (α₁):** Captures recent market shocks.
- **GARCH Component (β₁):** Models long-term volatility persistence.
- **Student-t Distribution:** Handles extreme price movements better than a normal distribution.

### Model Performance Evaluation

| **Test**            | **Interpretation**              | **Fix if Needed?**  |
|---------------------|--------------------------------|---------------------|
| **Residuals Plot**  | Should resemble white noise   | Try ARMA-GARCH if structured patterns exist |
| **QQ Plot**        | Should be close to a 45-degree line | If heavy tails, use a **Generalized Error Distribution (GED)** |
| **ACF Plot**       | Bars should be close to zero   | If autocorrelation exists, add **ARMA terms** |

**License** 

This project is licensed under the **GNU License**
