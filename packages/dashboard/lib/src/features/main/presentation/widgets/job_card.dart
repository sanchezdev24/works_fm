import 'package:core/core.dart';
import 'package:dashboard/src/features/main/domain/entities/job_entity.dart';
import 'package:flutter/material.dart';

class JobCard extends StatelessWidget {
  final JobEntity job;
  final VoidCallback? onTap;

  const JobCard({super.key, required this.job, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: ShadCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header: logo + meta ──────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Company logo / initials
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1E1E1E)
                        : const Color(0xFFF4F4F5),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF2A2A2A)
                          : const Color(0xFFE4E4E7),
                    ),
                  ),
                  child: job.companyLogo.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(9),
                          child: Image.network(
                            job.companyLogo,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                _CompanyInitials(name: job.company, theme: theme),
                          ),
                        )
                      : _CompanyInitials(name: job.company, theme: theme),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.company,
                        style: theme.textTheme.muted.copyWith(fontSize: 12),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        job.title,
                        style: theme.textTheme.p.copyWith(
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _JobTypeBadge(jobType: job.jobType, theme: theme),
              ],
            ),

            const SizedBox(height: 14),

            // ── Location + salary ────────────────────────────────────
            Row(
              children: [
                Icon(
                  LucideIcons.mapPin,
                  size: 13,
                  color: theme.colorScheme.mutedForeground,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    job.location,
                    style: theme.textTheme.muted.copyWith(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (job.salary.isNotEmpty) ...[
                  const SizedBox(width: 12),
                  Icon(
                    LucideIcons.banknote,
                    size: 13,
                    color: theme.colorScheme.mutedForeground,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    job.salary,
                    style: theme.textTheme.muted.copyWith(fontSize: 12),
                  ),
                ],
              ],
            ),

            const SizedBox(height: 14),

            // ── Tags ─────────────────────────────────────────────────
            if (job.tags.isNotEmpty)
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: job.tags
                    .take(4)
                    .map(
                      (tag) => _TagChip(tag: tag, theme: theme, isDark: isDark),
                    )
                    .toList(),
              ),

            const SizedBox(height: 14),

            // ── Footer: date + apply ──────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      LucideIcons.clock,
                      size: 12,
                      color: theme.colorScheme.mutedForeground,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(job.publishedAt),
                      style: theme.textTheme.muted.copyWith(fontSize: 11),
                    ),
                  ],
                ),
                ShadButton.outline(
                  size: ShadButtonSize.sm,
                  onPressed: onTap,
                  child: Row(
                    children: [
                      const Text('Ver más'),
                      const SizedBox(width: 4),
                      Icon(
                        LucideIcons.arrowRight,
                        size: 12,
                        color: theme.colorScheme.foreground,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String isoDate) {
    try {
      final dt = DateTime.parse(isoDate);
      final now = DateTime.now();
      final diff = now.difference(dt);
      if (diff.inDays == 0) return 'Hoy';
      if (diff.inDays == 1) return 'Ayer';
      if (diff.inDays < 7) return 'Hace ${diff.inDays} días';
      if (diff.inDays < 30) return 'Hace ${(diff.inDays / 7).floor()} sem';
      return 'Hace ${(diff.inDays / 30).floor()} mes';
    } catch (_) {
      return isoDate;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _CompanyInitials extends StatelessWidget {
  final String name;
  final ShadThemeData theme;

  const _CompanyInitials({required this.name, required this.theme});

  @override
  Widget build(BuildContext context) {
    final initials = name.isNotEmpty
        ? name.trim().split(' ').take(2).map((w) => w[0].toUpperCase()).join()
        : '?';
    return Center(
      child: Text(
        initials,
        style: theme.textTheme.small.copyWith(
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.mutedForeground,
        ),
      ),
    );
  }
}

class _JobTypeBadge extends StatelessWidget {
  final String jobType;
  final ShadThemeData theme;

  const _JobTypeBadge({required this.jobType, required this.theme});

  @override
  Widget build(BuildContext context) {
    final isDark = theme.brightness == Brightness.dark;

    final (label, color, bgColor) = switch (jobType.toLowerCase()) {
      'full-time' || 'fulltime' => (
          'Full-time',
          const Color(0xFF16A34A),
          const Color(0xFFDCFCE7),
        ),
      'part-time' || 'parttime' => (
          'Part-time',
          const Color(0xFF7C3AED),
          const Color(0xFFF5F3FF),
        ),
      'contract' => (
          'Contrato',
          const Color(0xFFD97706),
          const Color(0xFFFEF3C7),
        ),
      'remote' => (
          'Remoto',
          const Color(0xFF0EA5E9),
          const Color(0xFFE0F2FE),
        ),
      _ => (
          jobType,
          theme.colorScheme.mutedForeground,
          theme.colorScheme.muted,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isDark ? color.withOpacity(0.15) : bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? color.withOpacity(0.4) : color.withOpacity(0.3),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: isDark ? color.withOpacity(0.9) : color,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String tag;
  final ShadThemeData theme;
  final bool isDark;

  const _TagChip({
    required this.tag,
    required this.theme,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1A1A1A)
            : const Color(0xFFF4F4F5),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isDark
              ? const Color(0xFF2E2E2E)
              : const Color(0xFFE4E4E7),
        ),
      ),
      child: Text(
        tag,
        style: theme.textTheme.muted.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}