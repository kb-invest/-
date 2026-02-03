@echo off
chcp 65001 >nul
color 0A
cls

echo.
echo  ╔════════════════════════════════════════════════════════════════╗
echo  ║                                                                ║
echo  ║      상업용 부동산 제안서 생성 시스템 - 자동 설치 프로그램     ║
echo  ║                                                                ║
echo  ║                     버전: 2.0.0 완전판                         ║
echo  ║                                                                ║
echo  ╚════════════════════════════════════════════════════════════════╝
echo.
echo  [INFO] 설치를 시작합니다...
echo.
timeout /t 2 /nobreak >nul

:: 관리자 권한 체크
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo  [WARNING] 관리자 권한이 필요할 수 있습니다.
    echo  [INFO] 계속 진행합니다...
    echo.
)

:: 현재 디렉토리 저장
set INSTALL_DIR=%~dp0
set INSTALL_DIR=%INSTALL_DIR:~0,-1%

echo  ╔════════════════════════════════════════════════════════════════╗
echo  ║  [1/6] 시스템 요구사항 확인                                    ║
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

:: Node.js 확인 (선택사항)
echo  [1-2] Node.js 확인 중...
node --version >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=1" %%i in ('node --version 2^>^&1') do set NODE_VER=%%i
    echo       ✓ Node.js 설치됨: %NODE_VER%
    set HAS_NODE=1
) else (
    echo       ⚠ Node.js 없음 (개발 모드 비활성화)
    set HAS_NODE=0
)

echo.
timeout /t 1 /nobreak >nul

echo  ╔════════════════════════════════════════════════════════════════╗
echo  ║  [2/6] Python 패키지 설치                                      ║
echo  ╚════════════════════════════════════════════════════════════════╝
echo.

echo  [2-1] Flask 및 필수 패키지 설치 중...
cd /d "%INSTALL_DIR%\backend"
python -m pip install --upgrade pip >nul 2>&1
pip install -r requirements.txt
if %errorlevel% equ 0 (
    echo       ✓ Python 패키지 설치 완료
) else (
    echo       ✗ Python 패키지 설치 실패
    echo       ✓ 계속 진행합니다...
)

cd /d "%INSTALL_DIR%"
echo.
timeout /t 1 /nobreak >nul

echo  ╔════════════════════════════════════════════════════════════════╗
echo  ║  [3/6] 프론트엔드 빌드                                         ║
echo  ╚════════════════════════════════════════════════════════════════╝
echo.

if %HAS_NODE% equ 1 (
    echo  [3-1] npm 패키지 설치 중... (2-3분 소요)
    call npm install >nul 2>&1
    if %errorlevel% equ 0 (
        echo       ✓ npm 패키지 설치 완료
    ) else (
        echo       ✗ npm 설치 실패 (무시하고 계속)
    )
    
    echo  [3-2] 프론트엔드 빌드 중... (1-2분 소요)
    call npm run build >nul 2>&1
    if %errorlevel% equ 0 (
        echo       ✓ 프론트엔드 빌드 완료
        set BUILD_SUCCESS=1
    ) else (
        echo       ✗ 빌드 실패 (기본 빌드 사용)
        set BUILD_SUCCESS=0
    )
) else (
    echo  [3-1] Node.js 없음 - 사전 빌드 버전 사용
    echo       ✓ 기본 빌드 사용
    set BUILD_SUCCESS=0
)

echo.
timeout /t 1 /nobreak >nul

echo  ╔════════════════════════════════════════════════════════════════╗
echo  ║  [4/6] 바탕화면 아이콘 생성                                    ║
echo  ╚════════════════════════════════════════════════════════════════╝
echo.

:: 바탕화면 경로 가져오기
for /f "tokens=3*" %%i in ('reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v Desktop 2^>nul') do set DESKTOP=%%j
for /f "tokens=*" %%i in ('echo %DESKTOP%') do set DESKTOP=%%i

:: 환경 변수 확장
call set DESKTOP=%DESKTOP%

echo  [4-1] 바탕화면 바로가기 생성 중...

:: VBS 스크립트로 바로가기 생성
(
echo Set oWS = WScript.CreateObject^("WScript.Shell"^)
echo sLinkFile = "%DESKTOP%\부동산 제안서 생성 시스템.lnk"
echo Set oLink = oWS.CreateShortcut^(sLinkFile^)
echo oLink.TargetPath = "%INSTALL_DIR%\부동산앱.vbs"
echo oLink.WorkingDirectory = "%INSTALL_DIR%"
echo oLink.Description = "상업용 부동산 제안서 생성 시스템"
echo oLink.Save
) > "%TEMP%\create_shortcut.vbs"

cscript //nologo "%TEMP%\create_shortcut.vbs" >nul 2>&1
del "%TEMP%\create_shortcut.vbs" >nul 2>&1

