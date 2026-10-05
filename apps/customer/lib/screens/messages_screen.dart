import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/format.dart';
import '../data/models.dart';
import '../l10n/catalog_text.dart';
import '../l10n/l10n.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

/// Messages tab: one conversation per booking with a technician.
class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.navMessages)),
      body: AsyncView(
        load: context.repo.conversations,
        builder: (context, conversations, reload) => RefreshIndicator(
          color: AppColors.ink,
          onRefresh: reload,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: conversations.isEmpty ? 1 : conversations.length,
            separatorBuilder: (_, _) => const Divider(indent: 84, endIndent: 20),
            itemBuilder: (context, i) => conversations.isEmpty
                ? EmptyState(
                    icon: Icons.chat_bubble_outline_rounded,
                    title: context.l10n.noMessagesYet,
                    message: context.l10n.noMessagesHint,
                  )
                : _ConversationTile(conversation: conversations[i], onReturn: reload),
          ),
        ),
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  const _ConversationTile({required this.conversation, required this.onReturn});

  final Conversation conversation;
  final Future<void> Function() onReturn;

  @override
  Widget build(BuildContext context) {
    final c = conversation;
    final firstName = c.technicianName.split(' ').first;
    final last = c.lastMessage;
    final preview = last == null
        ? context.l10n.sayHelloTo(firstName)
        : (last.mine ? context.l10n.youPrefix(last.body) : last.body);
    final unread = c.unreadCount > 0;
    final when = isToday(c.lastActivityAt) ? context.time(c.lastActivityAt) : context.day(c.lastActivityAt);

    return InkWell(
      onTap: () async {
        await context.push('/booking/${c.bookingId}/chat');
        await onReturn();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Avatar(name: c.technicianName, size: 50),
                if (c.chatOpen)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 13,
                      height: 13,
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.background, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          c.technicianName,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Text(
                        when,
                        style: TextStyle(
                          fontSize: 12,
                          color: unread ? AppColors.yellowDeep : AppColors.muted,
                          fontWeight: unread ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          preview,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13.5,
                            color: unread ? AppColors.ink : AppColors.muted,
                            fontWeight: unread ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ),
                      if (unread) ...[
                        const SizedBox(width: 8),
                        Container(
                          constraints: const BoxConstraints(minWidth: 20),
                          height: 20,
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(color: AppColors.yellow, borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            '${c.unreadCount}',
                            style: const TextStyle(color: AppColors.black, fontSize: 11, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text('${context.problemName(c.title)} · ${c.reference}', style: TextStyle(fontSize: 12, color: AppColors.muted)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
