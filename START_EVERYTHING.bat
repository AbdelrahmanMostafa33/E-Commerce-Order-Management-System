@echo off
echo.
echo ================================================
echo   E-COMMERCE SYSTEM - ONE-CLICK START (PHASEPT 2025)
echo ================================================
echo.

:: CHANGE THIS PATH TO WHERE YOU EXTRACTED TOMCAT
set TOMCAT_PATH=C:\tomcat10

echo [1/6] Starting Tomcat from %TOMCAT_PATH% ...
start "TOMCAT 8080" "%TOMCAT_PATH%\bin\startup.bat"
timeout /t 10 >nul

echo [2/6] Starting Order Service       (5001)
start "Order 5001"       cmd /c "cd /d %~dp0services\order_service       && python app.py"

echo [3/6] Starting Inventory Service  (5002)
start "Inventory 5002"   cmd /c "cd /d %~dp0services\inventory_service   && python app.py"

echo [4/6] Starting Pricing Service    (5003)
start "Pricing 5003"     cmd /c "cd /d %~dp0services\pricing_service     && python app.py"

echo [5/6] Starting Customer Service   (5004)
start "Customer 5004"    cmd /c "cd /d %~dp0services\customer_service    && python app.py"

echo [6/6] Starting Notification Service (5005)
start "Notification 5005" cmd /c "cd /d %~dp0services\notification_service && python app.py"

echo.
echo ALL DONE!
echo → Open: http://localhost:8080/ecommerce
echo → Services: 5001 to 5005
echo.
pause