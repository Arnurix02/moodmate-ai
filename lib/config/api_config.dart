class ApiConfig {
  static const String huggingFaceBaseUrl =
      'https://api-inference.huggingface.co/models';
  static const String k2ModelPath = 'K2Model';

  static const String huggingFaceApiKey =
      'csk_yenfm9jntj43cxxtd3wh9rwfp56jjktv5hth2f6ee39jkk4t';

  static const Duration apiTimeout = Duration(seconds: 30);
  static const int maxTokens = 200;
  static const double temperature = 0.7;

  static Map<String, String> get headers => {
        'Authorization': 'Bearer $huggingFaceApiKey',
        'Content-Type': 'application/json',
      };

  static bool get isConfigured =>
      huggingFaceApiKey !=
      'csk_yenfm9jntj43cxxtd3wh9rwfp56jjktv5hth2f6ee39jkk4t';
}
