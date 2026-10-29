import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/stay_listing.dart';
import '../../state/app_providers.dart';
import '../widgets/payment_modal.dart';
import '../widgets/scout_photo_dialog.dart';

class StayTabView extends ConsumerWidget {
  const StayTabView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listings = ref.watch(filteredStayListingsProvider);
    final filter = ref.watch(stayFilterProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Bar
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth > 920;
                      return isWide
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(child: _buildWorkplaceDropdown(ref, filter)),
                                const SizedBox(width: 12),
                                Expanded(child: _buildCommuteSlider(ref, filter)),
                                const SizedBox(width: 12),
                                Expanded(child: _buildDurationDropdown(ref, filter)),
                                const SizedBox(width: 12),
                                _buildSearchButton(context, filter),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildWorkplaceDropdown(ref, filter),
                                const SizedBox(height: 12),
                                _buildCommuteSlider(ref, filter),
                                const SizedBox(height: 12),
                                _buildDurationDropdown(ref, filter),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: _buildSearchButton(context, filter),
                                ),
                              ],
                            );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Results count
          Padding(
            padding: const EdgeInsets.only(bottom: 12, left: 4),
            child: Text(
              'Showing ${listings.length} verified listings within ${filter.maxCommuteMins} mins commute',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.slateMuted),
            ),
          ),

          // Listings Grid
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 900
                  ? 3
                  : (constraints.maxWidth > 580 ? 2 : 1);
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  mainAxisExtent: 310,
                ),
                itemCount: listings.length,
                itemBuilder: (context, index) {
                  final item = listings[index];
                  return _buildStayCard(context, item);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWorkplaceDropdown(WidgetRef ref, StayFilterState filter) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🏢 Workplace Location',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.slateMuted),
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          initialValue: filter.workplace,
          isExpanded: true,
          decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8)),
          style: const TextStyle(fontSize: 12, color: AppTheme.slateDark),
          items: AppConstants.workplaces.map((w) {
            return DropdownMenuItem(value: w, child: Text(w, overflow: TextOverflow.ellipsis));
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              ref.read(stayFilterProvider.notifier).state = filter.copyWith(workplace: val);
            }
          },
        ),
      ],
    );
  }

  Widget _buildCommuteSlider(WidgetRef ref, StayFilterState filter) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Flexible(
              child: Text(
                '⏱️ Max Commute:',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.slateMuted),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '${filter.maxCommuteMins} mins',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.primaryTeal),
            ),
          ],
        ),
        Slider(
          value: filter.maxCommuteMins.toDouble(),
          min: 5,
          max: 60,
          divisions: 11,
          activeColor: AppTheme.primaryTeal,
          onChanged: (val) {
            ref.read(stayFilterProvider.notifier).state = filter.copyWith(maxCommuteMins: val.round());
          },
        ),
      ],
    );
  }

  Widget _buildDurationDropdown(WidgetRef ref, StayFilterState filter) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '📅 Stay Duration',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.slateMuted),
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          initialValue: filter.durationCategory,
          isExpanded: true,
          decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8)),
          style: const TextStyle(fontSize: 12, color: AppTheme.slateDark),
          items: AppConstants.stayDurations.map((d) {
            return DropdownMenuItem(value: d, child: Text(d, overflow: TextOverflow.ellipsis));
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              ref.read(stayFilterProvider.notifier).state = filter.copyWith(durationCategory: val);
            }
          },
        ),
      ],
    );
  }

  Widget _buildSearchButton(BuildContext context, StayFilterState filter) {
    return ElevatedButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Filtered by ${filter.maxCommuteMins} mins commute to ${filter.workplace}'),
            backgroundColor: AppTheme.slateDark,
          ),
        );
      },
      child: const Text('Search Verified', style: TextStyle(fontSize: 12)),
    );
  }

  Widget _buildStayCard(BuildContext context, StayListing item) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTeal,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${item.commuteMins} mins to WTC',
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.darkTeal),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 14, color: AppTheme.amberAccent),
                        const SizedBox(width: 2),
                        Text(
                          item.rating.toString(),
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  item.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.slateDark),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  item.description,
                  style: const TextStyle(fontSize: 11, color: AppTheme.slateMuted),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      CurrencyFormatter.formatInt(item.price),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppTheme.primaryTeal),
                    ),
                    Text(
                      item.priceUnit,
                      style: const TextStyle(fontSize: 11, color: AppTheme.slateMuted),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    _buildPill('📷 ${item.ownerPhotosCount} Owner Photos', AppTheme.slateLightBg, AppTheme.slateDark),
                    _buildPill('✅ ${item.scoutPhotosCount} Scout Photos', AppTheme.emeraldLight, AppTheme.emeraldGreen),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                const Divider(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => ScoutPhotoDialog(listing: item),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          foregroundColor: AppTheme.emeraldGreen,
                          side: const BorderSide(color: AppTheme.emeraldBorder),
                        ),
                        child: const Text('📷 Scout (+50 Pts)', style: TextStyle(fontSize: 11)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => PaymentModal(
                              title: '${item.title} (Deposit)',
                              amount: item.depositAmount,
                              vendorId: item.vendorId,
                              serviceType: 'rent_deposit',
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          backgroundColor: AppTheme.primaryTeal,
                        ),
                        child: Text(
                          'Deposit (${CurrencyFormatter.formatInt(item.depositAmount)})',
                          style: const TextStyle(fontSize: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPill(String label, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: textColor),
      ),
    );
  }
}
