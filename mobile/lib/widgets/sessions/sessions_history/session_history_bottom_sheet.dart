import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:ndialog/ndialog.dart";
import "package:pi_mobile/data/connection/requests.dart";
import "package:pi_mobile/data/connection/shared_data.dart";
import "package:pi_mobile/data/connection/sharing_service_provider.dart";
import "package:pi_mobile/i18n/strings.g.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/widgets/sessions/common/share_notifier.dart";

class SessionsHistoryBottomSheet extends StatelessWidget {
  final ShareNotifier shareNotifier;

  const SessionsHistoryBottomSheet({super.key, required this.shareNotifier});

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: shareNotifier,
        builder: (context, _) => shareNotifier.isAnySelected()
            ? _BottomSheet(shareNotifier: shareNotifier)
            : const SizedBox.shrink(),
      );
}

class _BottomSheet extends ConsumerWidget with Logger {
  final ShareNotifier shareNotifier;

  const _BottomSheet({required this.shareNotifier});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.t.sessions.bottomSheet.sessionsSelected(
                amount: shareNotifier.getSelectedCount(),
              ),
            ),
            ElevatedButton(
              onPressed: () => _onSharePressed(context, ref),
              child: Text(context.t.sessions.bottomSheet.share),
            ),
          ],
        ),
      );

  Future<void> _onSharePressed(BuildContext context, WidgetRef ref) async {
    final selectedSessions = shareNotifier.getSelectedSessions();
    // TODO: This logic should not be contained here
    logger.debug("Share pressed. Sessions: $selectedSessions");
    final alertDialogResult = await showDialog<ShareConfirmDialogResult>(
      context: context,
      builder: (context) => _ShareConfirmDialog(sessionIds: selectedSessions),
    );

    if (alertDialogResult == ShareConfirmDialogResult.cancel) {
      return;
    }

    if (!context.mounted) {
      logger.debug("Context is not mounted. Cancelling sharing.");
      return;
    }

    final progressDialog = CustomProgressDialog(
      context,
      dismissable: false,
      loadingWidget: const CircularProgressIndicator(),
    );

    progressDialog.show();

    final sharingService = await ref.read(sharingServiceProvider.future);
    final shareResult = await sharingService
        .share(
          const ShareRequest(
            validityMillis: 2592000000,
            sharedData: SharedData(something: "a", something2: "b"),
          ),
        )
        .run();

    progressDialog.dismiss();

    if (!context.mounted) {
      logger.debug("Context is not mounted. Cancelling displaying result.");
      return;
    }

    await showDialog<ShareConfirmDialogResult>(
      context: context,
      builder: (context) => shareResult.fold(
        (fail) => const _ShareFailDialog(),
        (url) => _ShareSuccessDialog(targetUrl: url),
      ),
    );
  }
}

enum ShareConfirmDialogResult {
  confirm,
  cancel,
}

class _ShareConfirmDialog extends StatelessWidget with Logger {
  final List<int> sessionIds;

  const _ShareConfirmDialog({required this.sessionIds});

  @override
  Widget build(BuildContext context) => AlertDialog(
        content: Text(
          context.t.sessions.share.confirmDialog.content(
            amount: sessionIds.length,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => _onConfirmPressed(context),
            child: Text(context.t.general.alert.confirm),
          ),
          TextButton(
            onPressed: () => _onCancelPressed(context),
            child: Text(context.t.general.alert.cancel),
          ),
        ],
      );

  void _onConfirmPressed(BuildContext context) {
    logger.debug("Confirm pressed.");
    Navigator.pop(context, ShareConfirmDialogResult.confirm);
  }

  void _onCancelPressed(BuildContext context) {
    logger.debug("Cancel pressed.");
    Navigator.pop(context, ShareConfirmDialogResult.cancel);
  }
}

class _ShareSuccessDialog extends StatelessWidget with Logger {
  final String targetUrl;

  const _ShareSuccessDialog({required this.targetUrl});

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(
          context.t.sessions.share.sharingSucceededDialog.title,
        ),
        content: Text(
          targetUrl,
        ),
        actions: [
          TextButton(
            onPressed: () => _onOpenPressed(context),
            child:
                Text(context.t.sessions.share.sharingSucceededDialog.openLink),
          ),
          TextButton(
            onPressed: () => _onCopyPressed(context),
            child: Text(
              context.t.sessions.share.sharingSucceededDialog.copyToClipboard,
            ),
          ),
          TextButton(
            onPressed: () => _onClosePressed(context),
            child: Text(context.t.sessions.share.common.close),
          ),
        ],
      );

  void _onOpenPressed(BuildContext context) {
    logger.debug("Open pressed for $targetUrl");
    Navigator.pop(context);
  }

  void _onCopyPressed(BuildContext context) {
    logger.debug("Copy pressed for $targetUrl");
    Navigator.pop(context);
  }

  void _onClosePressed(BuildContext context) {
    logger.debug("Close pressed for $targetUrl");
    Navigator.pop(context);
  }
}

class _ShareFailDialog extends StatelessWidget with Logger {
  const _ShareFailDialog();

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(
          context.t.sessions.share.sharingFailedDialog.content,
        ),
        actions: [
          TextButton(
            onPressed: () => _onClosePressed(context),
            child: Text(context.t.sessions.share.common.close),
          ),
        ],
      );

  void _onClosePressed(BuildContext context) {
    logger.debug("Close pressed for failed sharing dialog.");
    Navigator.pop(context);
  }
}
