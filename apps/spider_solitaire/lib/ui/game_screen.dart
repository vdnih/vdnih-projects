import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../game/game_state.dart';
import '../game/card.dart';
import 'card_widget.dart';
import 'tableau_column_widget.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  int? selectedColumn;
  int? selectedCardIndex;

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameStateProvider);
    final gameNotifier = ref.read(gameStateProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFF0D4F1C),
      appBar: AppBar(
        title: const Text('Spider Solitaire'),
        backgroundColor: const Color(0xFF0D4F1C),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              gameNotifier.newGame();
              _clearSelection();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildHeader(gameState, gameNotifier),
          const SizedBox(height: 16),
          Expanded(
            child: _buildTableau(gameState, gameNotifier),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(GameState gameState, GameStateNotifier gameNotifier) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStockPile(gameState, gameNotifier),
          _buildGameInfo(gameState),
          _buildFoundation(gameState),
        ],
      ),
    );
  }

  Widget _buildStockPile(GameState gameState, GameStateNotifier gameNotifier) {
    return GestureDetector(
      onTap: gameState.canDealFromStock()
          ? () => gameNotifier.dealFromStock()
          : null,
      child: Stack(
        children: [
          CardWidget(
            card: gameState.stock.cards.isNotEmpty 
                ? PlayingCard(suit: Suit.spades, rank: Rank.king, isVisible: false)
                : null,
            width: 60,
            height: 85,
          ),
          if (gameState.stock.dealsRemaining > 0)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${gameState.stock.dealsRemaining}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGameInfo(GameState gameState) {
    return Column(
      children: [
        Text(
          'Score: ${gameState.score}',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        Text(
          'Moves: ${gameState.moves}',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        Text(
          'Completed: ${gameState.foundation.length}/8',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildFoundation(GameState gameState) {
    return Row(
      children: List.generate(
        8,
        (index) => Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Container(
            width: 40,
            height: 57,
            decoration: BoxDecoration(
              color: index < gameState.foundation.length
                  ? Colors.green.withValues(alpha: 0.3)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: index < gameState.foundation.length
                ? const Icon(
                    Icons.check,
                    color: Colors.green,
                    size: 20,
                  )
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildTableau(GameState gameState, GameStateNotifier gameNotifier) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          10,
          (columnIndex) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: TableauColumnWidget(
              column: gameState.tableau[columnIndex],
              columnIndex: columnIndex,
              isSelected: selectedColumn == columnIndex,
              selectedCardIndex: selectedColumn == columnIndex ? selectedCardIndex : null,
              onCardTap: (cardIndex) => _handleCardTap(columnIndex, cardIndex, gameNotifier),
              onColumnTap: () => _handleColumnTap(columnIndex, gameNotifier),
            ),
          ),
        ),
      ),
    );
  }

  void _handleCardTap(int columnIndex, int cardIndex, GameStateNotifier gameNotifier) {
    final column = ref.read(gameStateProvider).tableau[columnIndex];
    
    if (cardIndex >= column.cards.length || !column.cards[cardIndex].isVisible) {
      return;
    }

    if (selectedColumn == null) {
      setState(() {
        selectedColumn = columnIndex;
        selectedCardIndex = cardIndex;
      });
    } else if (selectedColumn == columnIndex) {
      _clearSelection();
    } else {
      final success = gameNotifier.moveCards(selectedColumn!, selectedCardIndex!, columnIndex);
      _clearSelection();
      
      if (success) {
        _showMoveSuccess();
      } else {
        _showMoveError();
      }
    }
  }

  void _handleColumnTap(int columnIndex, GameStateNotifier gameNotifier) {
    if (selectedColumn != null && selectedColumn != columnIndex) {
      final success = gameNotifier.moveCards(selectedColumn!, selectedCardIndex!, columnIndex);
      _clearSelection();
      
      if (success) {
        _showMoveSuccess();
      } else {
        _showMoveError();
      }
    }
  }

  void _clearSelection() {
    setState(() {
      selectedColumn = null;
      selectedCardIndex = null;
    });
  }

  void _showMoveSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Move successful!'),
        duration: Duration(milliseconds: 500),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showMoveError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Invalid move'),
        duration: Duration(milliseconds: 1000),
        backgroundColor: Colors.red,
      ),
    );
  }
}