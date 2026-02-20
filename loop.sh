#!/bin/bash

INTERVAL=10

# Ctrl+C 핸들러
trap 'echo ""; echo "[종료] 작업을 중단합니다."; exit 0' SIGINT SIGTERM

echo "======================================"
echo " 자동 이슈 처리 루프 시작"
echo " 간격: ${INTERVAL}초 | 종료: Ctrl+C"
echo "======================================"

while true; do
    echo ""
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] 처리할 이슈 확인 중..."

    # 처리완료 라벨이 없는 열린 이슈 확인
    ISSUE=$(gh issue list --state open --json number,labels \
        --jq '[.[] | select(.labels | map(.name) | contains(["처리완료"]) | not)] | first | .number' 2>/dev/null)

    if [ -z "$ISSUE" ] || [ "$ISSUE" = "null" ]; then
        echo "[SKIP] 처리할 이슈가 없습니다. ${INTERVAL}초 후 재확인..."
    else
        echo "[FOUND] 이슈 #${ISSUE} 발견 → Claude 실행"
        claude --dangerously-skip-permissions -p "prompt.md 파일을 읽고 지시대로해"
        echo "[DONE] 이슈 #${ISSUE} 처리 완료"
    fi

    sleep $INTERVAL
done
