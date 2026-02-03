@echo off
chcp 65001 >nul
color 0A
cls

echo.
echo  ╔════════════════════════════════════════════════════════════════╗
echo  ║                                                                ║
echo  ║      상업용 부동산 제안서 생성 시스템 - 간편 설치             ║
echo  ║                                                                ║
echo  ║                     버전: 2.0.0 완전판                         ║
echo  ║                                                                ║
echo  ╚════════════════════════════════════════════════════════════════╝
echo.
echo  [INFO] 설치를 시작합니다...
echo.
timeout /t 2 /nobreak >nul

:: 현재 디렉토리 저장
set INSTALL_DIR=%~dp0
set INSTALL_DIR=%INSTALL_DIR:~0,-1%

echo  ╔════════════════════════════════════════════════════════════════╗
echo  ║  [1/4] 시스템 요구사항 확인                                    ║
echo  ╚════════════════════════════════════════════════════════════════╝
echo.

:: Python 확인
echo  [1-1] Python 확인 중...
python --version >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=2" %%i in ('python --version 2^>^&1') do set PYTHON_VER=%%i
    echo       ✓ Python 설치됨: %PYTHON_VER%
) else (
    echo       ✗ Python이 설치되지 않았습니다!
    echo.
    echo  [ERROR] Python 3.8 이상이 필요합니다.
    echo.
    echo  Python 설치 방법:
    echo  1. https://python.org/downloads 방문
    echo  2. "Download Python" 버튼 클릭
    echo  3. 설치 시 "Add Python to PATH" 체크!
    echo  4. 설치 후 PC 재부팅
    echo  5. 이 설치 프로그램 다시 실행
    echo.
    pause
    exit /b 1
)

echo.
timeout /t 1 /nobreak >nul

echo  ╔════════════════════════════════════════════════════════════════╗
echo  ║  [2/4] Python 패키지 설치                                      ║
echo  ╚════════════════════════════════════════════════════════════════╝
echo.

echo  [2-1] Flask 및 필수 패키지 설치 중...
cd /d "%INSTALL_DIR%\backend"
python -m pip install --upgrade pip >nul 2>&1
pip install -r requirements.txt >nul 2>&1
if %errorlevel% equ 0 (
    echo       ✓ Python 패키지 설치 완료
) else (
    echo       ⚠ Python 패키지 설치 경고 (계속 진행)
)

cd /d "%INSTALL_DIR%"
echo.
timeout /t 1 /nobreak >nul

echo  ╔════════════════════════════════════════════════════════════════╗
echo  ║  [3/4] 실행 파일 생성                                          ║
echo  ╚════════════════════════════════════════════════════════════════╝
echo.

:: 부동산앱.vbs 생성 (간단 버전)
echo  [3-1] 실행 스크립트 생성 중...
echo Set objShell = CreateObject("WScript.Shell") > "%INSTALL_DIR%\부동산앱.vbs"
echo Set fso = CreateObject("Scripting.FileSystemObject") >> "%INSTALL_DIR%\부동산앱.vbs"
echo currentDir = fso.GetParentFolderName(WScript.ScriptFullName) >> "%INSTALL_DIR%\부동산앱.vbs"
echo objShell.Run "cmd /c cd /d """ ^& currentDir ^& "\backend"" ^&^& python app.py", 0, False >> "%INSTALL_DIR%\부동산앱.vbs"
echo WScript.Sleep 3000 >> "%INSTALL_DIR%\부동산앱.vbs"
echo objShell.Run "cmd /c cd /d """ ^& currentDir ^& """ ^&^& npm run dev", 0, False >> "%INSTALL_DIR%\부동산앱.vbs"
echo WScript.Sleep 5000 >> "%INSTALL_DIR%\부동산앱.vbs"
echo objShell.Run "http://localhost:3000" >> "%INSTALL_DIR%\부동산앱.vbs"
echo MsgBox "부동산 제안서 시스템이 실행되었습니다!" ^& vbCrLf ^& "브라우저: http://localhost:3000", vbInformation, "실행 완료" >> "%INSTALL_DIR%\부동산앱.vbs"

echo       ✓ 실행 스크립트 생성 완료

:: 종료.bat 생성
echo  [3-2] 종료 스크립트 생성 중...
echo @echo off > "%INSTALL_DIR%\종료.bat"
echo chcp 65001 ^>nul >> "%INSTALL_DIR%\종료.bat"
echo taskkill /F /IM python.exe ^>nul 2^>^&1 >> "%INSTALL_DIR%\종료.bat"
echo taskkill /F /IM node.exe ^>nul 2^>^&1 >> "%INSTALL_DIR%\종료.bat"
echo echo 서버가 종료되었습니다. >> "%INSTALL_DIR%\종료.bat"
echo timeout /t 2 /nobreak ^>nul >> "%INSTALL_DIR%\종료.bat"

echo       ✓ 종료 스크립트 생성 완료

echo.
timeout /t 1 /nobreak >nul

echo  ╔════════════════════════════════════════════════════════════════╗
echo  ║  [4/4] 바탕화면 바로가기 생성                                  ║
echo  ╚════════════════════════════════════════════════════════════════╝
echo.

:: PowerShell로 바탕화면 바로가기 생성
echo  [4-1] 바탕화면 바로가기 생성 중...

powershell -Command "$WshShell = New-Object -ComObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut([Environment]::GetFolderPath('Desktop') + '\부동산 제안서 생성 시스템.lnk'); $Shortcut.TargetPath = '%INSTALL_DIR%\부동산앱.vbs'; $Shortcut.WorkingDirectory = '%INSTALL_DIR%'; $Shortcut.Description = '상업용 부동산 제안서 생성 시스템'; $Shortcut.Save()"

if exist "%USERPROFILE%\Desktop\부동산 제안서 생성 시스템.lnk" (
    echo       ✓ 바탕화면 아이콘 생성 완료!
) else (
    echo       ⚠ 바탕화면 아이콘 생성 실패
    echo       ✓ 수동으로 "부동산앱.vbs" 바로가기를 만들어주세요
)

echo.
timeout /t 1 /nobreak >nul

echo  ╔════════════════════════════════════════════════════════════════╗
echo  ║  [완료] 설치가 완료되었습니다!                                 ║
echo  ╚════════════════════════════════════════════════════════════════╝
echo.
echo  ✅ 설치 완료!
echo.
echo  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.
echo  🚀 사용 방법:
echo.
echo     바탕화면의 "부동산 제안서 생성 시스템" 아이콘 더블클릭!
echo     → 5초 후 브라우저 자동 열림
echo.
echo  🛑 종료 방법:
echo.
echo     "종료.bat" 파일 실행
echo.
echo  📁 설치 위치: %INSTALL_DIR%
echo.
echo  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.
echo.

set /p run="지금 바로 실행하시겠습니까? (y/n): "
if /i "%run%"=="y" (
    echo.
    echo  [INFO] 앱을 실행합니다...
    start "" "%INSTALL_DIR%\부동산앱.vbs"
    timeout /t 2 /nobreak >nul
    exit
)

echo.
echo  설치 프로그램을 종료합니다.
echo.
pause
