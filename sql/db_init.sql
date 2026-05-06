/*=====================================================================================
DATABASE & SCHEMA SETUP
Purpose: 
    Sets up the database and required schemas for the project:
    - raw      : stores unprocessed source tables
    - clean    : stores cleaned and transformed views ready for analysis
    - gold     : stores customer summary table for analysis
    - analysis : stores analytical views derived from business questions

Usage:
    - Run this script first to prepare the environment for data ingestion and analysis
========================================================================================*/

DROP DATABASE IF EXISTS contoso;
-- Create database
CREATE DATABASE contoso;

-- Create schemas
-- 1) raw
CREATE SCHEMA IF NOT EXISTS raw;
-- 2) clean
CREATE SCHEMA IF NOT EXISTS clean;
-- 3) gold
CREATE SCHEMA IF NOT EXISTS gold;
--4) analysis
CREATE SCHEMA IF NOT EXISTS analysis;