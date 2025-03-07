############################################################
# Install and Load Required Packages
############################################################
if (!require("rugarch")) install.packages("rugarch", dependencies=TRUE)
if (!require("tidyquant")) install.packages("tidyquant", dependencies=TRUE)
if (!require("tidyverse")) install.packages("tidyverse", dependencies=TRUE)
if (!require("patchwork")) install.packages("patchwork", dependencies=TRUE)

# Load necessary libraries
library(rugarch)
library(tidyquant)
library(tidyverse)
library(patchwork)

############################################################
# Fetch Historical Stock Data & Compute Log Returns
############################################################
stock_symbol <- "AAPL"  # Change this for different stocks
start_date <- "2020-01-01"
end_date <- Sys.Date()

# Get stock data from Yahoo Finance
stock_data <- tq_get(stock_symbol, from = start_date, to = end_date)

# Convert to log returns
stock_data <- stock_data %>%
  select(date, adjusted) %>%
  mutate(log_return = log(adjusted / lag(adjusted))) %>%
  drop_na()

# Extract returns for GARCH modeling
returns <- stock_data$log_return  

############################################################
# Define and Fit GARCH(1,1) Model
############################################################
spec <- ugarchspec(
  variance.model = list(model = "sGARCH", garchOrder = c(1,1)),
  mean.model     = list(armaOrder = c(0,0), include.mean = FALSE),
  distribution.model = "std"  # Student-t distribution for better tail fit
)

# Fit the GARCH model
fit <- ugarchfit(spec = spec, data = returns)

# Print model summary
print(fit)

############################################################
# Create Diagnostic Plots
############################################################

# Standardized Residuals Plot
resid_plot <- ggplot(data.frame(index = 1:length(residuals(fit, standardize=TRUE)), 
                                residuals = residuals(fit, standardize=TRUE)), aes(x = index, y = residuals)) +
  geom_line(color = "blue") +
  ggtitle("Standardized Residuals") +
  theme_minimal()

# Conditional Variance Plot (Volatility over time)
cond_var_plot <- ggplot(data.frame(index = 1:length(sigma(fit)), 
                                   variance = sigma(fit)), aes(x = index, y = variance)) +
  geom_line(color = "red") +
  ggtitle("Conditional Volatility (Variance)") +
  theme_minimal()

# QQ Plot for Normality Check
qq_plot <- ggplot(data.frame(sample = residuals(fit, standardize=TRUE)), aes(sample = sample)) +
  stat_qq() +
  stat_qq_line(color = "blue") +
  ggtitle("QQ Plot of Residuals") +
  theme_minimal()

# ACF Plot of Standardized Residuals
acf_data <- acf(residuals(fit, standardize=TRUE), plot = FALSE)
acf_plot <- ggplot(data.frame(lag = acf_data$lag, acf = acf_data$acf), aes(x = lag, y = acf)) +
  geom_bar(stat="identity", fill = "purple") +
  ggtitle("ACF of Standardized Residuals") +
  theme_minimal()

############################################################
# Forecast Future Volatility
############################################################
forecast <- ugarchforecast(fit, n.ahead = 10)  # Forecast next 10 periods

# Convert forecasted volatility to a data frame
forecast_vol <- data.frame(day = 1:10, volatility = as.numeric(sigma(forecast)))  

# Forecasted Volatility Plot
forecast_plot <- ggplot(forecast_vol, aes(x = day, y = volatility)) +
  geom_line(color = "green", size = 1.2) +
  ggtitle("10-Day Forecasted Volatility") +
  theme_minimal()

############################################################
# Combine All Plots into a Final Visualization
############################################################
final_plot <- (resid_plot | cond_var_plot) / (qq_plot | acf_plot) / forecast_plot
print(final_plot)
