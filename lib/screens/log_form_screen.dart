import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../theme/app_colors.dart';

const _categories = ['Food', 'Nature', 'Architecture', 'Culture', 'Nightlife', 'Beaches', 'History', 'Conferences'];

enum _Visibility { public, friendsOnly, private }

/// Second step of logging a memory: ratings, an optional real 3D scan
/// (via native Swift RoomPlan code — see ios/Runner/RoomScanViewController.swift
/// and AppDelegate.swift — LiDAR devices only), photos and videos, dates,
/// comments, friends who were there, and a visibility setting. There's no
/// backend, so Submit just pops back with `true` to let LogSearchScreen
/// (and whatever opened it) know a memory was logged.
class LogFormScreen extends StatefulWidget {
  const LogFormScreen({super.key, required this.cityName, required this.country});

  final String cityName;
  final String country;

  @override
  State<LogFormScreen> createState() => _LogFormScreenState();
}

class _LogFormScreenState extends State<LogFormScreen> {
  final Map<String, int> _ratings = {for (final c in _categories) c: 0};
  bool _include3DScan = false;
  final List<File> _photos = [];
  final List<File> _videos = [];
  DateTimeRange? _dateRange;
  final _commentsController = TextEditingController();
  final _friendController = TextEditingController();
  final List<String> _friends = [];
  _Visibility _visibility = _Visibility.public;

  final _roomPlanChannel = const MethodChannel('roamlog/roomplan');
  bool _scanning = false;
  String? _scanUsdzPath;

  @override
  void dispose() {
    _commentsController.dispose();
    _friendController.dispose();
    super.dispose();
  }

  Future<void> _pickPhotos() async {
    final picked = await ImagePicker().pickMultiImage(imageQuality: 80);
    if (picked.isNotEmpty) {
      setState(() => _photos.addAll(picked.map((x) => File(x.path))));
    }
  }

