import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../economy/walletService.dart';
import '../../theme/appSizes.dart';
import '../../theme/borderWidths.dart';
import '../../theme/outlineColor.dart';
import '../../theme/stickerDecoration.dart';
import '../../theme/surfaceTone.dart';
import '../currencyPill.dart';

/// The top bar shown on Home and Store: an optional back button + the
/// reactive gem pill (GAME_IDEAS.md §3.11.7-a).
class WalletBar extends StatelessWidget {
  const WalletBar({super.key, this.onBack, required this.onTapPlus});

  final VoidCallback? onBack;
  final VoidCallback onTapPlus;

  @override
  Widget build(BuildContext context) {
    final wallet = Get.find<WalletService>();
    return SizedBox(
      height: AppSizes.topBarHeight,
      child: Row(
        children: [
          if (onBack != null)
            GestureDetector(
              onTap: onBack,
              child: Container(
                width: AppSizes.avatarSize,
                height: AppSizes.avatarSize,
                alignment: Alignment.center,
                decoration: stickerDecoration(
                  fill: surfaceTone(Colors.white),
                  radius: 10,
                  border: BorderWidths.thin,
                  drop: 3,
                ),
                child: Icon(Icons.arrow_back_rounded, color: OutlineColor.color),
              ),
            ),
          const Spacer(),
          Obx(() => CurrencyPill(amount: wallet.amount, onTapPlus: onTapPlus)),
        ],
      ),
    );
  }
}
