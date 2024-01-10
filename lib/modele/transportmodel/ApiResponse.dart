import 'package:SunShine/modele/transportmodel/transportModel.dart';

class ApiResponse {
  final int inlineCount;
  final List<Transport> results;
  final List<String> touristGroupIds;

  ApiResponse({
    required this.inlineCount,
    required this.results,
    required this.touristGroupIds,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    // Extract data from the JSON response
    final inlineCount = json['inlineCount'] as int;
    final results = (json['results'] as List)
        .map((result) => Transport.fromJson(result))
        .toList();
    final touristGroupIds =
        (json['touristGroupIds'] as List).map((id) => id as String).toList();

    return ApiResponse(
      inlineCount: inlineCount,
      results: results,
      touristGroupIds: touristGroupIds,
    );
  }
}