  Future<void> _pickVideo() async {
    final picked = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _videos.add(File(picked.path)));
    }
  }

  Future<void> _viewScan() async {
    final path = _scanUsdzPath;
    if (path == null) return;
    // Opens Apple's native AR Quick Look viewer directly — see the
    // "viewScan" case in SceneDelegate.swift.
    try {
      await _roomPlanChannel.invokeMethod('viewScan', path);
    } on PlatformException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Couldn\'t open the scan: ${e.message}')),
      );
    }
  }

  Future<void> _start3DScan() async {
    bool supported = false;
    try {
      supported = await _roomPlanChannel.invokeMethod<bool>('isSupported') ?? false;
    } on PlatformException {
      supported = false;
    }

    if (!supported) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('3D scanning needs a LiDAR iPhone/iPad (Pro models) running iOS 16+'),
        ),
      );
      return;
    }

    setState(() => _scanning = true);
    try {
      // This hands off to Apple's native RoomPlan capture screen — the
      // person walks around the space and it builds the 3D model. This
      // call doesn't return until they finish or cancel.
      final path = await _roomPlanChannel.invokeMethod<String>('startScan');
      if (!mounted) return;
      setState(() {
        _scanning = false;
        _scanUsdzPath = path;
      });
    } on PlatformException catch (e) {
      if (!mounted) return;
      setState(() => _scanning = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Couldn\'t start the scan: ${e.message}')),
      );
    }
  }

  Future<void> _pickDates() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 10),
      lastDate: DateTime(now.year + 2),
      initialDateRange: _dateRange,
    );
    if (picked != null) {
      setState(() => _dateRange = picked);
    }
  }

  void _addFriend() {
    final username = _friendController.text.trim();
    if (username.isEmpty) return;
    setState(() {
      _friends.add(username.startsWith('@') ? username : '@$username');
      _friendController.clear();
    });
  }

  void _handleSubmit() {
    // TODO: this is where you'd send everything (ratings, media, dates,
    // comments, friends, visibility) to a real backend. For now it just
    // confirms the flow works end to end.
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 24, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back, color: AppColors.navy),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.cityName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.navy)),
                        Text(widget.country, style: const TextStyle(fontSize: 12.5, color: AppColors.navyMuted)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _SectionLabel('RATE YOUR EXPERIENCE'),
                    const SizedBox(height: 10),
                    for (final category in _categories)
                      _RatingRow(
                        label: category,
                        value: _ratings[category]!,
                        onChanged: (value) => setState(() => _ratings[category] = value),
                      ),
                    const SizedBox(height: 20),

                    const _SectionLabel('3D SCAN'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: const Text('Include a 3D scan of this location', style: TextStyle(fontSize: 13.5, color: AppColors.navy)),
                        ),
                        Switch(
                          value: _include3DScan,
                          activeThumbColor: AppColors.gold,
                          onChanged: (value) => setState(() => _include3DScan = value),
                        ),
                      ],
                    ),
                    if (_include3DScan) ...[
                      const SizedBox(height: 4),
                      if (_scanUsdzPath == null)
                        OutlinedButton.icon(
                          onPressed: _scanning ? null : _start3DScan,
                          icon: _scanning
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.navy),
                                )
                              : const Icon(Icons.view_in_ar_outlined, size: 18, color: AppColors.navy),
                          label: Text(_scanning ? 'Starting scan…' : 'Start 3D scan', style: const TextStyle(color: AppColors.navy)),
                          style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.navy)),
                        )
                      else
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.check_circle, size: 15, color: AppColors.gold),
                                  SizedBox(width: 6),
                                  Text('3D scan captured', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.gold)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: _viewScan,
                              child: const Text('View', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.navy)),
                            ),
                            const SizedBox(width: 14),
                            GestureDetector(
                              onTap: _start3DScan,
                              child: const Text('Re-scan', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.navyMuted)),
                            ),
                          ],
                        ),
                    ],
                    const SizedBox(height: 20),

                    const _SectionLabel('PHOTOS & VIDEOS'),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: _MediaButton(icon: Icons.add_photo_alternate_outlined, label: 'Add photos', onTap: _pickPhotos)),
                        const SizedBox(width: 10),
                        Expanded(child: _MediaButton(icon: Icons.videocam_outlined, label: 'Add video', onTap: _pickVideo)),
                      ],
                    ),
                    if (_photos.isNotEmpty || _videos.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _MediaPreviewRow(
                        photos: _photos,
                        videos: _videos,
                        onRemovePhoto: (file) => setState(() => _photos.remove(file)),
                        onRemoveVideo: (file) => setState(() => _videos.remove(file)),
                      ),
                    ],
                    const SizedBox(height: 20),

                    const _SectionLabel('DATES SPENT'),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _pickDates,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(color: AppColors.creamDark, borderRadius: BorderRadius.circular(14)),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today_outlined, size: 17, color: AppColors.navyMuted),
                            const SizedBox(width: 10),
                            Text(
                              _dateRange == null ? 'Select dates' : _formatRange(_dateRange!),
                              style: const TextStyle(fontSize: 13.5, color: AppColors.navy),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    const _SectionLabel('COMMENTS'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _commentsController,
                      maxLines: 4,
                      style: const TextStyle(fontSize: 13.5, color: AppColors.navy),
                      decoration: InputDecoration(
                        hintText: 'What stood out about this trip?',
                        hintStyle: TextStyle(fontSize: 13.5, color: AppColors.navyMuted.withOpacity(0.6)),
                        filled: true,
                        fillColor: AppColors.creamDark,
                        contentPadding: const EdgeInsets.all(14),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 20),

                    const _SectionLabel('FRIENDS YOU WERE WITH'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _friendController,
                            onSubmitted: (_) => _addFriend(),
                            style: const TextStyle(fontSize: 13.5, color: AppColors.navy),
                            decoration: InputDecoration(
                              hintText: 'Username',
                              hintStyle: TextStyle(fontSize: 13.5, color: AppColors.navyMuted.withOpacity(0.6)),
                              filled: true,
                              fillColor: AppColors.creamDark,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: _addFriend,
                          icon: const Icon(Icons.add_circle, color: AppColors.navy, size: 28),
                        ),
                      ],
                    ),
                    if (_friends.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final friend in _friends)
                            Chip(
                              label: Text(friend, style: const TextStyle(fontSize: 12.5, color: AppColors.navy)),
                              backgroundColor: AppColors.creamDark,
                              deleteIcon: const Icon(Icons.close, size: 15, color: AppColors.navyMuted),
                              onDeleted: () => setState(() => _friends.remove(friend)),
                              side: BorderSide.none,
                            ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 20),

                    const _SectionLabel('WHO CAN SEE THIS'),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: _VisibilityOption(label: 'Public', selected: _visibility == _Visibility.public, onTap: () => setState(() => _visibility = _Visibility.public))),
                        const SizedBox(width: 8),
                        Expanded(child: _VisibilityOption(label: 'Friends only', selected: _visibility == _Visibility.friendsOnly, onTap: () => setState(() => _visibility = _Visibility.friendsOnly))),
                        const SizedBox(width: 8),
                        Expanded(child: _VisibilityOption(label: 'Private', selected: _visibility == _Visibility.private, onTap: () => setState(() => _visibility = _Visibility.private))),
                      ],
                    ),
                    const SizedBox(height: 28),

                    SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.navy,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                          elevation: 0,
                        ),
                        child: const Text('Submit memory', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatRange(DateTimeRange range) {
  String fmt(DateTime d) => '${d.month}/${d.day}/${d.year}';
  return '${fmt(range.start)} - ${fmt(range.end)}';
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 11.5, letterSpacing: 0.6, fontWeight: FontWeight.w700, color: AppColors.navyMuted.withOpacity(0.8)),
    );
  }
}

