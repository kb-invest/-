"""
상업용 부동산 제안서 생성 시스템 - 자동 설치 프로그램
제작: Rick for 비크님
버전: 2.0.0 EXE Edition
"""

import os
import sys
import subprocess
import shutil
import winreg
from pathlib import Path
import tkinter as tk
from tkinter import messagebox, ttk
import threading
import zipfile
import urllib.request

class InstallerGUI:
    def __init__(self):
        self.root = tk.Tk()
        self.root.title("부동산 제안서 생성 시스템 - 설치")
        self.root.geometry("600x400")
        self.root.resizable(False, False)
        
        # 설치 경로
        self.install_path = Path(os.environ['USERPROFILE']) / "부동산앱"
        
        self.create_widgets()
        
    def create_widgets(self):
        # 타이틀
        title_frame = tk.Frame(self.root, bg="#2c3e50", height=80)
        title_frame.pack(fill=tk.X)
        
        title_label = tk.Label(
            title_frame,
            text="상업용 부동산 제안서 생성 시스템",
            font=("맑은 고딕", 16, "bold"),
            bg="#2c3e50",
            fg="white"
        )
        title_label.pack(pady=20)
        
        version_label = tk.Label(
            title_frame,
            text="버전 2.0.0 완전판",
            font=("맑은 고딕", 10),
            bg="#2c3e50",
            fg="#ecf0f1"
        )
        version_label.pack()
        
        # 메인 프레임
        main_frame = tk.Frame(self.root, padx=30, pady=20)
        main_frame.pack(fill=tk.BOTH, expand=True)
        
        # 설명
        desc_label = tk.Label(
            main_frame,
            text="이 프로그램은 상업용 부동산 매각 제안서를 자동으로 생성합니다.\n"
                 "설치 버튼을 클릭하여 시작하세요.",
            font=("맑은 고딕", 10),
            justify=tk.LEFT
        )
        desc_label.pack(pady=10)
        
        # 설치 경로
        path_frame = tk.Frame(main_frame)
        path_frame.pack(fill=tk.X, pady=10)
        
        path_label = tk.Label(
            path_frame,
            text="설치 경로:",
            font=("맑은 고딕", 9)
        )
        path_label.pack(side=tk.LEFT)
        
        self.path_entry = tk.Entry(
            path_frame,
            font=("맑은 고딕", 9),
            width=40
        )
        self.path_entry.insert(0, str(self.install_path))
        self.path_entry.pack(side=tk.LEFT, padx=10)
        
        # 진행률 바
        self.progress = ttk.Progressbar(
            main_frame,
            mode='determinate',
            length=500
        )
        self.progress.pack(pady=20)
        
        # 상태 레이블
        self.status_label = tk.Label(
            main_frame,
            text="설치 준비 완료",
            font=("맑은 고딕", 9),
            fg="#27ae60"
        )
        self.status_label.pack()
        
        # 버튼 프레임
        button_frame = tk.Frame(main_frame)
        button_frame.pack(pady=20)
        
        self.install_button = tk.Button(
            button_frame,
            text="설치",
            font=("맑은 고딕", 10, "bold"),
            bg="#27ae60",
            fg="white",
            width=15,
            height=2,
            command=self.start_installation
        )
        self.install_button.pack(side=tk.LEFT, padx=5)
        
        cancel_button = tk.Button(
            button_frame,
            text="취소",
            font=("맑은 고딕", 10),
            width=15,
            height=2,
            command=self.root.quit
        )
        cancel_button.pack(side=tk.LEFT, padx=5)
        
    def update_status(self, message, progress_value=None):
        self.status_label.config(text=message)
        if progress_value is not None:
            self.progress['value'] = progress_value
        self.root.update()
        
    def start_installation(self):
        self.install_button.config(state=tk.DISABLED)
        thread = threading.Thread(target=self.install)
        thread.start()
        
    def install(self):
        try:
            # 1단계: Python 확인
            self.update_status("Python 확인 중...", 10)
            if not self.check_python():
                messagebox.showerror(
                    "오류",
                    "Python이 설치되지 않았습니다.\n\n"
                    "https://python.org/downloads 에서\n"
                    "Python을 설치한 후 다시 시도해주세요.\n\n"
                    "설치 시 'Add Python to PATH' 체크 필수!"
                )
                self.install_button.config(state=tk.NORMAL)
                return
            
            # 2단계: 설치 폴더 생성
            self.update_status("설치 폴더 생성 중...", 20)
            self.install_path = Path(self.path_entry.get())
            self.install_path.mkdir(parents=True, exist_ok=True)
            
            # 3단계: 파일 복사
            self.update_status("파일 복사 중...", 30)
            self.copy_files()
            
            # 4단계: Python 패키지 설치
            self.update_status("Python 패키지 설치 중... (2-3분 소요)", 50)
            self.install_python_packages()
            
            # 5단계: 실행 파일 생성
            self.update_status("실행 파일 생성 중...", 70)
            self.create_launcher()
            
            # 6단계: 바탕화면 아이콘 생성
            self.update_status("바탕화면 아이콘 생성 중...", 85)
            self.create_desktop_shortcut()
            
            # 7단계: 시작 메뉴 등록
            self.update_status("시작 메뉴 등록 중...", 95)
            self.create_start_menu_shortcut()
            
            # 완료
            self.update_status("설치 완료!", 100)
            
            result = messagebox.askyesno(
                "설치 완료",
                "상업용 부동산 제안서 생성 시스템 설치가 완료되었습니다!\n\n"
                "바탕화면의 '부동산 제안서 생성 시스템' 아이콘을 더블클릭하여\n"
                "프로그램을 실행할 수 있습니다.\n\n"
                "지금 바로 실행하시겠습니까?"
            )
            
            if result:
                self.launch_app()
                
            self.root.quit()
            
        except Exception as e:
            messagebox.showerror(
                "오류",
                f"설치 중 오류가 발생했습니다:\n\n{str(e)}"
            )
            self.install_button.config(state=tk.NORMAL)
            
    def check_python(self):
        try:
            result = subprocess.run(
                ['python', '--version'],
                capture_output=True,
                text=True
            )
            return result.returncode == 0
        except:
            return False
            
    def copy_files(self):
        # 현재 실행 파일의 디렉토리에서 파일 복사
        source_dir = Path(sys._MEIPASS if hasattr(sys, '_MEIPASS') else os.path.dirname(__file__))
        
        # 필요한 폴더들 복사
        folders_to_copy = ['backend', 'templates', 'dist', 'public']
        
        for folder in folders_to_copy:
            src = source_dir / folder
            dst = self.install_path / folder
            if src.exists():
                if dst.exists():
                    shutil.rmtree(dst)
                shutil.copytree(src, dst)
                
    def install_python_packages(self):
        requirements = self.install_path / 'backend' / 'requirements.txt'
        if requirements.exists():
            subprocess.run(
                ['python', '-m', 'pip', 'install', '-r', str(requirements)],
                capture_output=True
            )
            
    def create_launcher(self):
        # VBS 실행 스크립트 생성
        vbs_content = f'''Set objShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")
currentDir = "{str(self.install_path).replace(chr(92), chr(92) + chr(92))}"

objShell.Run "cmd /c cd /d """ & currentDir & "\\backend"" && python app.py", 0, False
WScript.Sleep 3000
objShell.Run "cmd /c cd /d """ & currentDir & """ && npm run dev", 0, False
WScript.Sleep 5000
objShell.Run "http://localhost:3000"

MsgBox "부동산 제안서 시스템이 실행되었습니다!" & vbCrLf & "브라우저: http://localhost:3000", vbInformation, "실행 완료"
'''
        
        vbs_file = self.install_path / '부동산앱.vbs'
        with open(vbs_file, 'w', encoding='utf-8') as f:
            f.write(vbs_content)
            
        # 종료 스크립트 생성
        bat_content = '''@echo off
chcp 65001 >nul
taskkill /F /IM python.exe >nul 2>&1
taskkill /F /IM node.exe >nul 2>&1
echo 서버가 종료되었습니다.
timeout /t 2 /nobreak >nul
'''
        
        bat_file = self.install_path / '종료.bat'
        with open(bat_file, 'w', encoding='utf-8') as f:
            f.write(bat_content)
            
    def create_desktop_shortcut(self):
        import win32com.client
        
        desktop = Path(os.environ['USERPROFILE']) / 'Desktop'
        shortcut_path = desktop / '부동산 제안서 생성 시스템.lnk'
        
        shell = win32com.client.Dispatch("WScript.Shell")
        shortcut = shell.CreateShortCut(str(shortcut_path))
        shortcut.Targetpath = str(self.install_path / '부동산앱.vbs')
        shortcut.WorkingDirectory = str(self.install_path)
        shortcut.Description = "상업용 부동산 제안서 생성 시스템"
        shortcut.save()
        
    def create_start_menu_shortcut(self):
        import win32com.client
        
        start_menu = Path(os.environ['APPDATA']) / 'Microsoft' / 'Windows' / 'Start Menu' / 'Programs'
        shortcut_path = start_menu / '부동산 제안서 생성 시스템.lnk'
        
        shell = win32com.client.Dispatch("WScript.Shell")
        shortcut = shell.CreateShortCut(str(shortcut_path))
        shortcut.Targetpath = str(self.install_path / '부동산앱.vbs')
        shortcut.WorkingDirectory = str(self.install_path)
        shortcut.Description = "상업용 부동산 제안서 생성 시스템"
        shortcut.save()
        
    def launch_app(self):
        vbs_file = self.install_path / '부동산앱.vbs'
        subprocess.Popen(['wscript', str(vbs_file)])
        
    def run(self):
        self.root.mainloop()

if __name__ == '__main__':
    app = InstallerGUI()
    app.run()
