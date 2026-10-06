import 'package:flutter/material.dart';

/// App-bar action that re-runs fingerprint initialisation.
///
/// The scanner is initialised once when the page opens. If that first attempt
/// fails — a slow kernel SPI probe, a reader that enumerated late, a cable seated
/// after boot — there was previously no way back short of killing the app, so the
/// operator was stuck on a page with no buttons. This action is the escape hatch.
///
/// [busy] exists because a retry is not instant: the auth service waits out the
/// kernel probe and retries up to four times with backoff, so a full attempt can
/// take ~20s. Without a busy state the button invites repeated taps that stack
/// overlapping init attempts against a native SDK that reports "already in
/// progress".
class FingerprintReloadAction extends StatelessWidget {
  const FingerprintReloadAction({
    super.key,
    required this.busy,
    required this.onPressed,
    this.iconColor = Colors.white,
    this.iconSize = 30,
  });

  final bool busy;
  final VoidCallback? onPressed;
  final Color iconColor;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      // Disabled while a retry is in flight; see [busy].
      onPressed: busy ? null : onPressed,
      tooltip: 'Reload fingerprint reader',
      icon: busy
          ? SizedBox(
              width: iconSize - 6,
              height: iconSize - 6,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: iconColor,
              ),
            )
          : Icon(Icons.refresh, size: iconSize, color: iconColor),
    );
  }
}

/// Shown in the page body when fingerprint initialisation has failed.
///
/// The auth buttons are gated on the reader being ready, so without this the page
/// renders blank — no buttons, no spinner, no explanation. This makes the failure
/// legible and gives the retry a target inside the content area, not only in the
/// app bar.
class FingerprintInitFailureCard extends StatelessWidget {
  const FingerprintInitFailureCard({
    super.key,
    required this.onRetry,
    this.busy = false,
  });

  final VoidCallback? onRetry;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.fingerprint, color: colors.onErrorContainer, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fingerprint reader unavailable',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colors.onErrorContainer,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'The scanner did not start, so vouchers cannot be issued '
                      'by fingerprint. Check that the reader is plugged in and '
                      'that no other app is using it, then try again.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.onErrorContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: busy ? null : onRetry,
              icon: busy
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.refresh, size: 18),
              label: Text(busy ? 'Retrying…' : 'Retry'),
              style: FilledButton.styleFrom(
                backgroundColor: colors.error,
                foregroundColor: colors.onError,
              ),
            ),
          ),
        ],
      ),
    );
  }
}