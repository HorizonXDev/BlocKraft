class ProjectProperties {
  final String content;
  ProjectProperties(String appName, String packageName)
      : content = '''
  source=../src
  name=$appName
  defaultfilescope=App
  main=$packageName.Screen1
  color.accent=&HFF00728A
  sizing=Responsive
  assets=../assets
  theme=Classic
  showlistsasjson=True
  useslocation=False
  aname=test
  actionbar=False
  color.primary=&HFFA5CF47
  build=../build
  versionname=1.0
  versioncode=1
  color.primary.dark=&HFF41521C
  ''';
}
