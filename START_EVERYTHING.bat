@echo off
echo.
echo ================================================
echo   E-COMMERCE ORDER MANAGEMENT – FULL START (NO CATALINA_HOME)
echo ================================================
echo.

:: ←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←
:: CHANGE ONLY THIS LINE – put your real Tomcat folder path here
set "TOMCAT_PATH=C:\tomcat10"
:: ←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←

echo Starting Tomcat directly (bypassing CATALINA_HOME)...
start "TOMCAT 8080" cmd /k ""%TOMCAT_PATH%\bin\catalina.bat" run"

timeout /t 15 >nul

echo Starting 5 Flask Microservices...
cd /d "%~dp0services"

start "Order 5001"       cmd /k "cd order_service       && python app.py"
start "Inventory 5002"   cmd /k "cd inventory_service   && python app.py"
start "Pricing 5003"     cmd /k "cd pricing_service     && python app.py"
start "Customer 5004"    cmd /k "cd customer_service    && python app.py"
start "Notification 5005"cmd /k "cd notification_service && python app.py"

echo.
echo ALL DONE! Open these links:
echo   → http://localhost:8080/ecommerce/index.jsp
echo → http://localhost:5001 to http://localhost:5005
echo.
echo Close any window to stop a service.
pause