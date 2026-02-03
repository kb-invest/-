@echo off
chcp 65001 > nul
echo ========================================
echo  상업용 부동산 제안서 앱 설치 스크립트
echo  by Rick for 비크님
echo ========================================
echo.

echo [1/4] 현재 위치 확인...
cd /d "%~dp0"
echo 현재 폴더: %CD%
echo.

echo [2/4] Node.js 의존성 설치 중... (2-3분 소요)
echo.
call npm install
if errorlevel 1 (
    echo.
    echo ❌ 오류: npm install 실패
    echo.
    echo 해결 방법:
    echo 1. Node.js가 설치되어 있는지 확인 (https://nodejs.org)
    echo 2. PC를 재부팅 후 다시 시도
    echo.
    pause
    exit /b 1
)
echo.
echo ✅ Node.js 의존성 설치 완료!
echo.

echo [3/4] Python 의존성 설치 중... (1-2분 소요)
echo.
cd backend
call pip install -r requirements.txt
if errorlevel 1 (
    echo.
    echo ❌ 오류: pip install 실패
    echo.
    echo 해결 방법:
    echo 1. Python이 설치되어 있는지 확인 (https://python.org)
    echo 2. Python 설치 시 "Add Python to PATH" 체크했는지 확인
    echo 3. PC를 재부팅 후 다시 시도
    echo.
    cd ..
    pause
    exit /b 1
)
cd ..
echo.
echo ✅ Python 의존성 설치 완료!
echo.

echo [4/4] 설치 완료!
echo.
echo ========================================
echo  설치가 성공적으로 완료되었습니다! 🎉
echo ========================================
echo.
echo 이제 "start.bat"을 더블클릭하여 앱을 실행하세요!
echo.
pause
