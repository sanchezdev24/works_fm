import 'package:core/core.dart' as core;
import 'package:dashboard/src/features/main/presentation/bloc/dashboard_bloc.dart';
import 'package:dashboard/src/features/main/presentation/widgets/job_card.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  static const _jobTypes = [
    (value: null, label: 'Todos'),
    (value: 'full-time', label: 'Full-time'),
    (value: 'part-time', label: 'Part-time'),
    (value: 'contract', label: 'Contrato'),
    (value: 'remote', label: 'Remoto'),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<DashboardBloc>().add(DashboardLoadMoreJobsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = core.ShadTheme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ───────────────────────────────────────────────
            _Header(theme: theme, isDark: isDark),

            // ── Search ───────────────────────────────────────────────
            _SearchBar(
              controller: _searchController,
              theme: theme,
              onChanged: (q) => context
                  .read<DashboardBloc>()
                  .add(DashboardSearchChangedEvent(query: q)),
            ),

            const SizedBox(height: 12),

            // ── Filter chips ─────────────────────────────────────────
            core.BlocBuilder<DashboardBloc, DashboardState>(
              buildWhen: (prev, curr) =>
                  prev.selectedJobType != curr.selectedJobType,
              builder: (context, state) => _FilterRow(
                jobTypes: _jobTypes,
                selected: state.selectedJobType,
                theme: theme,
                isDark: isDark,
                onSelect: (v) => context
                    .read<DashboardBloc>()
                    .add(DashboardFilterByJobTypeEvent(jobType: v)),
              ),
            ),

            const SizedBox(height: 8),

            // ── Content ──────────────────────────────────────────────
            Expanded(
              child: core.BlocBuilder<DashboardBloc, DashboardState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return _LoadingGrid();
                  }

                  if (state.isFailure) {
                    return _ErrorView(
                      message: state.errorMessage ?? 'Error al cargar empleos',
                      theme: theme,
                      onRetry: () => context
                          .read<DashboardBloc>()
                          .add( DashboardRefreshJobsEvent()),
                    );
                  }

                  if (state.isSuccess && state.jobs.isEmpty) {
                    return _EmptyView(theme: theme);
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      context
                          .read<DashboardBloc>()
                          .add( DashboardRefreshJobsEvent());
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                      itemCount:
                          state.jobs.length + (state.isLoadingMore ? 1 : 0),
                      itemBuilder: (context, i) {
                        if (i == state.jobs.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: JobCard(
                            job: state.jobs[i],
                            onTap: () {
                              // TODO: navegar al detalle del empleo
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Header
// ─────────────────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final core.ShadThemeData theme;
  final bool isDark;

  const _Header({required this.theme, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Explorar empleos',
                  style: theme.textTheme.h3.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 2),
                core.BlocBuilder<DashboardBloc, DashboardState>(
                  buildWhen: (p, c) =>
                      p.jobs.length != c.jobs.length ||
                      p.status != c.status,
                  builder: (context, state) {
                    return Text(
                      state.isSuccess
                          ? '${state.jobs.length} resultados encontrados'
                          : 'Buscando oportunidades...',
                      style: theme.textTheme.muted.copyWith(fontSize: 13),
                    );
                  },
                ),
              ],
            ),
          ),
          core.ShadButton.ghost(
            size: core.ShadButtonSize.sm,
            onPressed: () => context
                .read<DashboardBloc>()
                .add( DashboardRefreshJobsEvent()),
            child: Icon(
              core.LucideIcons.refreshCw,
              size: 18,
              color: theme.colorScheme.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Search bar
// ─────────────────────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final core.ShadThemeData theme;
  final ValueChanged<String> onChanged;

  const _SearchBar({
    required this.controller,
    required this.theme,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: core.ShadInput(
        controller: controller,
        placeholder: const Text('Buscar por título, empresa o tecnología…'),
        onChanged: onChanged,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(
            core.LucideIcons.search,
            size: 16,
            color: theme.colorScheme.mutedForeground,
          ),
        ),
        trailing: ValueListenableBuilder(
          valueListenable: controller,
          builder: (_, value, __) => value.text.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    controller.clear();
                    onChanged('');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      core.LucideIcons.x,
                      size: 14,
                      color: theme.colorScheme.mutedForeground,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Filter row
// ─────────────────────────────────────────────────────────────────────────────

class _FilterRow extends StatelessWidget {
  final List<({String? value, String label})> jobTypes;
  final String? selected;
  final core.ShadThemeData theme;
  final bool isDark;
  final ValueChanged<String?> onSelect;

  const _FilterRow({
    required this.jobTypes,
    required this.selected,
    required this.theme,
    required this.isDark,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: jobTypes.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final item = jobTypes[i];
          final isSelected = selected == item.value;
          return _FilterChip(
            label: item.label,
            selected: isSelected,
            theme: theme,
            isDark: isDark,
            onTap: () => onSelect(item.value),
          );
        },
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final core.ShadThemeData theme;
  final bool isDark;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.theme,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected
              ? theme.colorScheme.primary
              : (isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF4F4F5)),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? theme.colorScheme.primary
                : (isDark
                    ? const Color(0xFF2E2E2E)
                    : const Color(0xFFE4E4E7)),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: selected
                ? theme.colorScheme.primaryForeground
                : theme.colorScheme.mutedForeground,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Loading skeleton
// ─────────────────────────────────────────────────────────────────────────────

class _LoadingGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = core.ShadTheme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final shimmerBase =
        isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF4F4F5);

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      itemCount: 5,
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: core.ShadCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _Shimmer(
                      width: 44, height: 44, radius: 10, color: shimmerBase),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Shimmer(
                            width: 80,
                            height: 10,
                            radius: 4,
                            color: shimmerBase),
                        const SizedBox(height: 6),
                        _Shimmer(
                            width: double.infinity,
                            height: 14,
                            radius: 4,
                            color: shimmerBase),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _Shimmer(width: 160, height: 10, radius: 4, color: shimmerBase),
              const SizedBox(height: 14),
              Row(
                children: [
                  _Shimmer(
                      width: 60, height: 22, radius: 6, color: shimmerBase),
                  const SizedBox(width: 6),
                  _Shimmer(
                      width: 70, height: 22, radius: 6, color: shimmerBase),
                  const SizedBox(width: 6),
                  _Shimmer(
                      width: 55, height: 22, radius: 6, color: shimmerBase),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Shimmer extends StatefulWidget {
  final double width;
  final double height;
  final double radius;
  final Color color;

  const _Shimmer({
    required this.width,
    required this.height,
    required this.radius,
    required this.color,
  });

  @override
  State<_Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<_Shimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _anim,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(widget.radius),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Error + Empty
// ─────────────────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  final core.ShadThemeData theme;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.message,
    required this.theme,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                core.LucideIcons.circleAlert,
                size: 28,
                color: Color(0xFFDC2626),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Algo salió mal',
              style: theme.textTheme.h4.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              style: theme.textTheme.muted,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            core.ShadButton(
              onPressed: onRetry,
              leading: const Icon(core.LucideIcons.refreshCw, size: 14),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  final core.ShadThemeData theme;

  const _EmptyView({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: theme.colorScheme.muted,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                core.LucideIcons.briefcase,
                size: 32,
                color: theme.colorScheme.mutedForeground,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Sin resultados',
              style: theme.textTheme.h4.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              'Intenta ajustar los filtros o el término de búsqueda.',
              style: theme.textTheme.muted,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}