class BlockraftYamlContent {
  final String content;

  BlockraftYamlContent(String appName, String author, String description)
      : content = '''
      project:
  name: $appName
  author: $author
  description: "$description"

screens:
  default: Screen1

extensions:
  enabled:

assets:
  images:
    - logo.png
  fonts:
    - roboto.ttf

build:
  output_format: aia

      ''';
}
