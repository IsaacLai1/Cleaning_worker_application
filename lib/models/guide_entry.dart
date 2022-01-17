//contructor for guide entries
//enum GuideType { basics, advanced, safety, legal }

class Guide {
  final String guideId;
  final String guideDesc;
  final String guideType;
  final String guideName;
  final String guideVideoURL;
  final String imageURL;
  final List<String> guideContent;

  const Guide(
      {this.guideId,
      this.guideDesc,
      this.guideType,
      this.guideName,
      this.guideVideoURL,
      this.imageURL,
      this.guideContent});

  Guide.fromMap(Map<String, dynamic> data, String guideId)
      : this(
          guideId: guideId,
          guideDesc: data['guideDesc'],
          guideType: data['guideType'],
          guideName: data['guideName'],
          guideVideoURL: data['guideVideo'],
          guideContent: new List<String>.from(data['guideContent']),
          imageURL: data['image'],
        );
}
