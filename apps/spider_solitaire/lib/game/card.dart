enum Suit { hearts, diamonds, clubs, spades }

enum Rank {
  ace(1),
  two(2),
  three(3),
  four(4),
  five(5),
  six(6),
  seven(7),
  eight(8),
  nine(9),
  ten(10),
  jack(11),
  queen(12),
  king(13);

  const Rank(this.value);
  final int value;
}

class PlayingCard {
  final Suit suit;
  final Rank rank;
  bool isVisible;
  bool isDragging;

  PlayingCard({
    required this.suit,
    required this.rank,
    this.isVisible = false,
    this.isDragging = false,
  });

  bool canPlaceOn(PlayingCard? other) {
    if (other == null) return true;
    return rank.value == other.rank.value - 1;
  }

  bool isSequenceWith(PlayingCard other) {
    return suit == other.suit && rank.value == other.rank.value + 1;
  }

  String get displayName => '${rank.name} of ${suit.name}';

  @override
  String toString() => displayName;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PlayingCard && other.suit == suit && other.rank == rank;
  }

  @override
  int get hashCode => suit.hashCode ^ rank.hashCode;

  PlayingCard copy() {
    return PlayingCard(
      suit: suit,
      rank: rank,
      isVisible: isVisible,
      isDragging: isDragging,
    );
  }
}