class _RatingRow extends StatelessWidget {
  const _RatingRow({required this.label, required this.value, required this.onChanged});

  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 13.5, color: AppColors.navy))),
          Row(
            children: List.generate(5, (i) {
              final filled = i < value;
              return GestureDetector(
                onTap: () => onChanged(i + 1),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1),
                  child: Icon(filled ? Icons.star : Icons.star_border, size: 20, color: AppColors.gold),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _MediaButton extends StatelessWidget {
  const _MediaButton({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(color: AppColors.creamDark, borderRadius: BorderRadius.circular(14)),
        child: Column(
          children: [
            Icon(icon, size: 22, color: AppColors.navy),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.navy)),
          ],
        ),
      ),
    );
  }
}

class _MediaPreviewRow extends StatelessWidget {
  const _MediaPreviewRow({
    required this.photos,
    required this.videos,
    required this.onRemovePhoto,
    required this.onRemoveVideo,
  });

  final List<File> photos;
  final List<File> videos;
  final ValueChanged<File> onRemovePhoto;
  final ValueChanged<File> onRemoveVideo;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 76,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (final photo in photos) _MediaThumb(child: Image.file(photo, fit: BoxFit.cover), onRemove: () => onRemovePhoto(photo)),
          for (final video in videos)
            _MediaThumb(
              child: Container(color: AppColors.navy, child: const Icon(Icons.play_circle_outline, color: Colors.white, size: 24)),
              onRemove: () => onRemoveVideo(video),
            ),
        ],
      ),
    );
  }
}

class _MediaThumb extends StatelessWidget {
  const _MediaThumb({required this.child, required this.onRemove});

  final Widget child;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(width: 68, height: 68, child: child),
          ),
          Positioned(
            top: 3,
            right: 3,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black.withOpacity(0.6)),
                child: const Icon(Icons.close, size: 12, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VisibilityOption extends StatelessWidget {
  const _VisibilityOption({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.navy : AppColors.creamDark,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: selected ? Colors.white : AppColors.navy),
        ),
      ),
    );
  }
}