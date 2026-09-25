import 'package:auto_route/auto_route.dart';
import 'package:kuwot/core/presentation/bloc/config/theme_mode_cubit.dart';
import 'package:kuwot/core/presentation/theme/app_fonts.dart';
import 'package:kuwot/core/presentation/theme/app_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuwot/features/app_settings/presentation/widgets/about_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';

@RoutePage()
class AppSettingsPage extends StatefulWidget {
  const AppSettingsPage({super.key});

  @override
  State<AppSettingsPage> createState() => _AppSettingsPageState();
}

class _AppSettingsPageState extends State<AppSettingsPage> {
  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final themeSetting = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Theme', style: AppFonts.body(size: 16, color: palette.ink)),
        const SizedBox(height: 8),
        SegmentedButton<ThemeMode>(
          showSelectedIcon: false,
          segments: const [
            ButtonSegment(value: ThemeMode.system, label: Text('System')),
            ButtonSegment(value: ThemeMode.light, label: Text('Light')),
            ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
          ],
          selected: {context.watch<ThemeModeCubit>().state},
          onSelectionChanged: (selection) {
            context.read<ThemeModeCubit>().setThemeMode(selection.first);
          },
        ),
      ],
    );
    final appVersion = Center(
      child: FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: (context, snapshot) {
          final label = snapshot.hasData
              ? 'v${snapshot.data!.version} (${snapshot.data!.buildNumber})'
              : '...';
          return Text(
            label,
            style: AppFonts.label(size: 12, color: palette.inkMuted),
          );
        },
      ),
    );

    return Scaffold(
      backgroundColor: palette.desk,
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            themeSetting,
            const SizedBox(height: 20),
            appVersion,
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: const AboutWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
