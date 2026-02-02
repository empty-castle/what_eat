# AGENTS.md — 뭐먹지(what_eat) / Codex CLI 작업 지침

## 0) 프로젝트 고정 조건 (절대 변경 금지)
- 프로젝트명: 뭐먹지 (what_eat)
- 기술: Flutter (Dart)
- 타겟: Android만
- Android 버전: Android 16.0 (API Level 36)
- Java(JDK): 21

## 1) 에이전트 역할
- Flutter(Android) 앱 개발 작업을 수행한다.
- 변경은 “최소 범위 + 즉시 실행 가능”을 기준으로 만든다.
- 기존 코드/구조/패턴을 우선 존중한다.

## 2) 작업 원칙
- 작업 단위는 1개의 명확한 목표로 쪼갠다.
- 한 번에 크게 바꾸지 않는다. 작은 변경을 연속으로 쌓는다.
- 작업마다 실행/검증 결과를 남긴다.
- 리포지토리 전체 리팩터링, 대규모 폴더 재구성, 광범위한 의존성 교체를 금지한다.

## 3) 변경 범위 규칙
- Android 전용 정책을 유지한다. iOS 관련 파일은 수정/추가하지 않는다.
- Android 설정은 API 36, JDK 21 전제를 유지한다.
- 새 패키지(의존성) 추가는 최소화한다.
- 코드 생성/추가 시 파일 경로를 명확히 표기하고, 필요한 파일은 “완전한 내용”으로 제공한다.

## 3-1) 의존성 버전 정책 (최신/안전)
- 새 패키지 추가 시 **pub.dev 기준 최신 Stable(정식 릴리스)** 중에서, 현재 프로젝트의 Flutter/Dart SDK 제약과 **호환되는 가장 높은 버전**을 사용한다.
- 기본은 `^<latest>` 형태의 caret 범위를 사용한다. (재현성/호환성 이슈로 고정이 필요한 경우에만 예외적으로 pin)
- Major 버전 업그레이드도 Stable이고 호환성(Flutter/Dart SDK 제약) 문제가 없으며, `flutter analyze`/빌드가 통과하면 적용한다. 적용 시 변경점(changelog/release note)을 간단히 요약한다.
- `-alpha`, `-beta`, `-rc` 등 **프리릴리즈 버전은 사용하지 않는다.**
- 새 의존성 추가/업그레이드 작업에서는 아래를 함께 수행하고 결과를 남긴다.
  - `flutter pub get`
  - `flutter pub outdated` (가능하면)
  - `flutter analyze`
- 의존성 버전이 최신 Stable보다 낮게 들어가면(예: flex_color_scheme 7.x 등) 사유를 명확히 적고, 가능하면 최신 Stable로 올린다.

## 4) 코드 스타일 및 품질 규칙
- Dart null-safety를 준수한다.
- 가능한 `const`, `final`을 사용한다.
- 중복 로직은 즉시 공통화하지 않는다(요구가 생긴 범위에서만 정리).
- 린트/포맷을 통과하도록 만든다.

## 4-1) 한글/문자 인코딩(UTF-8) 가드레일
- 프로젝트 내 모든 텍스트 파일은 **UTF-8 인코딩**으로 저장한다. (특히 `lib/**/*.dart`, `pubspec.yaml`, `AGENTS.md` 등)
- 한글 문자열/주석을 코드에 추가한 직후, 파일 내용을 다시 확인하여 **문자 깨짐(모지바케)** 이 없는지 검증한다.
- 아래처럼 한글이 깨진 문자열이 생성되면(예: `enabledLabels.add('以묒떇');`) 그대로 두지 말고 즉시 수정한다.
- 한글 문자열이 반복해서 깨지는 경우, 해당 문자열 리터럴은 **Unicode escape**로 치환해 안정적으로 유지한다.
  - 예: `'중식'` → `'\uC911\uC2DD'`
  - 예: `'한식'` → `'\uD55C\uC2DD'`
  - 예: `'양식'` → `'\uC591\uC2DD'`
  - 예: `'일식'` → `'\uC77C\uC2DD'`
  - 예: `'분식'` → `'\uBD84\uC2DD'`
- UI 라벨 문자열은 가능한 한 **한 곳에 const로 모아** 참조한다(화면 코드에 한글 리터럴 직접 하드코딩 금지).
  - 예: `lib/constants/category_labels.dart`에 `const Map/...` 또는 `enum + label getter` 형태로 정의하고, 화면에서는 그 상수만 사용한다.
- Windows 터미널 환경에서는 Codex CLI 작업 시작 전에 콘솔 인코딩을 UTF-8로 맞춘다.
  - CMD: `chcp 65001`
  - PowerShell: `[Console]::OutputEncoding = [Text.UTF8Encoding]::new()`

## 5) Android 빌드/설정 가드레일
- `android/` 하위 설정은 다음 전제를 유지한다:
  - compile/target: API 36 (Android 16.0)
  - JDK: 21
- Gradle/AGP/Kotlin 버전은 임의로 올리지 않는다.
- 빌드 오류 해결을 명분으로 한 무작정 버전 업을 금지한다.

## 6) 작업 산출물 포맷 (Codex CLI 출력 기준)
- 변경 요약: 무엇을 바꿨는지 3~7줄로 요약한다.
- 변경 파일 목록: 경로 기준으로 나열한다.
- 실행 결과: 수행한 커맨드와 핵심 결과(성공/실패, 에러 메시지 요약)를 기록한다.
- 코드 제공: 필요한 파일은 경로 + 전체 내용을 포함한다.

## 7) 커밋 메시지 규칙 (Conventional Commits)
- 형식: `type(scope): summary`
- type: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`
- 예시
  - `feat(menu): add random pick action`
  - `fix(storage): prevent duplicate save`
  - `chore(android): align sdk settings for api36`

## 8) 금지 사항
- Android 이외 플랫폼 지원 추가(iOS/Web/Desktop).
- 요구 없는 전역 리팩터링/대규모 구조 변경.
- “돌아가게만” 만드는 임시 코드(주석 처리로 기능 무력화, 무의미한 try-catch 남발).
- 보안/개인정보 민감 데이터 하드코딩(API 키, 토큰, 개인식별정보).
