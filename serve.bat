@echo off
title TRANTHAINGUYEN-fcj-internship-report - Hugo Server
cd /d "%~dp0"
echo.
echo  Dang khoi dong TRANTHAINGUYEN-fcj-internship-report...
echo  Mo trinh duyet: http://localhost:3655/vi/
echo  Nhan Ctrl+C de dung server
echo.
hugo server -D -p 3655 --disableFastRender
pause
