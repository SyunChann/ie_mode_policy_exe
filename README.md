# ie_mode_policy_exe

레거시 ASP 기반 CRM/인트라넷을 Microsoft Edge의 IE 모드로 안정적으로 열기 위해 만든 배포용 도구입니다.

기존에는 사용자가 Edge 설정에서 IE 모드 사이트를 직접 추가해 사용할 수 있었지만, 해당 방식은 약 30일 뒤 만료되어 매달 다시 등록해야 하는 번거로움이 있었습니다. 이 저장소는 그 과정을 Windows 정책과 Enterprise Mode 사이트 목록으로 고정해 반복 작업을 없애는 목적입니다.

## What It Solves

- 레거시 ASP 페이지를 Edge IE 모드로 강제 오픈
- 개별 PC에서 수동으로 IE 모드 예외를 다시 등록하는 작업 제거
- 사이트 목록을 `sites.xml` 한 곳에서 중앙 관리
- 설치와 제거를 각각 독립 실행형 스크립트/EXE로 제공

## Repository Contents

- `install-intranet-ie-mode.ps1`
  - Edge 정책을 생성하고 Enterprise Mode 사이트 목록 URL을 등록합니다.
- `uninstall-intranet-ie-mode.ps1`
  - 적용한 Edge 정책을 제거합니다.
- `sites.xml`
  - IE 모드로 열어야 할 사이트 목록 예제입니다.
- `Install-Intranet-IEMode.exe`
  - 설치 스크립트를 실행 파일 형태로 패키징한 버전입니다.
- `Uninstall-Intranet-IEMode.exe`
  - 제거 스크립트를 실행 파일 형태로 패키징한 버전입니다.
- `README.txt`
  - 현장 배포용 텍스트 안내문입니다.

## How It Works

설치 스크립트는 다음 두 가지 Edge 정책을 `HKLM:\SOFTWARE\Policies\Microsoft\Edge`에 등록합니다.

- `InternetExplorerIntegrationLevel`
- `InternetExplorerIntegrationSiteList`

이후 Edge는 지정된 `sites.xml`을 읽어 목록에 있는 사이트를 IE 모드로 엽니다.

## Deployment Flow

1. `sites.xml`을 내부 웹 서버에 업로드합니다.
2. 브라우저에서 사이트 목록 URL을 직접 열었을 때 XML이 정상적으로 보여야 합니다.
3. `Install-Intranet-IEMode.exe` 또는 `install-intranet-ie-mode.ps1`를 관리자 권한으로 실행합니다.
4. Microsoft Edge를 완전히 종료한 뒤 다시 실행합니다.
5. 대상 레거시 사이트에 접속해 IE 모드가 적용되는지 확인합니다.

## Example Configuration

이 저장소의 기본 예시는 공개용으로 치환되어 있습니다.

- 사이트 목록 URL: `https://intranet.example.com/iemode/sites.xml`
- 인트라넷 예시: `https://intranet.example.com/`
- CRM 예시: `https://legacy-crm.example.com/`

실사용 시에는 아래 두 파일의 예시 값을 실제 사내 주소로 바꿔 사용하면 됩니다.

- `install-intranet-ie-mode.ps1`
- `sites.xml`

## Verification

설치 후 아래 항목으로 적용 상태를 확인할 수 있습니다.

### 1. 대상 사이트 접속 확인

레거시 페이지 접속 시 Edge 주소창에 IE 모드 아이콘이 보여야 합니다.

### 2. Enterprise Mode 목록 확인

Edge 주소창에 아래를 입력합니다.

```text
edge://compat/enterprise
```

여기서 `Internet Explorer mode site list`가 반영되었는지 확인하고, 필요하면 강제 새로고침을 수행합니다.

### 3. 정책 확인

Edge 주소창에 아래를 입력합니다.

```text
edge://policy
```

아래 정책이 보이면 정상 적용된 것입니다.

- `InternetExplorerIntegrationLevel`
- `InternetExplorerIntegrationSiteList`

## Removal

제거가 필요하면 아래 중 하나를 관리자 권한으로 실행합니다.

- `Uninstall-Intranet-IEMode.exe`
- `uninstall-intranet-ie-mode.ps1`

실행 후 Microsoft Edge를 다시 시작하면 정책이 해제됩니다.

## Notes

- 이 방식은 Microsoft Edge 전용입니다.
- `sites.xml`을 수정하면 클라이언트 재배포 없이 목록만 갱신할 수 있습니다.
- 운영 환경에서는 `sites.xml`을 내부 서버에서 안정적으로 제공해야 합니다.
- 공개 저장소에 업로드할 때는 실제 사내 도메인, 서버 경로, 고객명 같은 운영 정보를 제거하는 편이 안전합니다.
