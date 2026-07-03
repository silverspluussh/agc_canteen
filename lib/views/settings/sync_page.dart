import 'package:agc_canteen/core/theme/app_colors.dart';
import 'package:agc_canteen/models/sync.model.dart';
import 'package:agc_canteen/views/widgets/app_buttons.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/di/injection_container.dart';
import '../../services/database/app_database.dart';
import '../../services/sync_services/sync_from_local_to_remote.dart';
import '../../services/sync_services/sync_from_remote_to_local.dart';

class SyncPage extends ConsumerStatefulWidget {
  const SyncPage({super.key});

  @override
  ConsumerState<SyncPage> createState() => _SyncPageState();
}

class _SyncPageState extends ConsumerState<SyncPage>
    with SingleTickerProviderStateMixin {
  late final LocalToRemoteSyncService _uploadService;
  late final RemoteToLocalSyncService _downloadService;
  late final AppDatabase _db;
  late final TabController _tabController;

  // ── Upload state ──
  int _unsyncedOrders = 0;
  int _unsyncedBioData = 0;
  DateTime? _uploadLastSync;
  bool _syncingOrders = false;
  bool _syncingBioData = false;
  bool _syncingAllUpload = false;

  // ── Download state ──
  int _staffCount = 0;
  int _mealTypeCount = 0;
  int _bioDataCount = 0;
  int _visitorCount = 0;
  int _contractorStaffCount = 0;
  int _dependantCount = 0;
  int _shiftCount = 0;
  bool _syncingDownload = false;

  int get _totalUploadPending => _unsyncedOrders + _unsyncedBioData;
  int get _totalLocalRecords =>
      _staffCount +
      _mealTypeCount +
      _bioDataCount +
      _visitorCount +
      _contractorStaffCount +
      _dependantCount +
      _shiftCount;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _uploadService = getIt<LocalToRemoteSyncService>();
    _downloadService = getIt<RemoteToLocalSyncService>();
    _db = getIt<AppDatabase>();
    _loadCounts();
    _loadUploadLastSync();
    _loadDownloadCounts();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ── Upload counts ──────────────────────────────────────────

  Future<void> _loadCounts() async {
    final orders = await _db.getUnsyncedOrders();
    final bioData = await _db.getUnsyncedBioData();
    if (mounted) {
      setState(() {
        _unsyncedOrders = orders.length;
        _unsyncedBioData = bioData.length;
      });
    }
  }

  Future<void> _loadUploadLastSync() async {
    final lastSync = await _uploadService.lastSync;
    if (mounted) setState(() => _uploadLastSync = lastSync);
  }

  // ── Download counts ────────────────────────────────────────

  Future<void> _loadDownloadCounts() async {
    final staff = await _db.getAllStaff();
    final mealTypes = await _db.getAllMealTypes();
    final bioData = await _db.getAllBioData();
    final visitors = await _db.getAllVisitors();
    final cStaff = await _db.getAllContractorStaff();
    final dependants = await _db.getAllDependants();
    final shifts = await _db.getAllShifts();
    if (mounted) {
      setState(() {
        _staffCount = staff.length;
        _mealTypeCount = mealTypes.length;
        _bioDataCount = bioData.length;
        _visitorCount = visitors.length;
        _contractorStaffCount = cStaff.length;
        _dependantCount = dependants.length;
        _shiftCount = shifts.length;
      });
    }
  }

  // ── Upload actions ─────────────────────────────────────────

  Future<void> _syncOrders() async {
    setState(() => _syncingOrders = true);
    try {
      final result = await _uploadService.syncSingleOrders();
      if (mounted) _showResultSnackBar(result, 'Orders');
    } finally {
      if (mounted) {
        setState(() => _syncingOrders = false);
        await _loadCounts();
        await _loadUploadLastSync();
      }
    }
  }

  Future<void> _syncBioDataUpload() async {
    setState(() => _syncingBioData = true);
    try {
      final result = await _uploadService.syncBioData();
      if (mounted) _showResultSnackBar(result, 'BioData');
    } finally {
      if (mounted) {
        setState(() => _syncingBioData = false);
        await _loadCounts();
        await _loadUploadLastSync();
      }
    }
  }

  Future<void> _syncAllUpload() async {
    setState(() => _syncingAllUpload = true);
    try {
      final result = await _uploadService.syncAll();
      if (mounted) _showResultSnackBar(result, 'All data');
    } finally {
      if (mounted) {
        setState(() => _syncingAllUpload = false);
        await _loadCounts();
        await _loadUploadLastSync();
      }
    }
  }

  // ── Download actions ───────────────────────────────────────

  Future<void> _syncDownload(String label, Future<void> Function() fn) async {
    setState(() => _syncingDownload = true);
    try {
      await fn();
      if (mounted) _showDownloadSnackBar('$label synced');
    } catch (e) {
      if (mounted) _showDownloadSnackBar('$label failed: $e', ok: false);
    } finally {
      if (mounted) {
        setState(() => _syncingDownload = false);
        await _loadDownloadCounts();
      }
    }
  }

  Future<void> _syncAllDownload() async {
    setState(() => _syncingDownload = true);
    try {
      await _downloadService.syncAll(background: false);
      if (mounted) _showDownloadSnackBar('All data synced');
    } catch (e) {
      if (mounted) _showDownloadSnackBar('Sync failed: $e', ok: false);
    } finally {
      if (mounted) {
        setState(() => _syncingDownload = false);
        await _loadDownloadCounts();
      }
    }
  }

  // ── Feedback ───────────────────────────────────────────────

  void _showResultSnackBar(SyncResult result, String label) {
    final total = result.pushed.values.fold<int>(0, (s, v) => s + v);
    final ok = result.errors.isEmpty;
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(
        content: Text(ok ? '$label: $total pushed' : result.errors.first),
        backgroundColor: ok ? Colors.green : Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showDownloadSnackBar(String msg, {bool ok = true}) {
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: ok ? Colors.green : Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ── View unsynced orders modal ─────────────────────────────

  Future<void> _viewUnsyncedOrders() async {
    final staff = await _db.getAllStaff();
    String staffName(int id) {
      final s = staff.where((e) => e.id == id).firstOrNull;
      return s != null ? '${s.firstName} ${s.lastName}' : id.toString();
    }
    if (!mounted) return;

    final orders = await _db.getUnsyncedOrders();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        builder: (_, scrollCtrl) => Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            const Text('Unsynced Orders',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('${orders.length} orders',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
            const SizedBox(height: 8),
            Expanded(
              child: orders.isEmpty
                  ? const Center(child: Text('No unsynced orders'))
                  : ListView.separated(
                      controller: scrollCtrl,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: orders.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (_, i) {
                        final o = orders[i];
                        return ListTile(
                          dense: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 4),
                          leading: CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.orange.withOpacity(0.1),
                            child: const Icon(Icons.receipt_long,
                                size: 18, color: Colors.orange),
                          ),
                          title: Text(o.orderCode,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600)),
                          subtitle: Text(
                            '${o.mealType} · ${o.groupCount} item${o.groupCount != 1 ? 's' : ''} · ${staffName(o.orderedById)}',
                            style: const TextStyle(fontSize: 12),
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

  // ── Build ──────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        title: const Text('Data Sync'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: cs.onPrimary.withOpacity(0.6),
          labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          tabs: const [
            Tab(icon: Icon(Icons.upload_rounded), text: 'Upload to Server'),
            Tab(icon: Icon(Icons.download_rounded), text: 'Download from Server'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildUploadTab(cs),
          _buildDownloadTab(cs),
        ],
      ),
    );
  }

  // ── Upload tab ─────────────────────────────────────────────

  Widget _buildUploadTab(ColorScheme cs) {
    final lastSyncStr = _uploadLastSync != null
        ? DateFormat('dd MMM yyyy, hh:mm a').format(_uploadLastSync!)
        : 'Never';
    final accent = const Color(0xFF1565C0); // blue

    return RefreshIndicator(
      onRefresh: () async {
        await _loadCounts();
        await _loadUploadLastSync();
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          _buildSummaryHeader(cs, _totalUploadPending > 0
              ? '$_totalUploadPending pending item${_totalUploadPending != 1 ? 's' : ''}'
              : 'Everything is up to date', accent: accent),
          const SizedBox(height: 20),

          _sectionHeader('Pending Upload'),
          const SizedBox(height: 10),
          _SyncStatCard(
            icon: Icons.receipt_long_outlined,
            label: 'Vouchers',
            count: _unsyncedOrders,
            syncing: _syncingOrders,
            onSync: _unsyncedOrders > 0 ? _syncOrders : null,
            onView: _unsyncedOrders > 0 ? _viewUnsyncedOrders : null,
          ),
          const SizedBox(height: 12),
          _SyncStatCard(
            icon: Icons.fingerprint,
            label: 'BioData',
            count: _unsyncedBioData,
            syncing: _syncingBioData,
            onSync: _unsyncedBioData > 0 ? _syncBioDataUpload : null,
            onView: null,
          ),

          const SizedBox(height: 24),
          _sectionHeader('Last Upload'),
          const SizedBox(height: 10),
          _lastSyncInfo(cs, lastSyncStr, accent: accent),

          const SizedBox(height: 28),
          _primaryButton(
            onPressed: _syncingAllUpload ? null : _syncAllUpload,
            loading: _syncingAllUpload,
            label: 'Upload All',
            accent: AppColors.gold600,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // ── Download tab ───────────────────────────────────────────

  Widget _buildDownloadTab(ColorScheme cs) {
    final accent = const Color(0xFF00695C); // teal

    return RefreshIndicator(
      onRefresh: () async => _loadDownloadCounts(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          _buildSummaryHeader(cs, '$_totalLocalRecords local records',
              accent: accent),
          const SizedBox(height: 20),

          _sectionHeader('Fetch from Remote'),
          const SizedBox(height: 10),
          _SyncStatCard(
            icon: Icons.people_outline,
            label: 'Staff',
            count: _staffCount,
            syncing: _syncingDownload,
            onSync: () => _syncDownload('Staff', _downloadService.syncStaffOnly),
            onView: null,
          ),
          const SizedBox(height: 10),
          _SyncStatCard(
            icon: Icons.restaurant_menu,
            label: 'MealTypes',
            count: _mealTypeCount,
            syncing: _syncingDownload,
            onSync: () => _syncDownload(
                'Meal types', _downloadService.syncMealTypesOnly),
            onView: null,
          ),
          const SizedBox(height: 10),
          _SyncStatCard(
            icon: Icons.fingerprint,
            label: 'BioData',
            count: _bioDataCount,
            syncing: _syncingDownload,
            onSync: () => _syncDownload(
                'BioData', _downloadService.syncBioDataOnly),
            onView: null,
          ),
          const SizedBox(height: 10),
          _SyncStatCard(
            icon: Icons.person_add_outlined,
            label: 'Visitors',
            count: _visitorCount,
            syncing: _syncingDownload,
            onSync: () => _syncDownload(
                'Visitors', _downloadService.syncVisitorsOnly),
            onView: null,
          ),
          const SizedBox(height: 10),
          _SyncStatCard(
            icon: Icons.engineering_outlined,
            label: 'Contractor Staff',
            count: _contractorStaffCount,
            syncing: _syncingDownload,
            onSync: () => _syncDownload(
                'Contractor staff', _downloadService.syncContractorStaffOnly),
            onView: null,
          ),
          const SizedBox(height: 10),
          _SyncStatCard(
            icon: Icons.family_restroom,
            label: 'Dependants',
            count: _dependantCount,
            syncing: _syncingDownload,
            onSync: () => _syncDownload(
                'Dependants', _downloadService.syncDependantsOnly),
            onView: null,
          ),
          const SizedBox(height: 10),
          _SyncStatCard(
            icon: Icons.schedule,
            label: 'Shifts',
            count: _shiftCount,
            syncing: _syncingDownload,
            onSync: () => _syncDownload(
                'Shifts', _downloadService.syncShiftsOnly),
            onView: null,
          ),

          const SizedBox(height: 28),
          _primaryButton(
            onPressed: _syncingDownload ? null : _syncAllDownload,
            loading: _syncingDownload,
            label: 'Download All',
            accent: AppColors.gold500,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // ── Shared widgets ─────────────────────────────────────────

  Widget _buildSummaryHeader(ColorScheme cs, String subtitle,
      {Color? accent}) {
    final color = accent ?? cs.primary;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.85), color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Data Synchronization',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Text(subtitle,
                    style: TextStyle(
                        color: Colors.white, fontSize: 13)),
              ],
            ),
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: cs.onPrimary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.sync_rounded,
                color: Colors.white, size: 28),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(text,
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withOpacity(0.5),
              letterSpacing: 0.5)),
    );
  }

  Widget _lastSyncInfo(ColorScheme cs, String lastSyncStr, {Color? accent}) {
    final color = accent ?? cs.primary;
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant.withOpacity(0.4)),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.history_rounded, size: 20, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Last Upload',
                    style: TextStyle(
                        fontSize: 13,
                        color: cs.onSurface.withOpacity(0.6))),
                const SizedBox(height: 2),
                Text(lastSyncStr,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 15)),
              ],
            ),
          ),
          IconButton(
            onPressed: () async => _loadUploadLastSync(),
            icon: Icon(Icons.refresh_rounded, color: cs.primary),
            tooltip: 'Refresh',
          ),
        ],
      ),
    );
  }

  Widget _primaryButton({
    required VoidCallback? onPressed,
    required bool loading,
    required String label,
    Color? accent,
  }) {
    final color = accent ?? const Color(0xFF1565C0);
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: PrimaryButton(
        onPressed: onPressed,
        color: color,
        label: loading
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2.5, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Text('Syncing...',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16)),
                ],
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.sync_rounded,
                      color: Colors.white, size: 22),
                  const SizedBox(width: 10),
                  Text(label,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16)),
                ],
              ),
      ),
    );
  }
}

