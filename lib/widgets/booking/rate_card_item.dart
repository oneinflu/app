class RateCardItem {
  final String title;
  final double price;
  final String description;
  final double rating;
  final String ratingCount;
  final bool isBestSeller;
  final bool isNegotiable;
  bool isSelected;

  RateCardItem({
    required this.title,
    required this.price,
    required this.description,
    this.rating = 0.0,
    this.ratingCount = '',
    this.isBestSeller = false,
    this.isNegotiable = false,
    this.isSelected = false,
  });
}