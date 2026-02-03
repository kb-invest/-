@echo off
chcp 65001 >nul
echo ========================================
echo 상업용 부동산 제안서 생성 시스템 업데이트
echo ========================================
echo.

echo [1/2] 최신 코드 다운로드 중...
git pull origin main

echo.
echo [2/2] 프론트엔드 재빌드 중...
npm install

echo.
echo ========================================
echo ✅ 업데이트 완료!
echo ========================================
echo.
echo 이제 start.bat을 실행하세요!
echo.
pause
