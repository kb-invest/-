@echo off
chcp 65001 >nul
cls

echo ╔═══════════════════════════════════════════════════════════════╗
echo ║   상업용 부동산 제안서 생성 시스템 - USB 휴대용 빌드          ║
echo ╚═══════════════════════════════════════════════════════════════╝
echo.
echo [INFO] USB 휴대용 버전을 생성합니다...
echo.

:: 현재 디렉토리 저장
set CURRENT_DIR=%cd%

:: 출력 디렉토리 생성
set OUTPUT_DIR=%CURRENT_DIR%\portable_release
if exist "%OUTPUT_DIR%" (
    echo [STEP 1/7] 기존 빌드 폴더 삭제 중...
    rmdir /s /q "%OUTPUT_DIR%"
)

echo [STEP 1/7] 빌드 폴더 생성 중...
mkdir "%OUTPUT_DIR%"
mkdir "%OUTPUT_DIR%\backend"
mkdir "%OUTPUT_DIR%\public"
mkdir "%OUTPUT_DIR%\templates"
mkdir "%OUTPUT_DIR%\output"

:: 백엔드 파일 복사
echo [STEP 2/7] 백엔드 파일 복사 중...
xcopy /s /e /q "%CURRENT_DIR%\backend\*" "%OUTPUT_DIR%\backend\" >nul
xcopy /q "%CURRENT_DIR%\templates\*" "%OUTPUT_DIR%\templates\" >nul

:: 프론트엔드 빌드
echo [STEP 3/7] 프론트엔드 빌드 중... (1-2분 소요)
call npm run build
if errorlevel 1 (
    echo.
    echo [ERROR] 프론트엔드 빌드 실패!
    pause
    exit /b 1
)

:: 빌드된 파일 복사
echo [STEP 4/7] 빌드 파일 복사 중...
xcopy /s /e /q "%CURRENT_DIR%\dist\*" "%OUTPUT_DIR%\public\" >nul

:: 실행 스크립트 생성
echo [STEP 5/7] 실행 스크립트 생성 중...

