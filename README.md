# XCLogParser2Sonar

Tool for converting [XCLogParser](https://github.com/MobileNativeFoundation/XCLogParser) results to [SonarQube](https://www.sonarqube.org) generic issues written in swift.

## 📝 Description

`xclogparser2sonar` is a simple command-line utility written in Swift that reads output of xclogparser and converts it into [SonarQube generic issues](https://docs.sonarqube.org/latest/analysis/generic-issue/) that can be imported via flag `sonar.externalIssuesReportPaths`.

- Sonarqube expects issues paths are relative to the root of the repository so please make sure to provide the absolute path to your repository using `--base-path`.
- Some linker, target integrity, etc warnings/errors might come files sonarqube does not know (for example `*.xcodeproj/`) and sonar scanner might ignore these issues. One way to work-around this is to map issues from `*.xcodeproj/` to `*.xcodeproj/project.pbxproj`. Make sure sonarqube knows about `pbxproj` (I appended my pbxproj file path to `sonar.sources` flag) 

## 🛠 Install

The easiest way is to use mint

```bash
mint install nacho4d/XCLogParser2Sonar
```

## ▶️ Usage

Simply call `xclogparser2sonar` with required `--issues-path` parameter and optional but recommended `--base-path` and `--map2pbxproj` parameters. In below example I wrote a full integration example. If you are already using sonar qube you should already have ① and partially ③ in place. 

For parameters detailed explanation see `xclogparser2sonar --help`

### Full example

```bash
# If you are using Gitlab CI this should be "${CI_PROJECT_DIR}" or in Jenkins "${WORKSPACE}/YourProjectRoot"...
MY_PROJECT_DIR=/Absolute/path/to/my/sonar/project

# ① use xclogparser to get warnings/error issues
cd "${MY_PROJECT_DIR}/path/to/ios/project"
xclogparser parse --xcodeproj YourProject.xcodeproj --reporter issues --output xclogparser-issues.json

# ② Convert xclogparser issues to sonar generic issues. 
xclogparser2sonar \
    --map2pbxproj \
    --base-path "${MY_PROJECT_DIR}/" 
    --issues-path "xclogparser-issues.json" > sonar-generic-issues.json
 
# ③ Now you can pass sonar-generic-issues.json to sonar scanner.
sonar-scanner ... \
    -Dsonar.externalIssuesReportPaths=sonar-generic-issues.json
```


## 📄 License

Copyright © 2021 Guillermo Ignacio Enriquez Gutierrez

License: [MIT](LICENSE)
