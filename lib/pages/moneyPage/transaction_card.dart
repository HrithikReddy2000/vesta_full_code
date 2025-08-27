import 'package:flutter/material.dart';
import 'package:projectmercury/models/transaction.dart';
import 'package:projectmercury/resources/firestore_methods.dart';
import 'package:projectmercury/resources/locator.dart';
import 'package:projectmercury/utils/utils.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;
  const TransactionCard({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Container(
        decoration: elevatedCardDecor(context),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formatDateTime(transaction.timeStamp!),
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          transaction.currentState == TransactionState.pending
                              ? transaction.amount > 0
                                  ? 'Pending Deposit'
                                  : 'Pending Charge'
                              : transaction.description,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  transaction.currentState == TransactionState.pending
                      ? const CircularProgressIndicator(
                          color: Colors.grey,
                        )
                      : Text(
                          (transaction.amount > 0 ? '+' : '') +
                              formatCurrency.format(transaction.amount),
                          style: const TextStyle(
                            fontSize: 24,
                          ),
                        ),
                ],
              ),
            ),
            const Divider(height: 1),
            if (transaction.currentState == TransactionState.actionNeeded) ...[
              yesOrNo(
                context,
                yesLabel: 'Approve',
                noLabel: 'Dispute',
                yesConfirmationMessage: 'Approve this transaction?',
                noConfirmationMessage: 'Dispute this transaction?',
                onYes: () =>
                    //_firestore.transactionAction(context, transaction, true),
                    locator
                        .get<FirestoreMethods>()
                        .resolveTransaction(context, transaction, true),
                onNo: () =>
                    //_firestore.transactionAction(context, transaction, false),
                    locator
                        .get<FirestoreMethods>()
                        .resolveTransaction(context, transaction, false),
              ),
            ] else if (transaction.currentState ==
                TransactionState.approved) ...[
              const Text(
                'Approved',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.green,
                ),
              )
            ] else if (transaction.currentState ==
                TransactionState.disputed) ...[
              const Text(
                'Disputed',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.red,
                ),
              ),
            ],
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
