import 'package:flutter/material.dart';
import '../game/tableau.dart';
import 'card_widget.dart';

class TableauColumnWidget extends StatelessWidget {
  final TableauColumn column;
  final int columnIndex;
  final bool isSelected;
  final int? selectedCardIndex;
  final Function(int) onCardTap;
  final VoidCallback onColumnTap;

  const TableauColumnWidget({
    super.key,
    required this.column,
    required this.columnIndex,
    required this.isSelected,
    required this.selectedCardIndex,
    required this.onCardTap,
    required this.onColumnTap,
  });

  @override
  Widget build(BuildContext context) {
    const cardWidth = 60.0;
    const cardHeight = 85.0;
    const cardSpacing = 20.0;

    if (column.isEmpty) {
      return GestureDetector(
        onTap: onColumnTap,
        child: Container(
          width: cardWidth,
          height: cardHeight,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? Colors.blue : Colors.white.withOpacity(0.3),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.add,
              color: Colors.white60,
              size: 30,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: cardWidth,
      child: Stack(
        children: [
          ...column.cards.asMap().entries.map((entry) {
            final index = entry.key;
            final card = entry.value;
            final isCardSelected = isSelected && selectedCardIndex == index;
            
            return Positioned(
              top: index * cardSpacing,
              child: GestureDetector(
                onTap: () => onCardTap(index),
                child: CardWidget(
                  card: card,
                  isSelected: isCardSelected,
                  width: cardWidth,
                  height: cardHeight,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}