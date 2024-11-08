class AutoCompletePredictions{
  final String? description;
  final StructuredFormatting? structuredFormatting;
  final String? placeId;
  final String? reference;

  AutoCompletePredictions({
    this.description,
    this.structuredFormatting,
    this.placeId,
    this.reference
  });

  factory AutoCompletePredictions.fromJson(Map<String, dynamic> json){
    return AutoCompletePredictions(
      description: json['description'] as String?,
      placeId: json['place_id'] as String?,
      reference: json['reference'] as String?,
      structuredFormatting: json['structed_formatting'] != null
        ? StructuredFormatting.fromJson(json['structed_formatting'])
        : null,
    );
  }
}

class StructuredFormatting{
  final String? mainText;
  final String? secondaryText;

  StructuredFormatting({this.mainText, this.secondaryText});

  factory StructuredFormatting.fromJson(Map<String, dynamic> json){
    return StructuredFormatting(
      mainText: json['main_text'] as String?,
      secondaryText: json['secondary_text'] as String?,
    );
  }
}