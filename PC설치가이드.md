# 🏢 상업용 부동산 매각 제안서 자동 생성 시스템
## PC 설치 가이드

---

## 📦 1단계: 필수 프로그램 설치 (10분)

### Windows 사용자

#### 1) Node.js 설치
1. https://nodejs.org 접속
2. **"LTS" 버전** 다운로드 (왼쪽 버튼)
3. 다운로드한 파일 실행
4. 설치 마법사에서 **"Next" 계속 클릭**
5. 설치 완료!

#### 2) Python 설치  
1. https://www.python.org/downloads/ 접속
2. **"Download Python 3.x"** 클릭
3. 다운로드한 파일 실행
4. ⚠️ **중요**: 첫 화면에서 **"Add Python to PATH" 체크** ✅
5. "Install Now" 클릭
6. 설치 완료!

#### 3) 설치 확인
명령 프롬프트(cmd) 열고 확인:
```bash
node --version
# 출력 예: v20.11.0

python --version  
# 출력 예: Python 3.12.0
```

버전이 표시되면 성공! ✅

---

## 📥 2단계: 프로젝트 다운로드 및 압축 해제

1. **`realestate-proposal-app.tar.gz`** 파일 다운로드
2. 원하는 폴더에 압축 해제
   - 7-Zip 또는 WinRAR 사용
   - 또는 Windows 내장 압축 해제 사용

**권장 위치**: `C:\부동산앱\` 또는 `D:\부동산앱\`

---

## ⚙️ 3단계: 의존성 설치 (최초 1회만, 5분)

### 명령 프롬프트(cmd) 열기:
1. `시작 메뉴` → `cmd` 입력 → Enter
2. 프로젝트 폴더로 이동:
```bash
cd C:\부동산앱\realestate-proposal-app
```

### Node.js 의존성 설치:
```bash
npm install
```
⏱️ 2-3분 소요

### Python 의존성 설치:
```bash
cd backend
pip install -r requirements.txt
cd ..
```
⏱️ 1-2분 소요

---

## 🚀 4단계: 실행 (매우 간단!)

### 방법 1: 자동 실행 (권장) ⭐

**`start.bat`** 파일을 더블클릭하면 끝!

→ 자동으로 백엔드 + 프론트엔드 실행
→ 5초 후 브라우저 자동 오픈!

### 방법 2: 수동 실행

#### 첫 번째 명령 프롬프트:
```bash
cd C:\부동산앱\realestate-proposal-app\backend
python app.py
```

#### 두 번째 명령 프롬프트 (새로 열기):
```bash
cd C:\부동산앱\realestate-proposal-app
npm run dev
```

#### 브라우저에서 접속:
```
http://localhost:3000
```

---

## 🎉 5단계: 사용 시작!

브라우저에 앱이 열리면 완성입니다! 🎊

### 첫 사용 가이드:

1. **API 키 입력** (공공데이터포털에서 발급)
2. **주소 입력** → 검색
3. **AI 프롬프트 가이드**에서 멋진 문구 생성
4. **정보 입력** (매각가, 임대료, 사진 등)
5. **제안서 생성** 클릭!

📄 **TV 브리핑용** 또는 **인쇄용** 선택
→ PPTX 파일 자동 다운로드!

---

## 🛑 종료 방법

### 방법 1 (자동 실행 사용 시):
- 열린 **2개의 검은 창(터미널)**을 닫기

### 방법 2 (수동 실행 시):
- 각 명령 프롬프트에서 **Ctrl + C** 누르기
- 또는 창 닫기

---

## ❓ 문제 해결

### "npm을 찾을 수 없습니다"
**해결**: 
1. Node.js 재설치
2. 설치 중 모든 옵션 기본값 유지
3. PC 재부팅
4. 명령 프롬프트를 **새로 열기**

### "python을 찾을 수 없습니다"
**해결**:
1. Python 재설치
2. ⚠️ **"Add Python to PATH" 반드시 체크**
3. PC 재부팅
4. 명령 프롬프트를 **새로 열기**

### 포트 사용 중 에러
**해결**:
```bash
# 3000번 포트 사용 프로그램 종료
netstat -ano | findstr :3000
taskkill /F /PID [프로세스번호]

# 5000번 포트도 동일하게
netstat -ano | findstr :5000
taskkill /F /PID [프로세스번호]
```

### "Module not found" 에러
**해결**:
```bash
# 프로젝트 폴더에서
npm install

# 백엔드 폴더에서
cd backend
pip install -r requirements.txt
```

### 브라우저가 자동으로 안 열릴 때
**해결**:
- 수동으로 브라우저 열고 주소창에 입력:
  ```
  http://localhost:3000
  ```

---

## 📞 도움이 필요하시면

**개발자: Rick (20년차 앱개발자)**

문제가 생기면:
1. 에러 메시지 스크린샷
2. 어떤 단계에서 문제 발생했는지
3. Windows 버전

위 정보와 함께 연락주세요!

---

## 🎯 다음 단계

앱 설치가 완료되면:

1. **`USAGE.md`** - 빠른 사용 가이드
2. **`README.md`** - 전체 기능 설명
3. **템플릿 커스터마이징** - `templates/` 폴더의 PPTX 수정 가능

---

## 📋 체크리스트

설치 전 확인:
- [ ] Node.js 설치 완료
- [ ] Python 설치 완료 (Add to PATH 체크!)
- [ ] 압축 파일 다운로드 및 해제
- [ ] `npm install` 실행
- [ ] `pip install -r requirements.txt` 실행
- [ ] `start.bat` 더블클릭 또는 수동 실행
- [ ] 브라우저에서 http://localhost:3000 접속

모두 체크되면 완료! ✅

---

**즐거운 제안서 작성 되세요! 🏢✨**

Made with ❤️ by Rick for 비크님
