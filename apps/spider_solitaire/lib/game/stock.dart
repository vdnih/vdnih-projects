import 'card.dart';

class Stock {
  final List<PlayingCard> cards;

  const Stock({required this.cards});

  bool get isEmpty => cards.isEmpty;
  bool get isNotEmpty => cards.isNotEmpty;

  int get count => cards.length;

  bool canDeal() => cards.length >= 10;

  int get dealsRemaining => cards.length ~/ 10;

  List<PlayingCard> dealCards() {
    if (!canDeal()) return [];
    
    final dealtCards = <PlayingCard>[];
    for (int i = 0; i < 10 && cards.isNotEmpty; i++) {
      dealtCards.add(cards.removeAt(0));
    }
    
    return dealtCards;
  }

  @override
  String toString() {
    return 'Stock(${cards.length} cards, $dealsRemaining deals remaining)';
  }
}