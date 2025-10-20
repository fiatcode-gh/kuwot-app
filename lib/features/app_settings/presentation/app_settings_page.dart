import 'package:auto_route/auto_route.dart';
import 'package:kuwot/core/presentation/bloc/config/theme_mode_cubit.dart';
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
    final themeSetting = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('App Theme'),
        DropdownButton<ThemeMode>(
          items: const [
            DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
            DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
            DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
          ],
          value: context.watch<ThemeModeCubit>().state,
          onChanged: (value) {
            context.read<ThemeModeCubit>().setThemeMode(value!);
          },
        ),
      ],
    );
    final appVersion = Center(
      child: FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(
              'v${snapshot.data!.version} (${snapshot.data!.buildNumber})',
            );
          }
          return const Text('...');
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('App Settings')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          themeSetting,
          const SizedBox(height: 20),
          appVersion,
          const SizedBox(height: 20),
          const AboutWidget(),
        ],
      ),
    );
  }
}
