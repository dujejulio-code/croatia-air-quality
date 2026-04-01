# DAX Measures Reference

Key DAX measures used in the Power BI dashboard, organized by analytical purpose.

---

## Core Measures

### Aqi Ratio
Average measured value relative to the EAQI "Good" threshold. Values > 1.0 indicate the average exceeds the Good limit.

```dax
Aqi Ratio = 
AVERAGEX(
    air_quality_fact,
    DIVIDE(
        air_quality_fact[measured_value],
        RELATED(dim_pollutant[good_threshold])
    )
)
```
**SQL equivalent:** `AVG(measured_value / good_threshold)` with a JOIN to dim_pollutant.

### Avg Measured Value
Simple average of pollutant concentration.

```dax
Avg Measured Value = 
AVERAGE(air_quality_fact[measured_value])
```

### Avg AQI Score
Average AQI severity score (1=Good through 5=Very Poor).

```dax
Avg AQI Score = 
AVERAGE(air_quality_fact[aq_index])
```

---

## Temporal Analysis Measures

### Avg Measured Value / Day of Week
Percentage deviation from the weekly average — shows which days are dirtier/cleaner than average.

```dax
Avg Measured Value / Day of Week = 
VAR DayAvg = AVERAGE(air_quality_fact[measured_value])
VAR WeekAvg = CALCULATE(
    AVERAGE(air_quality_fact[measured_value]),
    REMOVEFILTERS(dim_date[day_of_week])
)
RETURN DIVIDE(DayAvg - WeekAvg, WeekAvg) * 100
```
**SQL equivalent:** `(day_avg - weekly_avg) / weekly_avg * 100` using a window function `AVG() OVER()`.

---

## Cross-Fact-Table Measures

### Avg PM25 for Weather
Enables scatter plots of PM2.5 vs weather variables by using CROSSFILTER to activate the bidirectional relationship through shared dimensions.

```dax
Avg PM25 for Weather = 
CALCULATE(
    AVERAGE(air_quality_fact[measured_value]),
    CROSSFILTER(city_weather_fact[fk_date_id], dim_date[pk_date_id], Both),
    air_quality_fact[pollutant] = "pm25"
)
```
**Why CROSSFILTER?** In the default model, filters flow from dimension → fact only. To filter air_quality_fact based on city_weather_fact selections (e.g., a temperature bin), we need bidirectional filtering through the shared dim_date.

---

## Wind Direction Measures

### AQI Ratio PM25 / Wind
Average PM2.5 ratio by wind direction — used in the wind rose radar chart.

```dax
AQI Ratio PM25 / Wind = 
CALCULATE(
    [Aqi Ratio],
    wind_pollution[fk_pollutant_id] = 6  -- PM2.5
)
```

### Avg Wind Speed by Direction
Average wind speed for each cardinal direction — the "Wind Power" radar chart.

```dax
Avg Wind Speed by Direction = 
AVERAGE(wind_pollution[wind_speed_10m_kmh])
```

---

## Calculated Columns (Power BI)

### Wind Direction (categorical)
Converts wind degrees to 8 cardinal directions (N, NE, E, SE, S, SW, W, NW).

### Wind Sort
Sort order for wind directions (N=1, NE=2, ..., NW=8) to display correctly on radar charts.

### Temp Bin / Wind Shear Bin
Binned columns for scatter plot axes (temperature rounded to 2°C bins, wind shear to 1 km/h bins).

### COVID Period
Flag on dim_date: "Pre-COVID" (2019), "COVID" (2020), "Post-COVID" (2021-2024).

### Day of Week Sorted
Custom sort for days of the week (Monday=1 through Sunday=7).

---
