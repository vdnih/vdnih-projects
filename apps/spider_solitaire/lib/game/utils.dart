import 'card.dart';

class GameUtils {
  static bool isValidSequence(List<PlayingCard> cards) {
    if (cards.length <= 1) return true;
    
    final suit = cards.first.suit;
    
    for (int i = 1; i < cards.length; i++) {
      final current = cards[i];
      final previous = cards[i - 1];
      
      if (current.suit != suit || current.rank.value != previous.rank.value - 1) {
        return false;
      }
    }
    
    return true;
  }

  static bool isCompletedSequence(List<PlayingCard> cards) {
    if (cards.length != 13) return false;
    
    final suit = cards.first.suit;
    if (!cards.every((card) => card.suit == suit)) return false;
    
    final sortedCards = cards.toList()
      ..sort((a, b) => b.rank.value.compareTo(a.rank.value));
    
    for (int i = 0; i < 13; i++) {
      if (sortedCards[i].rank.value != 13 - i) return false;
    }
    
    return true;
  }

  static List<PlayingCard> findLongestValidSequence(List<PlayingCard> cards) {
    if (cards.isEmpty) return [];
    
    final visibleCards = cards.where((card) => card.isVisible).toList();
    if (visibleCards.isEmpty) return [];
    
    List<PlayingCard> longestSequence = [visibleCards.last];
    
    for (int i = visibleCards.length - 2; i >= 0; i--) {
      final current = visibleCards[i];
      final next = longestSequence.first;
      
      if (current.isSequenceWith(next)) {
        longestSequence.insert(0, current);
      } else {
        break;
      }
    }
    
    return longestSequence;
  }

  static int calculateScore(int sequencesCompleted, int moves) {
    const baseScore = 100;
    const bonusPerSequence = 50;
    const movePenalty = 1;
    
    return (sequencesCompleted * (baseScore + bonusPerSequence)) - (moves * movePenalty);
  }

  static String formatTime(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  static String getSuitSymbol(Suit suit) {
    switch (suit) {
      case Suit.hearts:
        return '♥';
      case Suit.diamonds:
        return '♦';
      case Suit.clubs:
        return '♣';
      case Suit.spades:
        return '♠';
    }
  }

  static String getRankSymbol(Rank rank) {
    switch (rank) {
      case Rank.ace:
        return 'A';
      case Rank.jack:
        return 'J';
      case Rank.queen:
        return 'Q';
      case Rank.king:
        return 'K';
      default:
        return rank.value.toString();
    }
  }
}