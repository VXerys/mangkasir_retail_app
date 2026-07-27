@echo off
REM ctx - sistem konteks-chat MangRitel
REM
REM   tool\context\ctx.bat status
REM   tool\context\ctx.bat next
REM   tool\context\ctx.bat task done ui5-product-card
REM   tool\context\ctx.bat sync
REM   tool\context\ctx.bat --help
REM
REM MANGRITEL_MEMORY_DIR menunjuk direktori memory Claude Code untuk proyek ini.
REM Ganti kalau path profil berbeda; kalau tidak diset, ctx memakai default
REM %USERPROFILE%\.claude\projects\C--Users-PLN-mangkasir-retail-app\memory

setlocal

set PYTHON_EXE=C:\Users\PLN\AppData\Local\Programs\Python\Python311\python.exe
if not exist "%PYTHON_EXE%" set PYTHON_EXE=python

set MANGRITEL_MEMORY_DIR=%USERPROFILE%\.claude\projects\C--Users-PLN-mangkasir-retail-app\memory

cd /d "%~dp0"
"%PYTHON_EXE%" ctx.py %*
exit /b %ERRORLEVEL%
