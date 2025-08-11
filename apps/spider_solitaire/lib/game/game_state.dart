import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'card.dart';
import 'tableau.dart';
import 'stock.dart';

enum GameStatus { playing, won, lost }

class GameState {
  final List<TableauColumn> tableau;
  final Stock stock;
  final List<List<PlayingCard>> foundation;
  final GameStatus status;
  final int score;
  final int moves;

  const GameState({
    required this.tableau,
    required this.stock,
    required this.foundation,
    this.status = GameStatus.playing,
    this.score = 0,
    this.moves = 0,
  });

  GameState copyWith({
    List<TableauColumn>? tableau,
    Stock? stock,
    List<List<PlayingCard>>? foundation,
    GameStatus? status,
    int? score,
    int? moves,
  }) {
    return GameState(
      tableau: tableau ?? this.tableau,
      stock: stock ?? this.stock,
      foundation: foundation ?? this.foundation,
      status: status ?? this.status,
      score: score ?? this.score,
      moves: moves ?? this.moves,
    );
  }

  bool get isGameWon => foundation.length == 8;

  bool canDealFromStock() {
    return stock.canDeal() && tableau.every((column) => column.isNotEmpty);
  }

  static List<PlayingCard> _createDeck() {
    final cards = <PlayingCard>[];
    
    for (int deck = 0; deck < 2; deck++) {
      for (final suit in Suit.values) {
        for (final rank in Rank.values) {
          cards.add(PlayingCard(suit: suit, rank: rank));
        }
      }
    }
    
    cards.shuffle();
    return cards;
  }

  static GameState initial() {
    final deck = _createDeck();
    final tableau = <TableauColumn>[];
    
    int cardIndex = 0;
    
    for (int col = 0; col < 10; col++) {
      final columnCards = <PlayingCard>[];
      final cardCount = col < 4 ? 6 : 5;
      
      for (int i = 0; i < cardCount; i++) {
        final card = deck[cardIndex++];
        card.isVisible = i == cardCount - 1;
        columnCards.add(card);
      }
      
      tableau.add(TableauColumn(cards: columnCards));
    }
    
    final remainingCards = deck.sublist(cardIndex);
    final stock = Stock(cards: remainingCards);
    
    return GameState(
      tableau: tableau,
      stock: stock,
      foundation: [],
    );
  }
}

final gameStateProvider = StateNotifierProvider<GameStateNotifier, GameState>((ref) {
  return GameStateNotifier();
});

class GameStateNotifier extends StateNotifier<GameState> {
  GameStateNotifier() : super(GameState.initial());

  void newGame() {
    state = GameState.initial();
  }

  void dealFromStock() {
    if (!state.canDealFromStock()) return;

    final newTableau = <TableauColumn>[];
    final stockCards = state.stock.cards.toList();
    
    for (int i = 0; i < 10; i++) {
      final columnCards = state.tableau[i].cards.toList();
      if (stockCards.isNotEmpty) {
        final newCard = stockCards.removeAt(0);
        newCard.isVisible = true;
        columnCards.add(newCard);
      }
      newTableau.add(TableauColumn(cards: columnCards));
    }

    final newStock = Stock(cards: stockCards);
    
    state = state.copyWith(
      tableau: newTableau,
      stock: newStock,
      moves: state.moves + 1,
    );
    
    _checkForCompletedSequences();
  }

  bool moveCards(int fromColumn, int cardIndex, int toColumn) {
    if (fromColumn == toColumn) return false;
    if (fromColumn < 0 || fromColumn >= 10 || toColumn < 0 || toColumn >= 10) return false;
    
    final sourceColumn = state.tableau[fromColumn];
    final targetColumn = state.tableau[toColumn];
    
    if (cardIndex >= sourceColumn.cards.length) return false;
    
    final cardsToMove = sourceColumn.cards.sublist(cardIndex);
    if (cardsToMove.any((card) => !card.isVisible)) return false;
    
    if (!_canMoveCards(cardsToMove, targetColumn)) return false;
    
    final newTableau = <TableauColumn>[];
    
    for (int i = 0; i < 10; i++) {
      if (i == fromColumn) {
        final remainingCards = sourceColumn.cards.sublist(0, cardIndex);
        if (remainingCards.isNotEmpty && !remainingCards.last.isVisible) {
          remainingCards.last.isVisible = true;
        }
        newTableau.add(TableauColumn(cards: remainingCards));
      } else if (i == toColumn) {
        final newCards = targetColumn.cards.toList()..addAll(cardsToMove);
        newTableau.add(TableauColumn(cards: newCards));
      } else {
        newTableau.add(state.tableau[i]);
      }
    }
    
    state = state.copyWith(
      tableau: newTableau,
      moves: state.moves + 1,
    );
    
    _checkForCompletedSequences();
    return true;
  }

  bool _canMoveCards(List<PlayingCard> cards, TableauColumn targetColumn) {
    if (cards.isEmpty) return false;
    
    final firstCard = cards.first;
    
    if (targetColumn.isEmpty) return true;
    
    final targetCard = targetColumn.cards.last;
    return firstCard.canPlaceOn(targetCard);
  }

  void _checkForCompletedSequences() {
    final newTableau = <TableauColumn>[];
    final newFoundation = state.foundation.toList();
    bool foundSequence = false;

    for (final column in state.tableau) {
      final updatedColumn = _removeCompletedSequence(column);
      if (updatedColumn.cards.length != column.cards.length) {
        foundSequence = true;
        final removedCards = column.cards.sublist(updatedColumn.cards.length);
        newFoundation.add(removedCards);
      }
      newTableau.add(updatedColumn);
    }

    if (foundSequence) {
      final newStatus = newFoundation.length >= 8 ? GameStatus.won : GameStatus.playing;
      
      state = state.copyWith(
        tableau: newTableau,
        foundation: newFoundation,
        status: newStatus,
        score: state.score + (foundSequence ? 100 : 0),
      );
    }
  }

  TableauColumn _removeCompletedSequence(TableauColumn column) {
    if (column.cards.length < 13) return column;
    
    final cards = column.cards;
    final visibleCards = cards.where((card) => card.isVisible).toList();
    
    if (visibleCards.length < 13) return column;
    
    for (int i = visibleCards.length - 13; i >= 0; i--) {
      final sequence = visibleCards.sublist(i, i + 13);
      
      if (_isCompletedSequence(sequence)) {
        final remainingCards = cards.toList();
        for (final card in sequence) {
          remainingCards.remove(card);
        }
        
        if (remainingCards.isNotEmpty && !remainingCards.last.isVisible) {
          remainingCards.last.isVisible = true;
        }
        
        return TableauColumn(cards: remainingCards);
      }
    }
    
    return column;
  }

  bool _isCompletedSequence(List<PlayingCard> cards) {
    if (cards.length != 13) return false;
    
    final suit = cards.first.suit;
    if (!cards.every((card) => card.suit == suit)) return false;
    
    cards.sort((a, b) => b.rank.value.compareTo(a.rank.value));
    
    for (int i = 0; i < 13; i++) {
      if (cards[i].rank.value != 13 - i) return false;
    }
    
    return true;
  }
}