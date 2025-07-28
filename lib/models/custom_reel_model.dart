import 'package:reels_viewer/reels_viewer.dart';

class CustomReelModel extends ReelModel {
  final String? productName;
  final String? productPrice;
  final String? location;

  CustomReelModel(
    String videoUrl,
    String userName,
    {
    this.productName,
    this.productPrice,
    this.location,
    int? likeCount,
    bool? isLiked,
    String? musicName,
    String? reelDescription,
    String? profileUrl,
    List<ReelCommentModel>? commentList,
  }) : super(
          videoUrl,
          userName,
          likeCount: likeCount ?? 0,  // Provide default value of 0 for null
          isLiked: isLiked ?? false,  // Provide default value of false for null
          musicName: musicName,
          reelDescription: reelDescription,
          profileUrl: profileUrl,
          commentList: commentList,
        );
}