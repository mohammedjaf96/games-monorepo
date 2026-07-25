import 'package:flutter/material.dart';
import 'package:game_core/game_core.dart';
import 'package:get/get.dart';

import '../theme/blockoNeonTokens.dart';
import 'blockoCurrencyPill.dart';

/// The top bar shown on Home and Store — the "Neon Drop" equivalent of the
/// shared cutesy `WalletBar`: an optional back button + the reactive gem
/// pill.
class BlockoWalletBar extends StatelessWidget {
  const BlockoWalletBar({super.key, this.onBack, required this.onTapPlus});

  final VoidCallback? onBack;
  final VoidCallback onTapPlus;

  @override
  Widget build(BuildContext context) {
    final wallet = Get.find<WalletService>();
    final palette = BlockoNeonTokens.of(context);
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
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: palette.panelBackground,
                  border: Border.all(color: palette.panelBorder),
                  boxShadow: [BoxShadow(color: palette.hamburgerGlow, blurRadius: 8)],
                ),
                child: Icon(Icons.arrow_back_rounded, color: palette.textPrimary),
              ),
            ),
          const Spacer(),
          Obx(() => BlockoCurrencyPill(amount: wallet.amount, onTapPlus: onTapPlus)),
        ],
      ),
    );
  }
}
