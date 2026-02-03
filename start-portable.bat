@echo off
chcp 65001 >nul
cls
echo.
echo ╔═══════════════════════════════════════════════════════════════╗
echo ║                                                                 ║
echo ║        상업용 부동산 제안서 생성 시스템 - 휴대용 버전        ║
echo ║        Commercial Real Estate Proposal App - Portable         ║
echo ║                                                                 ║
echo ╚═══════════════════════════════════════════════════════════════╝
echo.
echo  USB나 다른 PC에서도 실행 가능한 완전 휴대용 버전입니다!
echo.
echo  [시작 중...]
echo.

:: 현재 스크립트 위치 저장
set "SCRIPT_DIR=%~dp0"
cd /d "%SCRIPT_DIR%"

:: Python과 Node.js 경로 설정
set "PYTHON_DIR=%SCRIPT_DIR%python"
set "NODE_DIR=%SCRIPT_DIR%node"
set "APP_DIR=%SCRIPT_DIR%app"

:: Python 경로 확인
if not exist "%PYTHON_DIR%\python.exe" (
    echo ❌ Python을 찾을 수 없습니다!
    echo    경로: %PYTHON_DIR%\python.exe
    pause
    exit /b 1
)

:: Node.js 경로 확인  
if not exist "%NODE_DIR%\node.exe" (
    echo ❌ Node.js를 찾을 수 없습니다!
    echo    경로: %NODE_DIR%\node.exe
    pause
    exit /b 1
)

:: 앱 폴더 확인
if not exist "%APP_DIR%" (
    echo ❌ 앱 폴더를 찾을 수 없습니다!
    echo    경로: %APP_DIR%
    pause
    exit /b 1
)

echo  ✅ Python 확인: OK
echo  ✅ Node.js 확인: OK
echo  ✅ 앱 폴더 확인: OK
echo.
echo  [1/2] 백엔드 서버 시작 중...

:: 백엔드 서버 시작
start "부동산앱-백엔드" /min cmd /k "cd /d "%APP_DIR%\backend" && "%PYTHON_DIR%\python.exe" app.py"

echo  ✅ 백엔드 서버 시작됨
echo.
echo  잠시 대기 중... (3초)
timeout /t 3 /nobreak >nul

echo  [2/2] 프론트엔드 서버 시작 중...

:: 환경변수 설정
set "PATH=%NODE_DIR%;%PATH%"

:: 프론트엔드 서버 시작
start "부동산앱-프론트엔드" cmd /k "cd /d "%APP_DIR%" && "%NODE_DIR%\npm.cmd" run dev"

echo  ✅ 프론트엔드 서버 시작됨
echo.
echo  ╔═══════════════════════════════════════════════════════════════╗
echo  ║                     🎉 실행 완료!                            ║
echo  ╚═══════════════════════════════════════════════════════════════╝
echo.
echo  📱 브라우저에서 자동으로 열립니다...
echo     주소: http://localhost:3000
echo.
echo  ⏱️  서버 시작까지 5-10초 정도 걸립니다.
echo.
echo  ⚠️  종료 방법: 열린 2개의 검은 창을 닫으세요.
echo.
echo  🎯 5초 후 브라우저가 열립니다...
timeout /t 5 /nobreak >nul

:: 브라우저 열기
start http://localhost:3000

echo.
echo  ✅ 브라우저가 열렸습니다!
echo.
echo  이 창은 닫아도 됩니다.
echo.
pause
