import 'card.dart';

class TableauColumn {
  final List<PlayingCard> cards;

  const TableauColumn({required this.cards});

  bool get isEmpty => cards.isEmpty;
  bool get isNotEmpty => cards.isNotEmpty;

  PlayingCard? get topCard => cards.isNotEmpty ? cards.last : null;

  List<PlayingCard> get visibleCards {
    return cards.where((card) => card.isVisible).toList();
  }

  bool canAcceptCard(PlayingCard card) {
    if (isEmpty) return true;
    final top = topCard;
    return top != null && card.canPlaceOn(top);
  }

  List<PlayingCard> getMovableCards(int startIndex) {
    if (startIndex >= cards.length) return [];
    
    final movableCards = <PlayingCard>[];
    
    for (int i = startIndex; i < cards.length; i++) {
      final card = cards[i];
      if (!card.isVisible) break;
      
      if (movableCards.isNotEmpty) {
        final previousCard = movableCards.last;
        if (!card.isSequenceWith(previousCard)) {
          break;
        }
      }
      
      movableCards.add(card);
    }
    
    return movableCards;
  }

  bool isValidSequence(List<PlayingCard> sequence) {
    if (sequence.length <= 1) return true;
    
    final suit = sequence.first.suit;
    
    for (int i = 1; i < sequence.length; i++) {
      final current = sequence[i];
      final previous = sequence[i - 1];
      
      if (current.suit != suit || current.rank.value != previous.rank.value - 1) {
        return false;
      }
    }
    
    return true;
  }

  @override
  String toString() {
    return 'TableauColumn(${cards.length} cards)';
  }
}