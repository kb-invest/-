@echo off
chcp 65001 >nul
echo ========================================
echo 상업용 부동산 제안서 생성 시스템
echo Commercial Real Estate Proposal Generator
echo ========================================
echo.

echo [1/2] 백엔드 서버 시작 중...
start "백엔드 서버" cmd /k "cd backend && echo 백엔드 서버 실행 중... && python app.py"

echo [2/2] 프론트엔드 서버 시작 중...
timeout /t 3 /nobreak >nul
start "프론트엔드 서버" cmd /k "echo 프론트엔드 서버 실행 중... && npm run dev"

echo.
echo ✅ 서버 시작 완료!
echo.
echo 📱 3-5초 후 자동으로 브라우저가 열립니다...
echo    수동으로 열려면: http://localhost:3000
echo.
echo ⚠️  종료하려면: 열린 두 개의 터미널 창을 닫으세요
echo.

timeout /t 5 /nobreak >nul
start http://localhost:3000

pause
