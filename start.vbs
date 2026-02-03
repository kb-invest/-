' 상업용 부동산 제안서 생성 시스템 - 숨김 모드 실행
' CMD 창 없이 백그라운드에서 서버 실행

Set objShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

' 현재 스크립트의 디렉토리 경로 가져오기
currentDir = fso.GetParentFolderName(WScript.ScriptFullName)

' 백엔드 서버 시작 (CMD 창 숨김)
objShell.Run "cmd /c cd /d """ & currentDir & "\backend"" && python app.py", 0, False

' 2초 대기 (백엔드 서버 시작 대기)
WScript.Sleep 2000

' 프론트엔드 서버 시작 (CMD 창 숨김)
objShell.Run "cmd /c cd /d """ & currentDir & """ && npm run dev", 0, False

' 5초 대기 (프론트엔드 서버 시작 대기)
WScript.Sleep 5000

' 브라우저 열기
objShell.Run "http://localhost:3000"

' 메시지 표시
MsgBox "상업용 부동산 제안서 생성 시스템이 실행되었습니다!" & vbCrLf & vbCrLf & _
       "브라우저: http://localhost:3000" & vbCrLf & vbCrLf & _
       "종료하려면 작업 관리자에서 node.exe와 python.exe를 종료하세요.", _
       vbInformation, "앱 실행 완료"
