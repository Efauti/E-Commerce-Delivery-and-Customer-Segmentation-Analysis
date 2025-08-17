# E-commerce Delivery & Customer Segmentation Analysis  

**Tools Used:** SQL  

---

## 1. Business Problem  
The business needs to understand its delivery performance to ensure customer satisfaction and operational efficiency. Specifically, management wants to evaluate how often orders are delivered on time, early, or late, and identify opportunities for improvement.  

Additionally, the company seeks to analyze customer behavior to uncover high-value segments and understand geographic concentration.  

---

## 2. Approach  

- **Delivery Analysis:** Wrote SQL queries to classify orders into Early, On Time, or Late categories and calculated order counts and percentages.  
- **Customer Segmentation:** Segmented customers by revenue contribution, repeat purchase behavior, and geography.  
- **Anomaly Detection:** Tracked order volumes across time to identify unusual patterns.  

---

## 3. Key Insights  

### Delivery Performance  
- 92% of orders were delivered early.  
- Only 1.3% were delivered on time.  
- Suggests overly conservative delivery estimates leading to operational inefficiencies.  

### Customer Behavior  
- Over 98% of customers contribute less than 0.1% of revenue each → a high-volume, low-value model.  
- Only 3% of customers make repeat purchases → poor retention.  

### Geographic Concentration  
- São Paulo alone accounted for **40%+ of customers**, showing heavy overreliance on one region.  

### Order Anomaly  
- September–October 2018 saw a **sharp drop-off in orders**.  
- All orders during this period were cancelled except one (also not completed).  
- Represents a critical operational or market disruption despite being the company’s best overall year.  

### Uncompleted Orders  
- 1,316 orders (1.16%) were cancelled or unavailable.  
- All uncompleted orders were overdue, except one with the dataset’s latest delivery date (also cancelled).  

---

## 4. Recommendations  

- **Recalibrate Delivery Estimations:** Shorten overly conservative estimates to better reflect actual delivery times and align resources more efficiently.  
- **Customer Retention Strategies:** Launch loyalty programs, personalized offers, or subscription models to increase repeat purchases.  
- **Geographic Diversification:** Expand marketing and logistics reach beyond São Paulo to reduce reliance on a single region.  
- **Investigate Order Drop-off:** Conduct root-cause analysis of the September–October 2018 anomaly to prevent recurrence.  

---

## 5. Notes  
- At the dataset cutoff, no active orders remained.  

---

## 6. SQL Queries  

- [SQL Queries](queries/e_commerce_analysis.sql)

