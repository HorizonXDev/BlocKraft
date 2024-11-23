class BlockraftYamlContent {
  final String content;

  BlockraftYamlContent(String appName, String author, String description, String packageName)
      : content = '''
project:
  name: $appName
  author: "$author"
  description: "$description"
  package: "$packageName"

screens:
  include: 
    - Screen1

extensions:
  enabled:

assets:
      ''';
}
