import 'package:flutter/material.dart';
import '../models/game.dart';
import '../models/game_detail.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class DetailPage extends StatefulWidget {
  final Game game;

  const DetailPage({super.key, required this.game});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final ApiService _apiService = ApiService();
  GameDetail? _gameDetail;
  bool _isLoading = true;
  bool _isOwned = false;

  @override
  void initState() {
    super.initState();
    _checkOwnership();
    _loadDetail();
  }

  void _checkOwnership() {
    setState(() {
      _isOwned = StorageService.isInLibrary(widget.game.id);
    });
  }

  Future<void> _loadDetail() async {
    try {
      final detail = await _apiService.fetchGameDetail(widget.game.id);
      if (mounted) {
        setState(() {
          _gameDetail = detail;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _toggleGetGame() async {
    if (_isOwned) {
      return;
    }

    await StorageService.addToLibrary(widget.game);
    _checkOwnership();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.game.title} telah ditambahkan ke Library!'),
          backgroundColor: Colors.green[700],
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: 'game_hero_${widget.game.id}',
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  widget.game.thumbnail,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[900],
                      child: const Icon(
                        Icons.sports_esports,
                        size: 64,
                        color: Colors.white24,
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildPill(widget.game.genre, theme.primaryColor),
                      const SizedBox(width: 8),
                      _buildPill(
                        widget.game.platform,
                        theme.colorScheme.secondary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.game.title,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildMetadataRow(
                    Icons.calendar_today_outlined,
                    'Tanggal Rilis',
                    widget.game.releaseDate,
                  ),
                  const SizedBox(height: 10),
                  _buildMetadataRow(
                    Icons.business_outlined,
                    'Publisher',
                    widget.game.publisher,
                  ),
                  const SizedBox(height: 10),
                  _buildMetadataRow(
                    Icons.code_outlined,
                    'Developer',
                    widget.game.developer,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isOwned ? null : _toggleGetGame,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isOwned
                          ? Colors.grey[800]
                          : theme.primaryColor,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey[800],
                      disabledForegroundColor: Colors.white70,
                      side: _isOwned
                          ? const BorderSide(color: Colors.white24)
                          : BorderSide.none,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _isOwned ? Icons.check_circle : Icons.add_circle_outline,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(_isOwned ? 'In Library' : 'Get Game'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  if (_isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else ...[
                    if (_gameDetail != null &&
                        _gameDetail!.screenshots.isNotEmpty) ...[
                      const Text(
                        'Screenshots',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 130,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _gameDetail!.screenshots.length,
                          itemBuilder: (context, index) {
                            final screenshot =
                                _gameDetail!.screenshots[index];
                            return Container(
                              margin: const EdgeInsets.only(right: 12.0),
                              width: 200,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  screenshot.image,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[850],
                                      child: const Icon(
                                        Icons.image_not_supported_outlined,
                                        color: Colors.white24,
                                      ),
                                    );
                                  },
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      color: Colors.grey[850],
                                      child: const Center(
                                        child: SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 28),
                    ],
                    const Text(
                      'Overview',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _gameDetail != null &&
                              _gameDetail!.description.trim().isNotEmpty
                          ? _gameDetail!.description
                          : widget.game.shortDescription,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[300],
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPill(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildMetadataRow(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF171923),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF2D3748), width: 0.5),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 12),
          Text(
            '$label:',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
