import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class ActionStepCard extends StatefulWidget {
  final int stepNumber;
  final String title;
  final String description;
  final String timeLimit;
  final bool initialIsDone;
  final ValueChanged<bool>? onToggleDone;

  const ActionStepCard({
    super.key,
    required this.stepNumber,
    required this.title,
    required this.description,
    required this.timeLimit,
    this.initialIsDone = false,
    this.onToggleDone,
  });

  @override
  State<ActionStepCard> createState() => _ActionStepCardState();
}

class _ActionStepCardState extends State<ActionStepCard> {
  late bool _isDone;

  @override
  void initState() {
    super.initState();
    _isDone = widget.initialIsDone;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: _isDone ? AppColors.riskLowBackground : AppColors.borderOutline,
          width: _isDone ? 1.5 : 0.8,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Number Circle
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: _isDone
                    ? AppColors.riskLowBackground
                    : AppColors.primaryHeader,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: _isDone
                    ? const Icon(Icons.check, color: Colors.white, size: 20)
                    : Text(
                        '${widget.stepNumber}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 12),

            // Content Body
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.title,
                          style: AppTypography.actionTitle.copyWith(
                            decoration: _isDone ? TextDecoration.lineThrough : null,
                            color: _isDone ? AppColors.textSecondary : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Time Limit Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.riskMediumLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.timer_outlined,
                          size: 14,
                          color: AppColors.riskMediumText,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.timeLimit,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.riskMediumText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Description
                  Text(
                    widget.description,
                    style: AppTypography.actionBody,
                  ),
                ],
              ),
            ),

            // Checkbox Toggle
            Checkbox(
              value: _isDone,
              activeColor: AppColors.riskLowBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _isDone = val;
                  });
                  widget.onToggleDone?.call(val);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
