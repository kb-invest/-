# 🏢 상업용 부동산 매각 제안서 자동 생성 시스템

## 💻 로컬 PC에서 실행하기

비크님, sandbox 환경의 제약으로 외부 브라우저 접속이 제한되고 있습니다.
대신 **비크님의 PC에서 직접 실행**하시면 완벽하게 작동합니다!

## 📦 설치 방법 (5분)

### 1단계: 프로그램 설치

#### Windows PC:

**1) Node.js 설치**
- https://nodejs.org 접속
- "LTS" 버전 다운로드 및 설치

**2) Python 설치**
- https://www.python.org/downloads/ 접속
- 최신 버전 다운로드 및 설치
- ⚠️ 설치 시 "Add Python to PATH" 체크!

### 2단계: 프로젝트 다운로드

압축 파일(`realestate-proposal-app.tar.gz`)을 다운로드하여 압축 해제

### 3단계: 실행

**터미널 (명령 프롬프트) 열기:**

```bash
# 프로젝트 폴더로 이동
cd [압축 해제한 폴더 경로]

# 의존성 설치 (최초 1회만)
npm install
cd backend
pip install -r requirements.txt
cd ..

# 백엔드 서버 실행 (첫 번째 터미널)
cd backend
python app.py

# 프론트엔드 실행 (두 번째 터미널)
npm run dev
```

### 4단계: 브라우저 접속

```
http://localhost:3000
```

완성! 🎉

---

## 🚀 더 간단한 방법: 실행 스크립트

### Windows 사용자:

**start.bat 파일 생성:**
```batch
@echo off
echo 상업용 부동산 제안서 생성 시스템 시작 중...

start cmd /k "cd backend && python app.py"
timeout /t 3
start cmd /k "npm run dev"

echo.
echo 브라우저에서 http://localhost:3000 을 열어주세요!
pause
```

더블클릭하면 자동으로 실행됩니다!

---

## ❓ 문제 해결

### "npm을 찾을 수 없습니다"
→ Node.js를 다시 설치하고 PC를 재부팅하세요

### "python을 찾을 수 없습니다"  
→ Python 설치 시 "Add to PATH" 옵션 체크했는지 확인

### 포트가 이미 사용 중
→ 3000번 또는 5000번 포트를 사용하는 다른 프로그램 종료

---

## 📞 도움이 필요하시면

언제든지 연락주세요! 원격으로 도와드리겠습니다.

**Developer**: Rick (20년차 앱개발자)
