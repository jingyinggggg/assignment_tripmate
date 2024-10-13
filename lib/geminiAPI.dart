import 'package:assignment_tripmate/constants.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiApi {
  Future<String> generateItinerary(String departDate, String returnDate, String country, String budget, String travelStyle) async {
    final model = GenerativeModel(
      model: 'gemini-1.5-flash', 
      apiKey: apiKey,
    );

    final prompt = 'Create an itinerary with style of $travelStyle from $departDate to $returnDate at $country with budget of $budget';

    try {
      final response = await model.generateContent([Content.text(prompt)]);
      return response.text ?? 'No itinerary generated.';
    } catch (e) {
      print('Error generating itinerary: $e');
      return 'Error generating itinerary.';
    }

  }
}