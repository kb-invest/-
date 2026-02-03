@echo off
chcp 65001 >nul
cls

echo ╔═══════════════════════════════════════════════════════════════╗
echo ║   부동산 제안서 생성 시스템 - EXE 설치 파일 빌드              ║
echo ╚═══════════════════════════════════════════════════════════════╝
echo.
echo [INFO] EXE 설치 파일을 생성합니다...
echo.

:: PyInstaller 설치
echo [1/3] PyInstaller 설치 중...
pip install pyinstaller pywin32 >nul 2>&1
echo       ✓ PyInstaller 설치 완료

:: 프론트엔드 빌드
echo [2/3] 프론트엔드 빌드 중...
call npm run build >nul 2>&1
if exist dist (
    echo       ✓ 프론트엔드 빌드 완료
) else (
    echo       ⚠ 프론트엔드 빌드 실패 (계속 진행)
)

:: PyInstaller로 EXE 생성
echo [3/3] EXE 파일 생성 중... (1-2분 소요)
pyinstaller --name="부동산앱_설치" ^
    --onefile ^
    --windowed ^
    --icon=NONE ^
    --add-data="backend;backend" ^
    --add-data="templates;templates" ^
    --add-data="dist;dist" ^
    installer.py

if exist "dist\부동산앱_설치.exe" (
    echo.
    echo ╔═══════════════════════════════════════════════════════════════╗
    echo ║                  EXE 빌드 완료!                               ║
    echo ╚═══════════════════════════════════════════════════════════════╝
    echo.
    echo ✅ EXE 파일이 생성되었습니다!
    echo.
    echo 📁 위치: dist\부동산앱_설치.exe
    echo 📦 크기: 
    for %%A in ("dist\부동산앱_설치.exe") do echo       %%~zA bytes
    echo.
    echo 🚀 이 파일을 배포하여 사용하세요!
    echo.
    
    :: 파일 탐색기 열기
    explorer /select,"dist\부동산앱_설치.exe"
) else (
    echo.
    echo ╔═══════════════════════════════════════════════════════════════╗
    echo ║                  EXE 빌드 실패                                ║
    echo ╚═══════════════════════════════════════════════════════════════╝
    echo.
    echo ❌ EXE 파일 생성에 실패했습니다.
    echo.
    echo 💡 로그 확인: build\부동산앱_설치\warn-부동산앱_설치.txt
    echo.
)

pause
