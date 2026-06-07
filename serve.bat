@echo off
title FCJ Bao Cao - Hugo Server
cd /d "%~dp0"
echo.
echo  Dang khoi dong bao cao thuc tap...
echo  Mo trinh duyet: http://localhost:1313/vi/
echo  Nhan Ctrl+C de dung server
echo.
hugo server -D --disableFastRender
pause
