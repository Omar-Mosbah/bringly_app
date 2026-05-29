import 'package:bringly_app/design_system/components/bringly_button.dart';
import 'package:bringly_app/design_system/layouts/foundation_scaffold.dart';
import 'package:bringly_app/design_system/tokens/bringly_spacing.dart';
import 'package:bringly_app/features/profile/application/profile_controller.dart';
import 'package:bringly_app/features/profile/domain/value_objects/country_city.dart';
import 'package:bringly_app/features/profile/domain/value_objects/display_name.dart';
import 'package:bringly_app/features/profile/domain/value_objects/preferred_language.dart';
import 'package:flutter/cupertino.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({
    required this.controller,
    this.onSaved,
    super.key,
  });

  final ProfileController controller;
  final VoidCallback? onSaved;

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late final TextEditingController _displayNameController;
  late final TextEditingController _avatarReferenceController;
  late final TextEditingController _countryController;
  late final TextEditingController _cityController;

  String? _displayNameError;
  String? _countryCityError;
  String _languageCode = 'en';

  @override
  void initState() {
    super.initState();
    final profile = widget.controller.state.profile;
    _displayNameController = TextEditingController(
      text: profile?.displayName.value ?? '',
    );
    _avatarReferenceController = TextEditingController(
      text: profile?.avatarReference ?? '',
    );
    _countryController = TextEditingController(
      text: profile?.countryCity.country ?? '',
    );
    _cityController = TextEditingController(text: profile?.countryCity.city ?? '');
    _languageCode = profile?.preferredLanguage.value ?? 'en';
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _avatarReferenceController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final state = widget.controller.state;

        return FoundationScaffold(
          title: 'Edit profile',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              CupertinoTextField(
                key: const ValueKey<String>('profile_display_name_field'),
                controller: _displayNameController,
                placeholder: 'Display name',
                padding: const EdgeInsets.all(14),
              ),
              if (_displayNameError != null) ...<Widget>[
                const SizedBox(height: BringlySpacing.xs),
                Text(
                  _displayNameError!,
                  style: const TextStyle(color: CupertinoColors.systemRed),
                ),
              ],
              const SizedBox(height: BringlySpacing.md),
              CupertinoTextField(
                key: const ValueKey<String>('profile_avatar_reference_field'),
                controller: _avatarReferenceController,
                placeholder: 'Avatar reference',
                padding: const EdgeInsets.all(14),
              ),
              const SizedBox(height: BringlySpacing.md),
              CupertinoTextField(
                key: const ValueKey<String>('profile_country_field'),
                controller: _countryController,
                placeholder: 'Country',
                padding: const EdgeInsets.all(14),
              ),
              const SizedBox(height: BringlySpacing.sm),
              CupertinoTextField(
                key: const ValueKey<String>('profile_city_field'),
                controller: _cityController,
                placeholder: 'City',
                padding: const EdgeInsets.all(14),
              ),
              if (_countryCityError != null) ...<Widget>[
                const SizedBox(height: BringlySpacing.xs),
                Text(
                  _countryCityError!,
                  style: const TextStyle(color: CupertinoColors.systemRed),
                ),
              ],
              const SizedBox(height: BringlySpacing.md),
              CupertinoSlidingSegmentedControl<String>(
                groupValue: _languageCode,
                children: const <String, Widget>{
                  'en': Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text('English'),
                  ),
                  'es': Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text('Spanish'),
                  ),
                  'fr': Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text('French'),
                  ),
                },
                onValueChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _languageCode = value;
                  });
                },
              ),
              const SizedBox(height: BringlySpacing.md),
              if (state.failure != null) ...<Widget>[
                Text(
                  state.failure!.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: CupertinoColors.systemRed),
                ),
                const SizedBox(height: BringlySpacing.sm),
              ],
              BringlyButton(
                label: 'Save profile',
                isLoading: state.isLoading,
                onPressed: state.isLoading ? null : _submit,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _submit() async {
    final displayName = DisplayName(_displayNameController.text);
    final countryCity = CountryCity(
      country: _countryController.text,
      city: _cityController.text,
    );
    final language = PreferredLanguage(_languageCode);

    setState(() {
      _displayNameError = displayName.validationMessage;
      _countryCityError = countryCity.validationMessage;
    });

    if (!displayName.isValid || !countryCity.isValid || !language.isValid) {
      return;
    }

    await widget.controller.updateProfile(
      displayName: _displayNameController.text,
      avatarReference: _avatarReferenceController.text,
      country: _countryController.text,
      city: _cityController.text,
      preferredLanguageCode: _languageCode,
    );

    if (!mounted) {
      return;
    }

    if (widget.controller.state.status == ProfileControllerStatus.updated) {
      widget.onSaved?.call();
    }
  }
}