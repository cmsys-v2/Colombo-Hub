import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../models/accommodation_model.dart';
import '../../../state/app_providers.dart';
import '../../../views/widgets/payment_modal.dart';
import '../../../views/widgets/scout_photo_dialog.dart';

/// ColomboHub Stay & Interactive Map Screen
/// Displays verified boarding annexes, student pod rooms, and executive stays
/// with Google Maps geolocations, Form-C badges, and CEB separate meter flags.
class StayMapScreen extends ConsumerStatefulWidget {
  const StayMapScreen({super.key});

  @override
  ConsumerState<StayMapScreen> createState() => _StayMapScreenState();
}

class _StayMapScreenState extends ConsumerState<StayMapScreen> {
  bool _isMapView = false;
  GoogleMapController? _mapController;
  StayListing? _selectedListing;

  // Center on Colombo Town Hall / Fort
  static const CameraPosition _initialCamera = CameraPosition(
    target: LatLng(6.9271, 79.8612),
    zoom: 12.0,
  );

  void _selectListing(StayListing stay) {
    setState(() => _selectedListing = stay);
    _mapController?.animateCamera(
      CameraUpdate.newLatLng(LatLng(stay.latitude, stay.longitude)),
    );
  }

  Set<Marker> _buildMarkers(List<StayListing> listings) {
    return listings.map((stay) {
      return Marker(
        markerId: MarkerId(stay.id),
        position: LatLng(stay.latitude, stay.longitude),
        infoWindow: InfoWindow(
          title: stay.title,
          snippet: '${CurrencyFormatter.formatLkr(stay.price)} ${stay.priceUnit} • Form-C Ready',
          onTap: () => _selectListing(stay),
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          stay.durationCategory.contains('Pod')
              ? BitmapDescriptor.hueAzure
              : BitmapDescriptor.hueCyan,
        ),
        onTap: () => _selectListing(stay),
      );
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    final listings = ref.watch(filteredStayListingsProvider);
    final filter = ref.watch(stayFilterProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Bar & Map Toggle Header
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

          // View Switcher (Map vs Grid List) & Counts
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    'Showing ${listings.length} verified listings within ${filter.maxCommuteMins} mins commute',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.slateMuted,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.slateBorder),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => setState(() => _isMapView = false),
                      borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: !_isMapView ? AppTheme.primaryTeal : Colors.transparent,
                          borderRadius: const BorderRadius.horizontal(left: Radius.circular(7)),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              LucideIcons.layoutGrid,
                              size: 14,
                              color: !_isMapView ? Colors.white : AppTheme.slateMuted,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Cards',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: !_isMapView ? Colors.white : AppTheme.slateMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => setState(() => _isMapView = true),
                      borderRadius: const BorderRadius.horizontal(right: Radius.circular(8)),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: _isMapView ? AppTheme.primaryTeal : Colors.transparent,
                          borderRadius: const BorderRadius.horizontal(right: Radius.circular(7)),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              LucideIcons.mapPin,
                              size: 14,
                              color: _isMapView ? Colors.white : AppTheme.slateMuted,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Map',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: _isMapView ? Colors.white : AppTheme.slateMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Content Area (Interactive Map or Cards Grid)
          if (_isMapView)
            _buildInteractiveMapSection(listings)
          else
            _buildListingsGrid(listings),
        ],
      ),
    );
  }

  Widget _buildInteractiveMapSection(List<StayListing> listings) {
    return Column(
      children: [
        Container(
          height: 380,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.slateBorder),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: _initialCamera,
                onMapCreated: (ctrl) => _mapController = ctrl,
                markers: _buildMarkers(listings),
                myLocationButtonEnabled: false,
                zoomControlsEnabled: true,
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.slateBorder),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(LucideIcons.mapPin, size: 14, color: AppTheme.primaryTeal),
                      SizedBox(width: 6),
                      Text(
                        'Tap any pin to view Form-C details & rent',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.slateDark),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_selectedListing != null) ...[
          const SizedBox(height: 12),
          _buildStayCard(context, _selectedListing!),
        ],
      ],
    );
  }

  Widget _buildListingsGrid(List<StayListing> listings) {
    return LayoutBuilder(
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
    );
  }

  Widget _buildWorkplaceDropdown(WidgetRef ref, StayFilterState filter) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Target Workplace Zone',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.slateDark),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: filter.workplace,
          decoration: const InputDecoration(isDense: true),
          items: AppConstants.workplaces.map((w) {
            return DropdownMenuItem(
              value: w,
              child: Text(w, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis),
            );
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
                'Max Commute Time',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.slateDark),
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
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppTheme.primaryTeal,
            thumbColor: AppTheme.darkTeal,
            trackHeight: 3,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
          ),
          child: Slider(
            value: filter.maxCommuteMins.toDouble(),
            min: 5,
            max: 45,
            divisions: 8,
            onChanged: (val) {
              ref.read(stayFilterProvider.notifier).state = filter.copyWith(maxCommuteMins: val.round());
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDurationDropdown(WidgetRef ref, StayFilterState filter) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Boarding Category',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.slateDark),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: filter.durationCategory,
          decoration: const InputDecoration(isDense: true),
          items: ['All Types', ...AppConstants.stayDurations].map((d) {
            return DropdownMenuItem(
              value: d,
              child: Text(d, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis),
            );
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
            content: Text('Filtered by ${filter.workplace} (≤ ${filter.maxCommuteMins}m)'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: const Text('Filter'),
    );
  }

  Widget _buildStayCard(BuildContext context, StayListing item) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Badges Row
          Container(
            padding: const EdgeInsets.all(12),
            color: AppTheme.slateLightBg,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppTheme.emeraldLight,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppTheme.emeraldBorder),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(LucideIcons.shieldCheck, size: 12, color: AppTheme.emeraldGreen),
                      SizedBox(width: 4),
                      Text(
                        'Form-C Ready',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.emeraldGreen,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTeal,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppTheme.tealBorder),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(LucideIcons.camera, size: 12, color: AppTheme.darkTeal),
                      const SizedBox(width: 4),
                      Text(
                        '${item.scoutPhotosCount} Scout Photos',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkTeal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Card Details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppTheme.slateDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(LucideIcons.mapPin, size: 12, color: AppTheme.slateMuted),
                      const SizedBox(width: 4),
                      Text(
                        '${item.neighborhood} • ${item.commuteMins}m to ${item.workplace.split(' ').first}',
                        style: const TextStyle(fontSize: 11, color: AppTheme.slateMuted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11, color: AppTheme.slateDark),
                  ),
                  const Spacer(),
                  // Price and Deposit Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                CurrencyFormatter.formatLkr(item.price),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                  color: AppTheme.darkTeal,
                                ),
                              ),
                              Text(
                                item.priceUnit,
                                style: const TextStyle(fontSize: 11, color: AppTheme.slateMuted),
                              ),
                            ],
                          ),
                          Text(
                            'Deposit: ${CurrencyFormatter.formatLkr(item.depositAmount)}',
                            style: const TextStyle(fontSize: 10, color: AppTheme.slateMuted),
                          ),
                        ],
                      ),
                      // Action buttons
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(LucideIcons.camera, size: 16, color: AppTheme.primaryTeal),
                            tooltip: 'Add Scout Photos (+50 pts)',
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => ScoutPhotoDialog(listing: item),
                              );
                            },
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              minimumSize: const Size(60, 32),
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => PaymentModal(
                                  title: 'Escrow Booking: ${item.title}',
                                  amount: item.depositAmount,
                                  vendorId: item.vendorId,
                                ),
                              );
                            },
                            child: const Text('Book', style: TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
