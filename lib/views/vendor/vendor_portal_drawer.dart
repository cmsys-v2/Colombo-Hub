import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/stay_listing.dart';
import '../../state/app_providers.dart';

class VendorPortalDrawer extends ConsumerStatefulWidget {
  const VendorPortalDrawer({super.key});

  @override
  ConsumerState<VendorPortalDrawer> createState() => _VendorPortalDrawerState();
}

class _VendorPortalDrawerState extends ConsumerState<VendorPortalDrawer> {
  String _selectedCategory = 'Annex / Boarding Room';
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _publishListing() {
    final title = _titleController.text.trim();
    final price = double.tryParse(_priceController.text.trim()) ?? 0;
    if (title.isEmpty || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter listing title and valid price')),
      );
      return;
    }

    // Add to stay listings if category is Annex
    if (_selectedCategory == 'Annex / Boarding Room') {
      final newListing = StayListing(
        id: 'stay-vendor-${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        neighborhood: 'Colombo Metro',
        workplace: 'World Trade Center (Fort)',
        commuteMins: 20,
        price: price,
        durationCategory: 'Monthly Boarding / Annex',
        description: 'New partner listing • Police Form-C verification in progress',
        ownerPhotosCount: 3,
        scoutPhotosCount: 0,
        rating: 5.0,
        depositAmount: price * 0.5,
        features: ['Verified Partner Listing', 'Form-C Ready'],
        latitude: 6.9271,
        longitude: 79.8612,
        vendorId: 'V-771',
      );
      ref.read(stayListingsProvider.notifier).addListing(newListing);
    }

    _titleController.clear();
    _priceController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Service listed! Verification pending on Form-C ✅'),
        backgroundColor: AppTheme.amberAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProfileProvider);
    final dispatches = ref.watch(dispatchesProvider);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.amberLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.amberBorder, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(LucideIcons.building2, size: 18, color: AppTheme.amberAccent),
                        SizedBox(width: 8),
                        Text(
                          'Unified Partner Portal & Ledger',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF78350F)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${user.partnerName} • Partner ID: ${user.partnerId}',
                      style: const TextStyle(fontSize: 11, color: Color(0xFF92400E)),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.emeraldLight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.emeraldBorder),
                ),
                child: const Row(
                  children: [
                    Icon(LucideIcons.shieldCheck, size: 14, color: AppTheme.emeraldGreen),
                    SizedBox(width: 4),
                    Text(
                      'KYC & Police Verified',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.emeraldGreen),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 1. Partner Wallet & Ledger Summary Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF134E4A),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '💰 Partner Wallet & Payout Ledger',
                        style: TextStyle(fontSize: 11, color: Color(0xFF99F6E4), fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        CurrencyFormatter.format(user.partnerWallet),
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Commercial Bank (A/C: 1002384920) • Platform Commission: 5%–8%',
                        style: TextStyle(fontSize: 10, color: Color(0xFFCCFBF1)),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    ref.read(userProfileProvider.notifier).withdrawWallet();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Payout request of ${CurrencyFormatter.format(user.partnerWallet)} sent to Commercial Bank (A/C: 1002384920)!',
                        ),
                        backgroundColor: AppTheme.slateDark,
                      ),
                    );
                  },
                  icon: const Icon(LucideIcons.landmark, size: 14),
                  label: const Text('Withdraw to Bank', style: TextStyle(fontSize: 11)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryTeal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 2. Active Dispatches & Service Requests
          if (dispatches.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.slateBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '📋 Active Dispatches & Service Requests (${dispatches.length})',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTeal,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          dispatches.first.locationTag,
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.primaryTeal),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    dispatches.first.description,
                    style: const TextStyle(fontSize: 11, color: AppTheme.slateMuted),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            ref.read(dispatchesProvider.notifier).removeDispatch(dispatches.first.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Dispatch passed to neighboring partner')),
                            );
                          },
                          child: const Text('Pass to Next', style: TextStyle(fontSize: 11)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            final payout = dispatches.first.payoutAmount;
                            ref.read(dispatchesProvider.notifier).removeDispatch(dispatches.first.id);
                            ref.read(userProfileProvider.notifier).creditPartnerWallet(payout);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Dispatch Accepted & Completed! +${CurrencyFormatter.format(payout)} added to Partner Wallet 🎉'),
                                backgroundColor: AppTheme.emeraldGreen,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.emeraldGreen),
                          child: Text(
                            'Accept & Run (+${CurrencyFormatter.formatInt(dispatches.first.payoutAmount)})',
                            style: const TextStyle(fontSize: 11),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
          ],

          // 3. Vendor Service Listing Controller
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.slateBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '➕ List New Service or Bus Seat',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    SizedBox(
                      width: 190,
                      child: DropdownButtonFormField<String>(
                        initialValue: _selectedCategory,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        ),
                        style: const TextStyle(fontSize: 11, color: AppTheme.slateDark),
                        items: const [
                          DropdownMenuItem(value: 'Annex / Boarding Room', child: Text('Annex / Boarding Room')),
                          DropdownMenuItem(value: 'Express Staff Shuttle Route', child: Text('Express Staff Shuttle Route')),
                          DropdownMenuItem(value: 'Tiffin Lunch Box Service', child: Text('Tiffin Lunch Box Service')),
                          DropdownMenuItem(value: 'Household Handyman (Plumber/AC)', child: Text('Household Handyman')),
                          DropdownMenuItem(value: '20L Water / Gas Delivery', child: Text('20L Water / Gas Delivery')),
                        ],
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedCategory = val);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 170,
                      child: TextField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          hintText: 'Title (e.g. Malabe Studio)',
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        ),
                        style: const TextStyle(fontSize: 11),
                      ),
                    ),
                    SizedBox(
                      width: 110,
                      child: TextField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Price (LKR)',
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        ),
                        style: const TextStyle(fontSize: 11),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _publishListing,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.amberAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      ),
                      child: const Text('+ Publish Listing', style: TextStyle(fontSize: 11)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
