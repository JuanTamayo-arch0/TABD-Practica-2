# Public Procurement Management System - SECOP

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![ORACLE](https://img.shields.io/badge/Oracle-F80000?style=for-the-badge&logo=oracle&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-CC2927?style=for-the-badge&logo=microsoft-sql-server&logoColor=white)
![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)

## 📋 Project Description

This repository contains the complete implementation of a relational database in **PostgreSQL** and **OracleSQL** for the management and analysis of the SECOP public procurement system (Sistema Electrónico de Contratación Pública) in Antioquia. The project is based on real public procurement process data, designed to provide statistical and operational analysis of public sector contractual behavior.

### 🎯 Objective

Develop a normalized database system that enables efficient analysis of:
- Contracting patterns by modality and contract type
- Temporal analysis of procurement processes
- Geographic distribution of contracting entities
- Statistics on contract duration and values
- Management reports for decision-making

---

## 👥 Development Team

### 👨‍💻 Members

| Student | ID | Institutional Email | Role |
|---------|----|--------------------|------|
| **Juan Jose Tamayo Ospina** | 000193632 | juanjose.tamayo@upb.edu.co | STUDENT |
| **Daniel Cardona Gonzalez** | 000414882 | daniel.cardonag.col@upb.edu.co | STUDENT |

### 🏫 Academic Information
- **University:** Universidad Pontificia Bolivariana
- **Program:** Systems and Computer Engineering
- **Course:** Advanced Database Topics
- **Period:** 2025-2
- **Delivery Date:** August 2025

---

### 🌐 Data Source
- **Provider:** Electronic Public Procurement System - SECOP
- **Platform:** Open Data Colombia
- **URL:** [https://www.datos.gov.co/](https://www.datos.gov.co/)

---

## 🏗️ System Architecture

### Data Model
The system implements a **relational model normalized in 3NF** that includes:

#### 📋 Main Tables
- **`Ciudades`** - Catalog of cities where entities are located
- **`Ordenes`** - Administrative orders of public entities
- **`Modalidades_contratos`** - Available contracting modalities
- **`Tipos_contratos`** - Contract classification by type
- **`Entidades`** - Registry of contracting public entities
- **`Procesos`** - Main registry of procurement processes (fact table)

#### 📋 Implemented Schemas
- **`inicial`** - Original unprocessed data
- **`corregido`** - Normalized and optimized data

### ⚙️ Implemented Features
- **Normalization:** Data transformation from CSV format to relational model
- **Optimization:** Specific indexes for frequent queries
- **Materialized views:** Pre-calculation of complex statistics
- **Security:** Dedicated user with minimum privileges

---

## Analysis Queries Implemented

### 📊 Query 1: Contract Duration Analysis by City
**Objective:** Provide descriptive statistics of contract duration grouped by city

**Generated metrics:**
- Minimum, average, and maximum duration per city
- Total processes by geographic location
- Temporal distribution analysis

### 🏆 Query 2: Monthly Public Procurement Statistics
**Objective:** Complete temporal analysis with identification of recurring patterns

**Generated metrics:**
- Most frequent modalities per month
- Predominant contract types by period
- Price statistics (minimum, maximum, average)
- Standard deviation of contracted values

### Implemented Optimizations
- **Composite indexes** to improve JOIN performance
- **Materialized view** for recurring complex queries
- **Maintenance procedures** for automatic updates

---

## 🛠️ Technologies Used

| Technology | Version | Purpose |
|-----------|---------|---------|
| **PostgreSQL** | 12+ | Database management system |
| **ORACLE** | 23 free version | Database management system |
| **SQL** | ANSI SQL | Query and data manipulation language |
| **Git** | 2.0+ | Version control |
| **DataGrip/DBeaver** | Latest | IDE for development and testing |

---

## 📞 Contact

For inquiries about this academic project:

- **Juan José Tamayo Ospina:** juan.tamayoo@upb.edu.co
- **Daniel Cardona Gonzalez:** daniel.cardonag.col@upb.edu.co

---

## 📜 License

This project is developed for academic purposes at Universidad Pontificia Bolivariana. The data used comes from public sources of the Colombian government through the SECOP system.

---

**Developed in August 2025**

**Universidad Pontificia Bolivariana - Medellín, Colombia**
