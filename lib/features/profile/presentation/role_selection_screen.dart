import 'package:bringly_app/design_system/components/bringly_button.dart';
import 'package:bringly_app/design_system/layouts/foundation_scaffold.dart';
import 'package:bringly_app/design_system/tokens/bringly_spacing.dart';
import 'package:bringly_app/features/profile/application/profile_controller.dart';
import 'package:bringly_app/features/profile/domain/entities/marketplace_role.dart';
import 'package:flutter/cupertino.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({
    required this.controller,
    this.onSaved,
    super.key,
  });

  final ProfileController controller;
  final VoidCallback? onSaved;

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  MarketplaceRole _selectedRole = MarketplaceRole.shopper;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final state = widget.controller.state;

        return FoundationScaffold(
          title: 'Your role',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Choose your marketplace role',
                textAlign: TextAlign.center,
                style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
              ),
              const SizedBox(height: BringlySpacing.md),
              CupertinoSlidingSegmentedControl<MarketplaceRole>(
                groupValue: _selectedRole,
                children: const <MarketplaceRole, Widget>{
                  MarketplaceRole.shopper: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text('Shopper'),
                  ),
                  MarketplaceRole.traveler: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text('Traveler'),
                  ),
                  MarketplaceRole.both: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text('Both'),
                  ),
                },
                onValueChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _selectedRole = value;
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
                label: 'Save role',
                isLoading: state.isLoading,
                onPressed: state.isLoading ? null : _save,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _save() async {
    await widget.controller.updateRole(marketplaceRole: _selectedRole);
    if (!mounted) {
      return;
    }

    if (widget.controller.state.status == ProfileControllerStatus.updated) {
      widget.onSaved?.call();
    }
  }
}