// ── Reusable sync stat card ──────────────────────────────────

class _SyncStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final bool syncing;
  final VoidCallback? onSync;
  final VoidCallback? onView;

  const _SyncStatCard({
    required this.icon,
    required this.label,
    required this.count,
    required this.syncing,
    this.onSync,
    this.onView,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hasData = count > 0;
    final accentColor = hasData ? Colors.orange : Colors.green;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: accentColor.withOpacity(hasData ? 0.4 : 0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
              color: accentColor.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: accentColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15)),
                    const SizedBox(height: 2),
                    Text(hasData ? '$count records' : 'Up to date',
                        style: TextStyle(
                            fontSize: 13,
                            color: accentColor,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              if (hasData)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('$count',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: accentColor)),
                ),
              if (!hasData)
                Icon(Icons.check_circle, size: 22, color: accentColor),
            ],
          ),
          if (onSync != null || onView != null) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                if (onView != null) ...[
                  Expanded(
                    child: SizedBox(
                      height: 38,
                      child: OutlinedButton.icon(
                        onPressed: onView,
                        icon: const Icon(Icons.visibility_outlined, size: 16),
                        label:
                            const Text('View', style: TextStyle(fontSize: 13)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: accentColor,
                          side:
                              BorderSide(color: accentColor.withOpacity(0.5)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
                if (onSync != null)
                  Expanded(
                    child: SizedBox(
                      height: 38,
                      child: ElevatedButton.icon(
                        onPressed: syncing ? null : onSync,
                        icon: syncing
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              )
                            : const Icon(Icons.sync_rounded,
                                size: 16, color: Colors.white),
                        label: syncing
                            ? const SizedBox.shrink()
                            : const Text('Sync',
                                style: TextStyle(
                                    fontSize: 13, color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
