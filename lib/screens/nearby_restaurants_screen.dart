import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/ads.dart';
import '../constants/nearby_constants.dart';
import '../constants/app_messages.dart';
import '../controllers/nearby_restaurants_controller.dart';
import '../widgets/banner_ad_area.dart';
import '../widgets/state_widgets.dart';

class NearbyRestaurantsScreen extends StatefulWidget {
  const NearbyRestaurantsScreen({super.key, required this.categoryLabel});

  final String categoryLabel;

  @override
  State<NearbyRestaurantsScreen> createState() =>
      _NearbyRestaurantsScreenState();
}

class _NearbyRestaurantsScreenState extends State<NearbyRestaurantsScreen> {
  static const int _pageSize = 15;
  static const AdSize _bannerSize = AdSize.banner;
  final ScrollController _scrollController = ScrollController();
  late final NearbyRestaurantsController _controller;
  BannerAd? _bannerAd;
  bool _isBannerLoaded = false;

  @override
  void initState() {
    super.initState();
    _controller = NearbyRestaurantsController(
      categoryLabel: widget.categoryLabel,
      pageSize: _pageSize,
    )..addListener(_onControllerChanged);
    _scrollController.addListener(_onScroll);
    _loadBannerAd();
    _controller.loadInitial();
  }

  @override
  void didUpdateWidget(covariant NearbyRestaurantsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.categoryLabel != widget.categoryLabel) {
      _controller.updateCategoryLabel(widget.categoryLabel);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    _bannerAd?.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  void _onScroll() {
    if (!_scrollController.hasClients ||
        _controller.paging.isLoadingMore ||
        _controller.paging.isEnd) {
      return;
    }
    final threshold = _scrollController.position.maxScrollExtent - 200;
    if (_scrollController.position.pixels >= threshold) {
      _controller.loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.categoryLabel)),
      body: Column(
        children: [
          Expanded(child: _buildBody()),
          BannerAdArea(
            size: _bannerSize,
            isLoaded: _isBannerLoaded,
            bannerAd: _bannerAd,
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_controller.paging.isInitialLoading) {
      return const CenteredLoading();
    }
    if (_controller.paging.initialLoadError != null) {
      return CenteredMessage(message: _controller.paging.initialLoadError!);
    }
    if (_controller.places.isEmpty) {
      return const CenteredMessage(message: AppMessages.noPlacesFound);
    }

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverToBoxAdapter(child: _buildSortSelector()),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final place = _controller.places[index];
              final distanceLabel = place.distance != null
                  ? '${place.distance}m'
                  : AppMessages.distanceUnavailable;
              return Column(
                children: [
                  ListTile(
                    title: Text(place.placeName),
                    subtitle: Text(place.addressName),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          distanceLabel,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(width: 8),
                        _buildMapShortcut(place.placeUrl),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                ],
              );
            },
            childCount: _controller.places.length,
          ),
        ),
        SliverToBoxAdapter(child: _buildFooter()),
      ],
    );
  }

  void _onSortSelected(NearbySort sort) {
    _controller.updateSort(sort);
  }

  void _loadBannerAd() {
    final bannerAd = BannerAd(
      adUnitId: AdmobConfig.bannerAdUnitId,
      request: const AdRequest(),
      size: _bannerSize,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            _bannerAd = ad as BannerAd;
            _isBannerLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          if (!mounted) {
            return;
          }
          setState(() {
            _bannerAd = null;
            _isBannerLoaded = false;
          });
        },
      ),
    );
    _bannerAd = bannerAd;
    bannerAd.load();
  }

  Widget _buildSortSelector() {
    const sortOptions = [
      NearbySort.distance,
      NearbySort.accuracy,
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: SegmentedButton<NearbySort>(
        segments: sortOptions
            .map(
              (sort) => ButtonSegment<NearbySort>(
                value: sort,
                label: Text(sort.label),
              ),
            )
            .toList(),
        selected: {_controller.currentSort},
        onSelectionChanged: (selection) {
          if (selection.isEmpty) {
            return;
          }
          _onSortSelected(selection.first);
        },
      ),
    );
  }

  Future<void> _launchPlaceUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(NearbyLabels.mapInvalidUrl)),
      );
      return;
    }
    final canLaunch = await canLaunchUrl(uri);
    if (!canLaunch) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(NearbyLabels.mapLaunchFailed)),
      );
      return;
    }
    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(NearbyLabels.mapLaunchFailed)),
      );
    }
  }

  Widget _buildMapShortcut(String placeUrl) {
    final trimmedUrl = placeUrl.trim();
    final isEnabled = trimmedUrl.isNotEmpty;
    final iconColor =
        isEnabled ? Theme.of(context).colorScheme.primary : null;
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? () => _launchPlaceUrl(trimmedUrl) : null,
          borderRadius: BorderRadius.circular(6),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Icon(
              Icons.map_outlined,
              size: 20,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    if (_controller.paging.isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: CenteredLoading(),
      );
    }
    if (_controller.paging.loadMoreError != null) {
      return RetryMessage(
        message: _controller.paging.loadMoreError!,
        onRetry: _controller.loadNextPage,
      );
    }
    if (_controller.paging.isEnd) {
      return const SizedBox.shrink();
    }
    return const SizedBox(height: 32);
  }
}
