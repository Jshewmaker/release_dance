import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// {@template release_card}
/// A card used to display a release class.
///
/// This card displays the title, time, instructor, and location
/// of a release class.
///
/// {@endtemplate}
class ReleaseClassCard extends StatelessWidget {
  /// {@macro release_card}
  const ReleaseClassCard({
    required this.title,
    required this.subtitle,
    required this.location,
    required this.id,
    required this.active,
    required this.background,
    this.onTap,
    super.key,
  });

  /// The id of the class.
  final String id;

  /// The title of the class.
  final String title;

  /// The time of the class.
  final String subtitle;

  /// The location of the class.
  final String location;

  /// Whether the class is active.
  final bool active;

  /// The callback when the card is tapped.
  final VoidCallback? onTap;

  /// The background image of the card.
  final String background;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: AssetImage(background),
              fit: BoxFit.fill,
              colorFilter: ColorFilter.mode(
                AppColors.black.withOpacity(active ? 0.3 : 0.8),
                BlendMode.darken,
              ),
            ),
          ),
          height: 200,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.displayMedium,
                    ),
                    if (subtitle.isEmpty)
                      const SizedBox()
                    else
                      Text(
                        subtitle,
                      ),
                    Text(
                      location,
                      style: theme.textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
