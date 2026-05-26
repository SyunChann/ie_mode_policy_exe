ie_mode_policy_exe
==================

레거시 ASP 기반 CRM/인트라넷을 Microsoft Edge의 IE 모드로 안정적으로 열기 위해 만든 배포용 도구입니다.

기존에는 사용자가 Edge 설정에서 IE 모드 사이트를 직접 추가해 사용할 수 있었지만, 해당 방식은 약 30일 뒤 만료되어 매달 다시 등록해야 하는 번거로움이 있었습니다.
이 도구는 Windows 정책과 Enterprise Mode 사이트 목록을 이용해 그 작업을 자동화합니다.

1. 주요 목적

- 레거시 ASP 페이지를 Edge IE 모드로 강제 오픈
- 매달 수동으로 IE 모드 사이트를 다시 등록하는 작업 제거
- 사이트 목록을 `sites.xml` 한 곳에서 중앙 관리

2. 구성 파일

- `install-intranet-ie-mode.ps1`
  Edge 정책을 생성하고 Enterprise Mode 사이트 목록 URL을 등록합니다.
- `uninstall-intranet-ie-mode.ps1`
  적용한 Edge 정책을 제거합니다.
- `sites.xml`
  IE 모드로 열어야 할 사이트 목록 예제입니다.
- `Install-Intranet-IEMode.exe`
  설치용 실행 파일입니다.
- `Uninstall-Intranet-IEMode.exe`
  제거용 실행 파일입니다.

3. 배포 방법

- `sites.xml`을 내부 웹 서버에 업로드합니다.
- 브라우저에서 사이트 목록 URL을 직접 열었을 때 XML 내용이 보여야 합니다.
- `Install-Intranet-IEMode.exe` 또는 `install-intranet-ie-mode.ps1`를 관리자 권한으로 실행합니다.
- Microsoft Edge를 완전히 종료한 뒤 다시 실행합니다.

4. 공개용 예시 주소

- 사이트 목록 URL
  `https://intranet.example.com/iemode/sites.xml`
- 인트라넷 예시
  `https://intranet.example.com/`
- CRM 예시
  `https://legacy-crm.example.com/`

실사용 시에는 `install-intranet-ie-mode.ps1`와 `sites.xml`의 예시 주소를 실제 사내 주소로 변경하면 됩니다.

5. 적용 확인 방법

- 레거시 사이트 접속 시 Edge 주소창에 IE 모드 아이콘이 보여야 합니다.
- `edge://compat/enterprise`에서 사이트 목록 반영 상태를 확인합니다.
- `edge://policy`에서 아래 정책이 보이는지 확인합니다.
  - `InternetExplorerIntegrationLevel`
  - `InternetExplorerIntegrationSiteList`

6. 바로 반영되지 않을 때

- Microsoft Edge를 모두 종료한 뒤 다시 실행합니다.
- `edge://compat/enterprise`에서 사이트 목록 강제 갱신을 수행합니다.
- `sites.xml`이 웹 서버에서 정상 응답하는지 다시 확인합니다.

7. 제거 방법

- `Uninstall-Intranet-IEMode.exe` 또는 `uninstall-intranet-ie-mode.ps1`를 관리자 권한으로 실행합니다.
- 실행 후 Microsoft Edge를 다시 시작합니다.

8. 참고

- 이 방식은 Microsoft Edge 전용입니다.
- 사이트 목록은 `sites.xml` 수정만으로 중앙에서 갱신할 수 있습니다.
- 공개 저장소에 업로드할 때는 실제 사내 도메인과 운영 정보를 제거하는 편이 안전합니다.
