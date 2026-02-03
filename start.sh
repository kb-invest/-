#!/bin/bash

echo "========================================"
echo "상업용 부동산 제안서 생성 시스템"
echo "Commercial Real Estate Proposal Generator"
echo "========================================"
echo ""

echo "[1/2] 백엔드 서버 시작 중..."
cd backend
python3 app.py &
BACKEND_PID=$!
cd ..

echo "[2/2] 프론트엔드 서버 시작 중..."
sleep 3
npm run dev &
FRONTEND_PID=$!

echo ""
echo "✅ 서버 시작 완료!"
echo ""
echo "📱 브라우저에서 열기: http://localhost:3000"
echo ""
echo "⚠️  종료하려면 Ctrl+C를 누르세요"
echo ""

# 종료 처리
trap "kill $BACKEND_PID $FRONTEND_PID 2>/dev/null; exit" SIGINT SIGTERM

# 브라우저 자동 열기 (MacOS/Linux)
sleep 3
if command -v open &> /dev/null; then
    open http://localhost:3000
elif command -v xdg-open &> /dev/null; then
    xdg-open http://localhost:3000
fi

wait
