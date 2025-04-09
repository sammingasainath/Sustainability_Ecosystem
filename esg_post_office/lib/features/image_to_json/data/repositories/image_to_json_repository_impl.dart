import 'dart:io';
import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../../core/failure.dart';
import '../../domain/entities/image_to_json_result.dart';
import '../../domain/repositories/image_to_json_repository.dart';

class ImageToJsonRepositoryImpl implements ImageToJsonRepository {
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  String? _apiKey;

  ImageToJsonRepositoryImpl() {
    _apiKey = dotenv.env['OPENAI_API_KEY'];
    OpenAI.apiKey = _apiKey ?? '';
  }

  @override
  Future<Either<Failure, ImageToJsonResult>> processImage({
    required File imageFile,
    required String customPrompt,
  }) async {
    try {
      if (_apiKey?.isEmpty ?? true) {
        return left(const Failure('OpenAI API key not found in .env file'));
      }

      // Step 1: Process image with ML Kit OCR
      final inputImage = InputImage.fromFile(imageFile);
      final recognizedText = await textRecognizer.processImage(inputImage);
      final extractedText = recognizedText.text;

      if (extractedText.isEmpty) {
        return left(const Failure('No text found in the image'));
      }

      // Step 2: Process with OpenAI
      final prompt = '$customPrompt\nExtracted Text: $extractedText';

      final completion = await OpenAI.instance.chat.create(
        model: 'gpt-3.5-turbo',
        messages: [
          OpenAIChatCompletionChoiceMessageModel(
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(prompt)
            ],
            role: OpenAIChatMessageRole.user,
          ),
        ],
      );

      final jsonResponse = completion.choices.first.message.content!.first.text;

      // Parse the response as JSON
      final Map<String, dynamic> parsedJson = jsonDecode(jsonResponse!);

      return right(ImageToJsonResult(
        extractedText: extractedText,
        jsonResponse: parsedJson,
      ));
    } catch (e) {
      return left(Failure(e.toString()));
    } finally {
      textRecognizer.close();
    }
  }
}
