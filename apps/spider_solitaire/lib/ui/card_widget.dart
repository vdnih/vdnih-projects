import 'package:flutter/material.dart';
import '../game/card.dart';
import '../game/utils.dart';

class CardWidget extends StatelessWidget {
  final PlayingCard? card;
  final bool isSelected;
  final bool isHinted;
  final VoidCallback? onTap;
  final double width;
  final double height;

  const CardWidget({
    super.key,
    this.card,
    this.isSelected = false,
    this.isHinted = false,
    this.onTap,
    this.width = 60,
    this.height = 90,
  });

  @override
  Widget build(BuildContext context) {
    if (card == null) {
      return _buildEmptySlot();
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: card!.isVisible ? Colors.white : const Color(0xFF1565C0),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? Colors.blue
                : isHinted
                    ? Colors.green
                    : Colors.grey.shade400,
            width: isSelected || isHinted ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: card!.isVisible ? _buildCardFace() : _buildCardBack(),
      ),
    );
  }

  Widget _buildCardFace() {
    final isRed = card!.suit == Suit.hearts || card!.suit == Suit.diamonds;
    final color = isRed ? Colors.red : Colors.black;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2.0, left: 4.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  GameUtils.getRankSymbol(card!.rank),
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    height: 0.8,
                  ),
                ),
                Text(
                  GameUtils.getSuitSymbol(card!.suit),
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    height: 0.8,
                  ),
                ),
              ],
            ),
          ),
        ),
        Center(
          child: Text(
            GameUtils.getSuitSymbol(card!.suit),
            style: TextStyle(
              color: color,
              fontSize: 20,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 2.0, right: 4.0),
          child: Transform.rotate(
            angle: 3.14159, // 180 degrees
            child: Align(
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    GameUtils.getRankSymbol(card!.rank),
                    style: TextStyle(
                      color: color,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      height: 0.8,
                    ),
                  ),
                  Text(
                    GameUtils.getSuitSymbol(card!.suit),
                    style: TextStyle(
                      color: color,
                      fontSize: 10,
                      height: 0.8,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardBack() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1976D2),
            Color(0xFF1565C0),
          ],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.casino,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  Widget _buildEmptySlot() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
          style: BorderStyle.solid,
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.add,
          color: Colors.grey,
          size: 20,
        ),
      ),
    );
  }
}