:: START.BAT 생성
(
echo @echo off
echo chcp 65001 ^>nul
echo cls
echo.
echo ╔═══════════════════════════════════════════════════════════════╗
echo ║   상업용 부동산 제안서 생성 시스템 - USB 휴대용 버전          ║
echo ╚═══════════════════════════════════════════════════════════════╝
echo.
echo [INFO] 시스템을 시작합니다...
echo.
echo.
echo :: 실행 방법을 선택하세요
echo.
echo [1] CMD 창 보이기 ^(개발자 모드^)
echo [2] CMD 창 숨기기 ^(일반 사용자 모드^)
echo.
set /p choice="선택 (1 or 2): "
echo.
if "%%choice%%"=="2" (
    echo [INFO] 숨김 모드로 실행합니다...
    cscript //nologo start-silent.vbs
    exit
)
echo.
echo [INFO] 개발자 모드로 실행합니다...
echo [INFO] CMD 창 2개가 열립니다. 사용 후 닫아주세요.
echo.
echo [1/3] 백엔드 서버 시작 중...
start "부동산 앱 - 백엔드" cmd /k "cd /d %%~dp0backend && python app.py"
timeout /t 3 /nobreak ^>nul
echo       ✓ 백엔드 실행 완료 ^(http://127.0.0.1:5000^)
echo.
echo [2/3] 프론트엔드 서버 시작 중...
start "부동산 앱 - 프론트엔드" cmd /k "cd /d %%~dp0 && python -m http.server 3000 --directory public"
timeout /t 3 /nobreak ^>nul
echo       ✓ 프론트엔드 실행 완료 ^(http://localhost:3000^)
echo.
echo [3/3] 브라우저 실행 중...
timeout /t 2 /nobreak ^>nul
start http://localhost:3000
echo       ✓ 브라우저 열기 완료
echo.
echo ╔═══════════════════════════════════════════════════════════════╗
echo ║                    시스템 실행 완료!                          ║
echo ║                                                               ║
echo ║  브라우저에서 http://localhost:3000 을 확인하세요             ║
echo ║                                                               ║
echo ║  종료: STOP.BAT 실행 또는 CMD 창 2개 닫기                     ║
echo ╚═══════════════════════════════════════════════════════════════╝
echo.
pause
) > "%OUTPUT_DIR%\START.BAT"

:: start-silent.vbs 생성
(
echo ' 상업용 부동산 제안서 생성 시스템 - 숨김 모드
echo Set objShell = CreateObject^("WScript.Shell"^)
echo Set fso = CreateObject^("Scripting.FileSystemObject"^)
echo currentDir = fso.GetParentFolderName^(WScript.ScriptFullName^)
echo objShell.Run "cmd /c cd /d """ ^& currentDir ^& "\backend"" ^^^&^^^& python app.py", 0, False
echo WScript.Sleep 3000
echo objShell.Run "cmd /c cd /d """ ^& currentDir ^& """ ^^^&^^^& python -m http.server 3000 --directory public", 0, False
echo WScript.Sleep 5000
echo objShell.Run "http://localhost:3000"
echo MsgBox "상업용 부동산 제안서 생성 시스템이 실행되었습니다!" ^& vbCrLf ^& vbCrLf ^& "브라우저: http://localhost:3000" ^& vbCrLf ^& vbCrLf ^& "종료: STOP.BAT 실행", vbInformation, "앱 실행 완료"
) > "%OUTPUT_DIR%\start-silent.vbs"

:: STOP.BAT 생성
(
echo @echo off
echo chcp 65001 ^>nul
echo cls
echo.
echo ╔═══════════════════════════════════════════════════════════════╗
echo ║       상업용 부동산 제안서 생성 시스템 - 서버 종료            ║
echo ╚═══════════════════════════════════════════════════════════════╝
echo.
echo [INFO] 실행 중인 서버를 종료합니다...
echo.
echo [1/2] 프론트엔드 서버 종료 중...
taskkill /F /IM python.exe /FI "WINDOWTITLE eq 부동산 앱*" 2^>nul
if %%errorlevel%% == 0 ^(
    echo       ✓ 서버 종료 완료
^) else ^(
    echo       ✗ 실행 중인 서버 없음
^)
echo.
echo [2/2] 백엔드 서버 종료 중...
taskkill /F /IM python.exe 2^>nul
if %%errorlevel%% == 0 ^(
    echo       ✓ 서버 종료 완료
^) else ^(
    echo       ✗ 실행 중인 서버 없음
^)
echo.
echo ╔═══════════════════════════════════════════════════════════════╗
echo ║                    서버 종료 완료                             ║
echo ╚═══════════════════════════════════════════════════════════════╝
echo.
pause
) > "%OUTPUT_DIR%\STOP.BAT"

:: README 생성
echo [STEP 6/7] 문서 생성 중...
(
echo # 상업용 부동산 제안서 생성 시스템 - USB 휴대용 버전
echo.
echo ## 📦 시스템 요구사항
echo.
echo - ✅ **Python 3.8+** 설치 필요
echo - ✅ **인터넷 연결** 필요 ^(공공데이터 API 호출^)
echo.
echo ## 🚀 사용 방법
echo.
echo ### 1단계: START.BAT 실행
echo.
echo 1. **START.BAT 더블클릭**
echo 2. **모드 선택:**
echo    - **[1] 개발자 모드**: CMD 창 보임 ^(에러 확인 가능^)
echo    - **[2] 일반 모드**: CMD 창 숨김 ^(깔끔하게 실행^)
echo 3. **브라우저 자동 열림** ^(http://localhost:3000^)
echo.
echo ### 2단계: 앱 사용
echo.
echo 1. **API 키 입력** ^(공공데이터포털 - data.go.kr^)
echo 2. **주소 입력** ^(예: 서울특별시 강남구 테헤란로 508-12^)
echo 3. **정보 입력** ^(매각가, 임대료, 사진 등^)
echo 4. **제안서 생성** ^(TV 브리핑용 / 인쇄용^)
echo.
echo ### 3단계: 종료
echo.
echo - **STOP.BAT 더블클릭** 또는
echo - **CMD 창 2개 닫기** ^(개발자 모드 사용 시^)
echo.
echo ## 📁 파일 구조
echo.
echo ```
echo portable_release/
echo ├── START.BAT           ← 앱 실행 ^(여기서 시작!^)
echo ├── STOP.BAT            ← 앱 종료
echo ├── start-silent.vbs    ← 숨김 모드 스크립트
echo ├── backend/            ← Flask 백엔드 서버
echo ├── public/             ← React 프론트엔드 ^(빌드됨^)
echo ├── templates/          ← PPTX 템플릿 파일
echo └── output/             ← 생성된 제안서 저장 폴더
echo ```
echo.
echo ## ⚠️ 문제 해결
echo.
echo ### Python을 찾을 수 없습니다
echo.
echo - **Python 설치**: https://python.org/downloads
echo - **설치 시 'Add Python to PATH' 체크!**
echo - **PC 재부팅**
echo.
echo ### 포트 충돌 ^(이미 사용 중^)
echo.
echo ```bash
echo # 포트 사용 확인
echo netstat -ano ^| findstr :3000
echo netstat -ano ^| findstr :5000
echo.
echo # 프로세스 종료
echo taskkill /F /PID [PID번호]
echo ```
echo.
echo ### API 키 오류
echo.
echo - **공공데이터포털** 가입: https://data.go.kr
echo - **건축물대장 API** 신청
echo - **승인 대기** ^(1-2일^)
echo - **인코딩된 키 사용** ^(디코딩 키 아님!^)
echo.
echo ## 💡 팁
echo.
echo - ✅ **API 키는 한 번만 입력!** ^(자동 저장됨^)
echo - ✅ **USB에 복사해서 사용 가능!**
echo - ✅ **Python만 설치되어 있으면 어디서든 실행!**
echo.
echo ## 📞 도움말
echo.
echo - **제작자**: Rick
echo - **버전**: 1.0.0 Portable
echo - **날짜**: 2026-02-03
echo.
echo ---
echo.
echo **Made with ❤️ by Rick for 비크님**
) > "%OUTPUT_DIR%\README.md"

echo [STEP 7/7] 최종 검증 중...
echo.
echo ╔═══════════════════════════════════════════════════════════════╗
echo ║                  USB 휴대용 빌드 완료!                        ║
echo ╚═══════════════════════════════════════════════════════════════╝
echo.
echo [SUCCESS] 빌드 결과:
echo.
echo 📦 출력 폴더: %OUTPUT_DIR%
echo.
echo 📁 포함된 파일:
echo    ✅ START.BAT           - 앱 실행 파일
echo    ✅ STOP.BAT            - 앱 종료 파일
echo    ✅ start-silent.vbs    - 숨김 모드 스크립트
echo    ✅ backend/            - Flask 백엔드
echo    ✅ public/             - React 프론트엔드 (빌드됨)
echo    ✅ templates/          - PPTX 템플릿
echo    ✅ README.md           - 사용 설명서
echo.
echo 🚀 다음 단계:
echo    1. portable_release 폴더를 USB에 복사
echo    2. START.BAT 더블클릭하여 실행
echo    3. 브라우저에서 앱 사용!
echo.
echo 💡 폴더를 열어볼까요?
echo.
set /p open="폴더 열기? (y/n): "
if /i "%open%"=="y" (
    start explorer "%OUTPUT_DIR%"
)
echo.
pause
