@echo off
chcp 65001 >nul
echo ========================================
echo 휴대용 부동산 제안서 앱 자동 생성기
echo Portable Real Estate Proposal App Builder
echo ========================================
echo.
echo 이 스크립트는 자동으로:
echo 1. Python Portable 다운로드
echo 2. Node.js Portable 다운로드  
echo 3. 모든 의존성 설치
echo 4. USB 복사 가능한 휴대용 버전 생성
echo.
echo 예상 시간: 약 10분
echo 필요 용량: 약 1.5GB
echo.
pause

echo.
echo [1/6] 작업 폴더 생성 중...
mkdir portable-app 2>nul
cd portable-app
mkdir python node app 2>nul

echo [2/6] Python Portable 다운로드 중... (11MB)
powershell -Command "& {Invoke-WebRequest -Uri 'https://www.python.org/ftp/python/3.12.0/python-3.12.0-embed-amd64.zip' -OutFile 'python.zip'}"
powershell -Command "& {Expand-Archive -Path 'python.zip' -DestinationPath 'python' -Force}"
del python.zip

echo [3/6] Node.js Portable 다운로드 중... (29MB)
powershell -Command "& {Invoke-WebRequest -Uri 'https://nodejs.org/dist/v20.11.0/node-v20.11.0-win-x64.zip' -OutFile 'node.zip'}"
powershell -Command "& {Expand-Archive -Path 'node.zip' -DestinationPath 'node-temp' -Force}"
move node-temp\node-v20.11.0-win-x64\* node\
rmdir /s /q node-temp
del node.zip

echo [4/6] 앱 소스 복사 중...
echo 현재 폴더의 모든 파일을 app 폴더로 복사해야 합니다.
echo.
echo ⚠️  잠시 멈춤!
echo.
echo 다음 단계:
echo 1. 이 창을 최소화하세요
echo 2. GitHub에서 다운로드한 앱 파일들을
echo 3. portable-app\app\ 폴더에 복사하세요
echo 4. 복사가 완료되면 이 창으로 돌아와서 아무 키나 누르세요
echo.
pause

cd app

echo [5/6] Python 의존성 설치 중...
cd backend
..\..\python\python.exe -m pip install --no-warn-script-location -r requirements.txt
cd ..

echo [6/6] Node.js 의존성 설치 중... (시간이 걸립니다)
..\node\npm.cmd install

cd ..

echo.
echo ========================================
echo ✅ 휴대용 버전 생성 완료!
echo ========================================
echo.
echo 📁 생성된 폴더: portable-app
echo 💾 크기: 약 1-1.5GB
echo.
echo 🎯 사용 방법:
echo 1. portable-app 폴더 전체를 USB에 복사
echo 2. USB에서 start-portable.bat 실행
echo.
echo ⚠️  마지막 단계:
echo start-portable.bat 파일을 생성해야 합니다.
echo 메모장으로 다음 내용을 작성하세요:
echo.
echo ----------------------------------------
type nul
echo @echo off
echo cd app
echo start /min cmd /k "..\python\python.exe backend\app.py"
echo timeout /t 3 /nobreak
echo start cmd /k "..\node\npm.cmd run dev"
echo timeout /t 5 /nobreak
echo start http://localhost:3000
echo ----------------------------------------
echo.
echo 위 내용을 portable-app\start-portable.bat 으로 저장하세요!
echo.
pause
