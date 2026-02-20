# 자동 이슈 처리 지시

## 목표
GitHub 이슈를 자동으로 처리하고 PR을 생성한다.

## 작업 순서

### 1. 처리할 이슈 선택
- `gh issue list --state open` 으로 열린 이슈 목록을 조회한다.
- `처리완료` 라벨이 붙지 않은 이슈 중 가장 오래된 것(번호가 작은 것) 하나를 선택한다.
- 처리할 이슈가 없으면 작업을 종료한다.

### 2. 이슈 내용 파악
- `gh issue view <issue_number>` 로 이슈 내용을 상세히 읽는다.
- 이슈에서 요구하는 작업이 무엇인지 파악한다.

### 3. 브랜치 생성
- 브랜치명 형식: `issue-<issue_number>-<간단한-설명>`
- `git checkout -b <branch_name>` 으로 브랜치를 생성한다.
- 이미 해당 브랜치가 존재하면 건너뛴다.

### 4. 작업 수행
- 이슈 내용에 따라 실제 코드 작업을 수행한다.
- 작업 완료 후 변경 사항을 커밋한다.
  - `git add .`
  - `git commit -m "fix: <이슈 내용 요약> (closes #<issue_number>)"`

### 5. 푸시 및 PR 생성
- `git push -u origin <branch_name>` 으로 브랜치를 푸시한다.
- 아래 형식으로 PR을 생성한다:
  ```
  gh pr create \
    --title "<이슈 제목>" \
    --body "## 관련 이슈\ncloses #<issue_number>\n\n## 변경 사항\n<작업 내용 요약>" \
    --base main
  ```

### 6. 처리완료 라벨 부착
- `처리완료` 라벨이 없으면 먼저 생성한다:
  ```
  gh label create "처리완료" --color "#0075ca" --description "처리가 완료된 이슈"
  ```
  (이미 존재하면 생략)
- 처리한 이슈에 라벨을 붙인다:
  ```
  gh issue edit <issue_number> --add-label "처리완료"
  ```

## 주의사항
- 모든 `gh` 명령은 현재 레포지토리 기준으로 실행한다.
- PR 생성 후 반드시 `처리완료` 라벨을 붙여야 다음 실행 시 중복 처리되지 않는다.
- 작업 중 오류가 발생하면 main 브랜치로 복귀한다: `git checkout main`