if exist "%DESKTOP%\부동산 제안서 생성 시스템.lnk" (
    echo       ✓ 바탕화면 아이콘 생성 완료!
    echo       📍 위치: %DESKTOP%\부동산 제안서 생성 시스템.lnk
) else (
    echo       ✗ 바탕화면 아이콘 생성 실패
    echo       ✓ 수동으로 "부동산앱.vbs" 바로가기를 만들어주세요
)

echo.
timeout /t 1 /nobreak >nul

echo  ╔════════════════════════════════════════════════════════════════╗
echo  ║  [5/6] 실행 파일 생성                                          ║
echo  ╚════════════════════════════════════════════════════════════════╝
echo.

:: 부동산앱.vbs 생성 (CMD 창 없이 실행)
echo  [5-1] 실행 스크립트 생성 중...
(
echo ' 상업용 부동산 제안서 생성 시스템
echo ' 제작: Rick for 비크님
echo ' 버전: 2.0.0
echo.
echo Set objShell = CreateObject^("WScript.Shell"^)
echo Set fso = CreateObject^("Scripting.FileSystemObject"^)
echo.
echo ' 현재 스크립트 디렉토리
echo currentDir = fso.GetParentFolderName^(WScript.ScriptFullName^)
echo.
echo ' 백엔드 서버 시작
echo objShell.Run "cmd /c cd /d """ ^& currentDir ^& "\backend"" ^^^&^^^& python app.py", 0, False
echo.
echo ' 백엔드 시작 대기
echo WScript.Sleep 3000
echo.
echo ' 프론트엔드 서버 시작
echo If fso.FolderExists^(currentDir ^& "\dist"^) Then
echo     objShell.Run "cmd /c cd /d """ ^& currentDir ^& """ ^^^&^^^& python -m http.server 3000 --directory dist", 0, False
echo ElseIf fso.FolderExists^(currentDir ^& "\public"^) Then
echo     objShell.Run "cmd /c cd /d """ ^& currentDir ^& """ ^^^&^^^& python -m http.server 3000 --directory public", 0, False
echo Else
echo     MsgBox "오류: 프론트엔드 파일을 찾을 수 없습니다!", vbCritical, "실행 오류"
echo     WScript.Quit
echo End If
echo.
echo ' 프론트엔드 시작 대기
echo WScript.Sleep 5000
echo.
echo ' 브라우저 열기
echo objShell.Run "http://localhost:3000"
echo.
echo ' 완료 메시지
echo MsgBox "상업용 부동산 제안서 생성 시스템이 실행되었습니다!" ^& vbCrLf ^& vbCrLf ^& _
echo        "브라우저: http://localhost:3000" ^& vbCrLf ^& vbCrLf ^& _
echo        "종료: 작업 관리자에서 python.exe 종료" ^& vbCrLf ^& _
echo        "또는 '종료.bat' 실행", _
echo        vbInformation, "부동산 제안서 시스템"
) > "%INSTALL_DIR%\부동산앱.vbs"

echo       ✓ 실행 스크립트 생성 완료
echo       📄 파일: %INSTALL_DIR%\부동산앱.vbs

:: 종료.bat 생성
echo  [5-2] 종료 스크립트 생성 중...
(
echo @echo off
echo chcp 65001 ^>nul
echo taskkill /F /IM python.exe ^>nul 2^>^&1
echo if %%errorlevel%% == 0 ^(
echo     echo 서버가 종료되었습니다.
echo ^) else ^(
echo     echo 실행 중인 서버가 없습니다.
echo ^)
echo timeout /t 2 /nobreak ^>nul
) > "%INSTALL_DIR%\종료.bat"

echo       ✓ 종료 스크립트 생성 완료
echo       📄 파일: %INSTALL_DIR%\종료.bat

echo.
timeout /t 1 /nobreak >nul

echo  ╔════════════════════════════════════════════════════════════════╗
echo  ║  [6/6] 설치 완료                                               ║
echo  ╚════════════════════════════════════════════════════════════════╝
echo.

echo  ✅ 설치가 완료되었습니다!
echo.
echo  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.
echo  🚀 사용 방법:
echo.
echo     1. 바탕화면의 "부동산 제안서 생성 시스템" 아이콘 더블클릭
echo     2. 브라우저가 자동으로 열립니다
echo     3. 앱을 사용하세요!
echo.
echo  🛑 종료 방법:
echo.
echo     - "종료.bat" 파일 실행
echo     - 또는 작업 관리자에서 python.exe 종료
echo.
echo  📁 설치 위치: %INSTALL_DIR%
echo.
echo  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.
echo  💡 팁:
echo.
echo     - API 키는 한 번만 입력하면 자동 저장됩니다
echo     - USB에 복사해서 다른 PC에서도 사용 가능합니다
echo     - Python만 설치되어 있으면 어디서든 실행됩니다
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
