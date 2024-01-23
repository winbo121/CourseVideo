# 환경설정
 - EgovFramework 4.0  
 - OpenJdk 15.0.2 (eclipse 실행시)
 - java Runtime 1.8 (java build)
 - Mybatis  
 - Tomcat 9.0  
 - MySql 8.0.30  

# 전자정부 프레임워크 설치
 - https://www.egovframe.go.kr/home/sub.do?menuNo=94  
 - 개발자용 개발환경 64bit(Implementation Tool) Version 4.0.0  
 - D:\ 설치  

# D:\eGovFrameDev-4.0.0-64bit\eclipse  , eclipse.ini 파일 편집
 - 아래 문구 추가  
-vm  
plugins/org.eclipse.justj.openjdk.hotspot.jre.full.win32.x86_64_15.0.2.v20210201-0955/jre/bin

# 이클립스 시작
 - 소스 경로  설정 : D:\eGovFrameDev-4.0.0-64bit\workspace

# 서버 설정
 - 이클립스 상단 메뉴 > window > Preferences  
 - server 입력 후 Runtime Environments 클릭  
 - Apache Tomcat v9.0 클릭 후  
 - Download and install D:\ 경로 설치 후 Finish  
 - Servers 에 Tomcat add 후 프로젝트 연동해서 사용  




### eclipse - git 연동하기 (이미 세팅된 사람은 생략 가능)

 - github 계정에서 토큰생성  
 - github 본인 계정 로그인  
 - settings 이동  
 - Devloper Settings  
 - Personal access Tokens - Tokens(classic) 선택  
 - Genrate new token (classic)으로 생성  
 - repo, workflow, write:packages, delete:packages, project 등 필요사항 선택  
 - Generate token 실행  
 - 실행 후 나오는 토큰 정보를 복사 해서 git 연동시에 비밀번호로 사용한다. (한번만 나타나니 다른 곳에 복사 해둘 것)
 - 이클립스 상단 메뉴 > window > Show View > Git Repositories에서 설정
 
 
### git ignore 추가 사항
 - 해당 초기 프로젝트를 받은 후에는 아래 사항을 본인 .gitignore 파일에다가 추가해준다.  
### Eclipse Core  
.project  
### JDT-specific (Eclipse Java Development Tools)  
.classpath  
### Eclipse  
.settings/  

### 강의 업로드된 영상또는 사진 조회 
톰캣에 server.xml에 맨밑 Engin에 추가하기
Context docBase="D:/KOTECH/REPOSITORY/IMAGES" path="/REPOSITORY/IMAGES" reloadable="true"
Context docBase="D:/KOTECH/REPOSITORY/FILES" path="/REPOSITORY/FILES" reloadable="true"



