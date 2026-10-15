import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/paper.dart';
import '../../services/open_alex_service.dart';
import '../widgets/die_face_widget.dart';
import '../widgets/meta_badge_widget.dart';

class PaperViewerScreen extends StatefulWidget {
  const PaperViewerScreen({super.key});

  @override
  State<PaperViewerScreen> createState() => _PaperViewerScreenState();
}

class _PaperViewerScreenState extends State<PaperViewerScreen> {
  Paper? _currentPaper;
  bool _isLoading = true;
  String? _errorMessage;

  int _dieValue = 5;
  bool _isRolling = false;
  Timer? _rollTimer;

  @override
  void initState() {
    super.initState();
    _loadRandomPaper();
  }

  Future<void> _loadRandomPaper() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final paper = await OpenAlexService.fetchRandomPaper();
      if (mounted) {
        setState(() {
          _currentPaper = paper;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to fetch paper: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri? uri = Uri.tryParse(urlString);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Could not open link: $urlString',
              style: GoogleFonts.lora(color: const Color(0xFFF7F3E9)),
            ),
            backgroundColor: const Color(0xFF8B0000),
          ),
        );
      }
    }
  }

  void _onDicePressed() {
    if (_isRolling) return;

    setState(() {
      _isRolling = true;
    });

    _loadRandomPaper();

    int ticks = 0;
    final random = Random();
    _rollTimer?.cancel();
    _rollTimer = Timer.periodic(const Duration(milliseconds: 70), (timer) {
      ticks++;
      if (mounted) {
        setState(() {
          _dieValue = random.nextInt(6) + 1;
        });
      }
      if (ticks >= 9) {
        timer.cancel();
        if (mounted) {
          setState(() {
            _isRolling = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _rollTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2ECE1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C221E),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'THE GAZETTE',
          style: GoogleFonts.libreBaskerville(
            color: const Color(0xFFE8DFD1),
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 16.0,
                  bottom: 24.0,
                ),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAF6EE),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: const Color(0xFF3E312B).withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2C221E).withValues(alpha: 0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20.0),
                  child: _buildPaperContent(),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 1.0, bottom: 12.0),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 64,
                      height: 64,
                      child: ElevatedButton(
                        onPressed: _onDicePressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          elevation: 4,
                          shadowColor: Colors.black38,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            side: const BorderSide(
                              color: Colors.black,
                              width: 2.0,
                            ),
                          ),
                        ),
                        child: DieFaceWidget(
                          value: _dieValue,
                          size: 34.0,
                          dotColor: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Roll for Random Paper',
                      style: GoogleFonts.lora(
                        fontSize: 11,
                        color: const Color(0xFF5A493E),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaperContent() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              color: Color(0xFF3E312B),
              strokeWidth: 3,
            ),
            const SizedBox(height: 16),
            Text(
              'Consulting OpenAlex Archives...',
              style: GoogleFonts.lora(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: const Color(0xFF5A493E),
              ),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Color(0xFF8B0000), size: 40),
            const SizedBox(height: 12),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: GoogleFonts.lora(
                fontSize: 13,
                color: const Color(0xFF2C221E),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadRandomPaper,
              icon: const Icon(Icons.refresh, size: 18),
              label: Text('Retry', style: GoogleFonts.libreBaskerville(fontSize: 12)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2C221E),
                foregroundColor: const Color(0xFFF7F3E9),
              ),
            ),
          ],
        ),
      );
    }

    final paper = _currentPaper;
    if (paper == null) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            paper.title,
            style: GoogleFonts.libreBaskerville(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1C1410),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 2.0),
                child: Icon(
                  Icons.history_edu,
                  size: 16,
                  color: Color(0xFF6B584C),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  paper.authors,
                  style: GoogleFonts.lora(
                    fontSize: 13.5,
                    fontStyle: FontStyle.italic,
                    color: const Color(0xFF4A3C34),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFFD3C6B4), thickness: 1),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              MetaBadgeWidget(
                icon: Icons.menu_book,
                label: paper.venue,
              ),
              MetaBadgeWidget(
                icon: Icons.calendar_today,
                label: paper.releaseDate,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'ABSTRACT',
            style: GoogleFonts.libreBaskerville(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: const Color(0xFF2C221E),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14.0),
            decoration: BoxDecoration(
              color: const Color(0xFFF2ECE1).withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: const Color(0xFFD3C6B4),
                width: 1,
              ),
            ),
            child: Text(
              paper.abstractText,
              textAlign: TextAlign.justify,
              style: GoogleFonts.lora(
                fontSize: 14,
                color: const Color(0xFF2C221E),
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: () => _launchUrl(paper.launchableUrl),
            borderRadius: BorderRadius.circular(6),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0x00EADBCE),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: const Color(0xFFD3C6B4),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.link,
                    size: 18,
                    color: Color(0xFF6B584C),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'DOI: ',
                    style: GoogleFonts.libreBaskerville(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2C221E),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      paper.doi,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lora(
                        fontSize: 12.5,
                        color: const Color(0xFF2C221E),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.open_in_new,
                    size: 14,
                    color: Color(0xFF6B584C),
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
