# Sistema de Gestión de Contratación Pública - SECOP

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![ORACLE](https://img.shields.io/badge/Oracle-F80000?style=for-the-badge&logo=oracle&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-CC2927?style=for-the-badge&logo=microsoft-sql-server&logoColor=white)
![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)

## 📋 Descripción del Proyecto

Este repositorio contiene la implementación completa de una base de datos relacional en **PostgreSQL** y **OracleSQL** para la gestión y análisis del sistema de contratación pública SECOP (Sistema Electrónico de Contratación Pública) de Antioquia. El proyecto está basado en datos reales de procesos de contratación pública, diseñado para proporcionar análisis estadísticos y operacionales del comportamiento contractual del sector público.

### 🎯 Objetivo

Desarrollar un sistema de base de datos normalizado que permita el análisis eficiente de:
- Patrones de contratación por modalidad y tipo de contrato
- Análisis temporal de procesos de contratación
- Distribución geográfica de entidades contratantes
- Estadísticas de duración y valores de contratos
- Reportes gerenciales para toma de decisiones

---

## 👥 Equipo de Desarrollo

### 👨‍💻 Integrantes

| Estudiante | ID | Correo Institucional | Rol |
|------------|----|--------------------|-----|
| **Juan Jose Tamayo Ospina** | 000193632 | juanjose.tamayo@upb.edu.co | ESTUDIANTE |
| **Daniel Cardona Gonzalez** | 000414882 | daniel.cardonag.col@upb.edu.co | ESTUDIANTE |

### 🏫 Información Académica
- **Universidad:** Universidad Pontificia Bolivariana
- **Programa:** Ingeniería en Sistemas e Informática
- **Materia:** Tópicos Avanzados de Bases de Datos
- **Período:** 2025-2
- **Fecha de Entrega:** Agosto 2025

---

### 🌐 Fuente de Datos
- **Proveedor:** Sistema Electrónico de Contratación Pública - SECOP
- **Plataforma:** Datos Abiertos de Colombia
- **URL:** [https://www.datos.gov.co/](https://www.datos.gov.co/)

---

## 🏗️ Arquitectura del Sistema

### Modelo de Datos
El sistema implementa un **modelo relacional normalizado en 3FN** que incluye:

#### 📋 Tablas Principales
- **`Ciudades`** - Catálogo de ciudades donde se ubican las entidades
- **`Ordenes`** - Órdenes administrativos de las entidades públicas
- **`Modalidades_contratos`** - Modalidades de contratación disponibles
- **`Tipos_contratos`** - Clasificación de contratos por tipo
- **`Entidades`** - Registro de entidades públicas contratantes
- **`Procesos`** - Registro principal de procesos de contratación (tabla de hechos)

#### 📋 Esquemas Implementados
- **`inicial`** - Datos originales sin procesar
- **`corregido`** - Datos normalizados y optimizados

### ⚙️ Funcionalidades Implementadas
- **Normalización:** Transformación de datos desde formato CSV a modelo relacional
- **Optimización:** Índices específicos para consultas frecuentes
- **Vistas materializadas:** Pre-cálculo de estadísticas complejas
- **Seguridad:** Usuario dedicado con privilegios mínimos

---

## Consultas de Análisis Implementadas

### 📊 Consulta 1: Análisis de Duración de Contratos por Ciudad
**Objetivo:** Proporcionar estadísticas descriptivas de duración de contratos agrupadas por ciudad

**Métricas generadas:**
- Duración mínima, promedio y máxima por ciudad
- Total de procesos por ubicación geográfica
- Análisis de distribución temporal

### 🏆 Consulta 2: Estadísticas Mensuales de Contratación Pública
**Objetivo:** Análisis temporal completo con identificación de patrones recurrentes

**Métricas generadas:**
- Modalidades más frecuentes por mes
- Tipos de contrato predominantes por período
- Estadísticas de precios (mínimo, máximo, promedio)
- Desviación estándar de valores contratados

### Optimizaciones Implementadas
- **Índices compuestos** para mejorar rendimiento de JOINs
- **Vista materializada** para consultas recurrentes complejas
- **Procedimientos de mantenimiento** para actualización automática


---

## 🛠️ Tecnologías Utilizadas

| Tecnología | Versión | Propósito |
|-----------|---------|-----------|
| **PostgreSQL** | 12+ | Sistema de gestión de base de datos |
| **ORACLE** | 23 free version | Sistema de gestión de base de datos |
| **SQL** | ANSI SQL | Lenguaje de consulta y manipulación de datos |
| **Git** | 2.0+ | Control de versiones |
| **DataGrip/DBeaver** | Última | IDE para desarrollo y testing |

---

## 📞 Contacto

Para consultas sobre este proyecto académico:

- **Juan José Tamayo Ospina:** juan.tamayoo@upb.edu.co
- **Daniel Cardona Gonzalez:** daniel.cardonag.col@upb.edu.co


---

## 📜 Licencia

Este proyecto es desarrollado con fines académicos para la Universidad Pontificia Bolivariana. Los datos utilizados provienen de fuentes públicas del gobierno colombiano a través del sistema SECOP.

---

**Desarrollado en Agosto 2025**

**Universidad Pontificia Bolivariana - Medellín, Colombia**