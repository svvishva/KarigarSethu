import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';
import 'package:google_mlkit_subject_segmentation/google_mlkit_subject_segmentation.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:image/image.dart' as img;
import 'image_editor_screen.dart';
import '../services/groq_service.dart';
import 'package:permission_handler/permission_handler.dart';
import '../core/theme.dart';
import '../widgets/glass_container.dart';
import '../offline_pricing_model.dart';
import '../services/gemini_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karigarsethu/l10n/app_localizations.dart';
import 'dart:math' as math;

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _nameController = TextEditingController();
  final _spokenDescController = TextEditingController();
  final _englishDescController = TextEditingController();
  final _hindiDescController = TextEditingController();
  final _priceController = TextEditingController();
  
  // AI Pricing State
  double? _recommendedPrice;
  double? _competitivePrice;
  final _rawMaterialCostController = TextEditingController();
  final _labourCostController = TextEditingController();
  final _packagingCostController = TextEditingController();
  final _otherCostController = TextEditingController();
  final _marketAveragePriceController = TextEditingController();

  String _mlCategory = 'Handicraft';
  String _mlMaterial = 'Cotton';
  String _mlSize = 'Medium';
  String _mlDesignComplexity = 'Medium';
  String _mlDemandLevel = 'Medium';
  String _mlSeason = 'Regular';

  // Dynamic Fields State
  final Map<String, TextEditingController> _dynamicControllers = {};
  final Map<String, bool> _dynamicSwitches = {};
  final Map<String, String?> _dynamicDropdowns = {};
  final Map<String, List<String>> _dynamicMultiSelects = {};
  
  String? _selectedCategory;
  final List<String> _productCategories = [
    'Handloom Sarees',
    'Ethnic Wear & Dresses',
    'Handwoven Textiles',
    'Wooden Handicrafts',
    'Brass & Bronze Metalware',
    'Terracotta & Pottery',
    'Leather Crafts',
    'Footwear',
    'Handmade Jewelry',
    'Traditional Paintings',
    'Bamboo & Cane Products',
    'Home Decor',
    'Other',
  ];

  File? _imageFile;
  File? _originalImageFile;
  final ImagePicker _picker = ImagePicker();
  
  final _audioRecorder = AudioRecorder();
  bool _isListening = false;
  bool _isTranslating = false;
  bool _isCalculatingPrice = false;
  bool _isRemovingBg = false;
  bool _isEnhancing = false;

  static const Map<String, List<Map<String, dynamic>>> _categoryFields = {
    'Handloom Sarees': [
      {'key': 'fabric', 'label': 'Fabric (e.g. Pure Silk, Cotton)', 'icon': Icons.checkroom},
      {'key': 'length', 'label': 'Length (e.g. 5.5 meters)', 'icon': Icons.straighten},
      {'key': 'work', 'label': 'Work / Pattern (e.g. Zari, Ikat)', 'icon': Icons.brush},
      {'key': 'blouse', 'label': 'Includes Blouse Piece', 'type': 'switch'},
    ],
    'Ethnic Wear & Dresses': [
      {'key': 'type', 'label': 'Garment Type (Kurta, Lehenga)', 'icon': Icons.checkroom},
      {'key': 'fabric', 'label': 'Fabric', 'icon': Icons.texture},
      {'key': 'size', 'label': 'Available Sizes', 'type': 'multiselect', 'options': ['S', 'M', 'L', 'XL', 'XXL', 'Custom']},
      {'key': 'work', 'label': 'Work / Embroidery', 'icon': Icons.brush},
    ],
    'Handwoven Textiles': [
      {'key': 'material', 'label': 'Material (Cotton, Silk, Linen)', 'icon': Icons.texture},
      {'key': 'dimensions', 'label': 'Dimensions (Width & Length)', 'icon': Icons.straighten},
      {'key': 'weave', 'label': 'Weave Type', 'icon': Icons.grid_on},
      {'key': 'dye', 'label': 'Dye Type (Natural, Synthetic)', 'icon': Icons.format_paint},
    ],
    'Wooden Handicrafts': [
      {'key': 'wood', 'label': 'Wood Type (Teak, Sandalwood)', 'icon': Icons.forest},
      {'key': 'dimensions', 'label': 'Dimensions (L x W x H)', 'icon': Icons.straighten},
      {'key': 'finish', 'label': 'Finish / Polish Type', 'icon': Icons.format_paint},
      {'key': 'technique', 'label': 'Technique (Carving, Inlay)', 'icon': Icons.handyman},
    ],
    'Brass & Bronze Metalware': [
      {'key': 'metal', 'label': 'Base Metal (Brass, Bronze)', 'icon': Icons.hardware},
      {'key': 'weight', 'label': 'Weight (Grams / Kg)', 'icon': Icons.scale},
      {'key': 'use', 'label': 'Use (Decorative, Pooja)', 'icon': Icons.home},
      {'key': 'finish', 'label': 'Finish (Antique, Polished)', 'icon': Icons.format_paint},
    ],
    'Terracotta & Pottery': [
      {'key': 'clay', 'label': 'Clay Type / Region', 'icon': Icons.landscape},
      {'key': 'capacity', 'label': 'Dimensions / Capacity', 'icon': Icons.straighten},
      {'key': 'glazed', 'label': 'Glazed', 'type': 'switch'},
      {'key': 'foodSafe', 'label': 'Safe for Serving Food', 'type': 'switch'},
    ],
    'Leather Crafts': [
      {'key': 'leather', 'label': 'Leather Type (Camel, Vegan)', 'icon': Icons.pets},
      {'key': 'item', 'label': 'Item Type (Bag, Wallet, Belt)', 'icon': Icons.shopping_bag},
      {'key': 'details', 'label': 'Tooling / Embossing Details', 'icon': Icons.brush},
    ],
    'Footwear': [
      {'key': 'type', 'label': 'Type (Jutti, Mojari, Sandal)', 'icon': Icons.shopping_bag},
      {'key': 'material', 'label': 'Material (Leather, Fabric)', 'icon': Icons.texture},
      {'key': 'size', 'label': 'Available Sizes (UK)', 'type': 'multiselect', 'options': ['4', '5', '6', '7', '8', '9', '10', '11', '12', 'Custom']},
      {'key': 'details', 'label': 'Embroidery / Crafting', 'icon': Icons.brush},
    ],
    'Handmade Jewelry': [
      {'key': 'material', 'label': 'Base Material (Silver, Thread)', 'icon': Icons.diamond},
      {'key': 'weight', 'label': 'Weight (Grams)', 'icon': Icons.scale},
      {'key': 'stone', 'label': 'Stone / Inlay (Semi-precious)', 'icon': Icons.auto_awesome},
      {'key': 'style', 'label': 'Style (Tribal, Antique)', 'icon': Icons.style},
    ],
    'Traditional Paintings': [
      {'key': 'style', 'label': 'Art Style (Madhubani, Warli)', 'icon': Icons.palette},
      {'key': 'canvas', 'label': 'Canvas (Cloth, Paper, Wood)', 'icon': Icons.texture},
      {'key': 'dimensions', 'label': 'Dimensions', 'icon': Icons.straighten},
      {'key': 'framed', 'label': 'Framed', 'type': 'switch'},
    ],
    'Bamboo & Cane Products': [
      {'key': 'type', 'label': 'Product Type (Basket, Furniture)', 'icon': Icons.chair},
      {'key': 'dimensions', 'label': 'Dimensions', 'icon': Icons.straighten},
      {'key': 'coating', 'label': 'Coating / Varnish', 'icon': Icons.format_paint},
      {'key': 'care', 'label': 'Care Instructions', 'icon': Icons.info},
    ],
    'Home Decor': [
      {'key': 'material', 'label': 'Primary Material', 'icon': Icons.texture},
      {'key': 'dimensions', 'label': 'Dimensions', 'icon': Icons.straighten},
      {'key': 'placement', 'label': 'Placement (Indoor/Outdoor)', 'icon': Icons.home},
      {'key': 'theme', 'label': 'Theme / Style', 'icon': Icons.style},
    ],
    'Other': [
      {'key': 'material', 'label': 'Primary Material', 'icon': Icons.texture},
      {'key': 'dimensions', 'label': 'Dimensions', 'icon': Icons.straighten},
      {'key': 'craft', 'label': 'Craft Style', 'icon': Icons.handyman},
    ],
  };

  void _setupDynamicFields(String category) {
    for (var controller in _dynamicControllers.values) {
      controller.dispose();
    }
    _dynamicControllers.clear();
    _dynamicSwitches.clear();
    _dynamicDropdowns.clear();
    _dynamicMultiSelects.clear();

    final fields = _categoryFields[category] ?? [];
    for (var field in fields) {
      if (field['type'] == 'switch') {
        _dynamicSwitches[field['key'] as String] = false; 
      } else if (field['type'] == 'dropdown') {
        _dynamicDropdowns[field['key'] as String] = null;
      } else if (field['type'] == 'multiselect') {
        _dynamicMultiSelects[field['key'] as String] = [];
      } else {
        _dynamicControllers[field['key'] as String] = TextEditingController();
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _spokenDescController.dispose();
    _englishDescController.dispose();
    _hindiDescController.dispose();
    _priceController.dispose();
    
    _rawMaterialCostController.dispose();
    _labourCostController.dispose();
    _packagingCostController.dispose();
    _otherCostController.dispose();
    _marketAveragePriceController.dispose();
    
    for (var controller in _dynamicControllers.values) {
      controller.dispose();
    }
    
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          _originalImageFile = _imageFile;
        });
      }
    }
  }

  Future<void> _listen() async {
    if (!_isListening) {
      if (await _audioRecorder.hasPermission()) {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/recording.m4a';
        
        await _audioRecorder.start(
          const RecordConfig(encoder: AudioEncoder.aacLc), 
          path: filePath,
        );
        setState(() => _isListening = true);
      }
    } else {
      final path = await _audioRecorder.stop();
      setState(() => _isListening = false);
      if (path != null) {
        _transcribeAndGenerate(path);
      }
    }
  }

  Future<void> _transcribeAndGenerate(String path) async {
    setState(() {
      final l10n = AppLocalizations.of(context);
      _isTranslating = true;
      _spokenDescController.text = l10n?.transcribingAudio ?? "Transcribing audio...";
      _englishDescController.text = l10n?.waitingForTranscription ?? "Waiting for transcription...";
      _hindiDescController.text = l10n?.waitingForTranscription ?? "Waiting for transcription...";
    });

    try {
      final text = await GroqService.transcribeAudio(path);
      if (mounted) {
         setState(() {
           _spokenDescController.text = text;
         });
         await _generateCatalog();
      }
    } catch(e) {
      if (mounted) {
        setState(() {
          _spokenDescController.text = "Error transcribing: $e";
          _isTranslating = false;
        });
      }
    }
  }
  Future<void> _generateCatalog() async {
    String text = _spokenDescController.text;
    if (text.isEmpty) return;

    if (_selectedCategory != null && _categoryFields.containsKey(_selectedCategory)) {
      text += '\n\nAdditional $_selectedCategory Details:\n';
      final fields = _categoryFields[_selectedCategory]!;
      for (var field in fields) {
        if (field['type'] == 'switch') {
          final val = _dynamicSwitches[field['key']] ?? false;
          text += '${field['label']}: ${val ? "Yes" : "No"}\n';
        } else if (field['type'] == 'dropdown') {
          final val = _dynamicDropdowns[field['key']];
          if (val != null && val.isNotEmpty) {
            text += '${field['label']}: $val\n';
          }
        } else if (field['type'] == 'multiselect') {
          final val = _dynamicMultiSelects[field['key']] ?? [];
          if (val.isNotEmpty) {
            text += '${field['label']}: ${val.join(", ")}\n';
          }
        } else {
          final val = _dynamicControllers[field['key']]?.text ?? '';
          if (val.isNotEmpty) {
            text += '${field['label']}: $val\n';
          }
        }
      }
    }

    setState(() {
      final l10n = AppLocalizations.of(context);
      _isTranslating = true;
      _englishDescController.text = l10n?.generating ?? "Generating description...";
      _hindiDescController.text = l10n?.generating ?? "Generating description...";
    });

    try {
      final descriptions = await GroqService.generateCatalog(text);
      if (descriptions != null) {
        setState(() {
          _englishDescController.text = descriptions['english'] ?? '';
          _hindiDescController.text = descriptions['hindi'] ?? '';
        });
      }
    } catch (e) {
      setState(() {
        final l10n = AppLocalizations.of(context);
        _englishDescController.text = "${l10n?.errorGenerating ?? 'Error generating:'} $e";
        _hindiDescController.text = "${l10n?.errorGenerating ?? 'Error generating:'} $e";
      });
    } finally {
      if (mounted) {
        setState(() {
          _isTranslating = false;
        });
      }
    }
  }

  Future<void> _calculateAIPrice(StateSetter setModalState) async {
    final rawMat = double.tryParse(_rawMaterialCostController.text) ?? 0.0;
    final labour = double.tryParse(_labourCostController.text) ?? 0.0;
    final pack = double.tryParse(_packagingCostController.text) ?? 0.0;
    final other = double.tryParse(_otherCostController.text) ?? 0.0;
    
    setModalState(() {
      _isCalculatingPrice = true;
    });

    final priceMap = await GroqService.predictDynamicPrice(
      productType: _selectedCategory ?? 'Handicraft',
      productDescription: _englishDescController.text.isNotEmpty ? _englishDescController.text : _nameController.text,
      rawMaterialCost: rawMat,
      labourCost: labour,
      packagingCost: pack,
      otherCost: other,
    );
    
    if (mounted) {
      setModalState(() {
        _isCalculatingPrice = false;
      });
      setState(() {
        if (priceMap != null) {
          _competitivePrice = priceMap['competitive_price'];
          _recommendedPrice = priceMap['recommended_price'];
        } else {
          final l10n = AppLocalizations.of(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n?.failedToCalculatePrice ?? 'Failed to calculate AI price. Please try again or check your internet connection.')),
          );
        }
      });
      Navigator.pop(context); // Close bottom sheet
    }
  }

  void _showAIPricingBottomSheet(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: BoxDecoration(
                color: isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
              ),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Text(
                    l10n?.aiPricingEngine ?? 'AI Pricing Engine',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryTerracotta,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle(l10n?.baseCosts ?? '1. Base Costs (₹)'),
                          _buildNumberField(_rawMaterialCostController, l10n?.rawMaterialCost ?? 'Raw Material Cost', isDark),
                          _buildNumberField(_labourCostController, l10n?.labourCost ?? 'Labour Cost', isDark),
                          _buildNumberField(_packagingCostController, l10n?.packagingCost ?? 'Packaging Cost', isDark),
                          _buildNumberField(_otherCostController, l10n?.otherCosts ?? 'Other Costs', isDark),
                          
                          const SizedBox(height: 32),
                          ElevatedButton.icon(
                            onPressed: _isCalculatingPrice ? null : () => _calculateAIPrice(setModalState),
                            icon: _isCalculatingPrice
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                  )
                                : const Icon(Icons.auto_awesome),
                            label: Text(_isCalculatingPrice ? (l10n?.calculating ?? 'Calculating...') : (l10n?.calculateOptimalPrice ?? 'Calculate Optimal Price')),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.accentTeal,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 50),
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildNumberField(TextEditingController controller, String label, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.currency_rupee, size: 18),
          filled: true,
          fillColor: isDark ? Colors.white10 : Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> options, String value, Function(String?) onChanged, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: isDark ? Colors.white10 : Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: options.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Future<void> _removeBackground() async {
    if (_imageFile == null) return;
    setState(() => _isRemovingBg = true);
    try {
      final options = SubjectSegmenterOptions(
        enableForegroundBitmap: true,
        enableForegroundConfidenceMask: false,
        enableMultipleSubjects: SubjectResultOptions(
          enableConfidenceMask: false,
          enableSubjectBitmap: false,
        ),
      );
      final segmenter = SubjectSegmenter(options: options);
      final inputImage = InputImage.fromFilePath(_imageFile!.path);
      
      final result = await segmenter.processImage(inputImage);
      segmenter.close();
      
      if (result.foregroundBitmap != null && mounted) {
        final fgBytes = await compute(_computeDecodeEncodePng, result.foregroundBitmap!);
        if (fgBytes != null) {
          final tempDir = await getTemporaryDirectory();
          final file = File('${tempDir.path}/bg_removed_${DateTime.now().millisecondsSinceEpoch}.png');
          await file.writeAsBytes(fgBytes);
          setState(() {
            _imageFile = file;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to remove background: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isRemovingBg = false);
      }
    }
  }

  Future<void> _manualEdit() async {
    if (_imageFile == null) return;
    final editedBytes = await Navigator.push<Uint8List?>(
      context,
      MaterialPageRoute(
        builder: (context) => ImageEditorScreen(imageFile: _imageFile!),
      ),
    );
    
    if (editedBytes != null && mounted) {
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/edited_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(editedBytes);
      setState(() {
        _imageFile = file;
      });
    }
  }

  Future<void> _autoEnhance() async {
    if (_imageFile == null) return;
    setState(() => _isEnhancing = true);
    
    try {
      // Run enhancement in an isolate to avoid blocking the UI
      final bytes = await _imageFile!.readAsBytes();
      final enhancedBytes = await compute(_computeEnhanceImage, bytes);
      
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/enhanced_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(enhancedBytes);
      
      if (mounted) {
        setState(() {
          _imageFile = file;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to enhance image: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isEnhancing = false);
      }
    }
  }

  void _viewCurrentImage() {
    if (_imageFile == null) return;
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          alignment: Alignment.center,
          children: [
            InteractiveViewer(
              child: Image.file(_imageFile!),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 32),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _viewOriginalImage() {
    if (_originalImageFile == null) return;
    
    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: Stack(
            alignment: Alignment.center,
            children: [
              GlassContainer(
                color: isDark ? Colors.black87 : Colors.white70,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('Before & After', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    ),
                    Flexible(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('Original', style: TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                Flexible(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(_originalImageFile!, fit: BoxFit.cover),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('Current', style: TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                Flexible(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(_imageFile!, fit: BoxFit.cover),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Close', style: TextStyle(color: isDark ? Colors.white : AppTheme.primaryTerracotta)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isProcessing,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: isProcessing ? null : onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? Colors.white10 : Colors.white.withValues(alpha: 0.8),
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.primaryTerracotta.withValues(alpha: 0.3)),
            ),
            child: isProcessing
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primaryTerracotta),
                  )
                : Icon(icon, color: AppTheme.primaryTerracotta),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.white70 : AppTheme.textDark,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    final isTa = Localizations.localeOf(context).languageCode == 'ta';

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            l10n?.addNewProduct ?? 'Add New Product',
            style: isTa 
                ? GoogleFonts.notoSansTamil(fontSize: 20, fontWeight: FontWeight.bold)
                : const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [AppTheme.backgroundDark, AppTheme.secondaryIndigo.withValues(alpha: 0.5)]
                      : [AppTheme.primaryLight, AppTheme.secondaryLight],
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Camera Capture Area
                  GestureDetector(
                    onTap: _pickImage,
                    child: SizedBox(
                      height: 200,
                      child: GlassContainer(
                        color: isDark ? Colors.white10 : Colors.white60,
                      child: _imageFile != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.file(_imageFile!, fit: BoxFit.cover),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.camera_alt, size: 48, color: AppTheme.primaryTerracotta),
                                const SizedBox(height: 8),
                                Text(
                                  l10n?.captureImage ?? 'Capture Image',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: AppTheme.primaryTerracotta,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                      ),
                    ),
                  ),
                  if (_imageFile != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildImageActionButton(
                          icon: Icons.fullscreen,
                          label: 'View',
                          onTap: _viewCurrentImage,
                          isProcessing: false,
                          isDark: isDark,
                        ),
                        _buildImageActionButton(
                          icon: Icons.auto_fix_high,
                          label: 'Auto BG',
                          onTap: _removeBackground,
                          isProcessing: _isRemovingBg,
                          isDark: isDark,
                        ),
                        _buildImageActionButton(
                          icon: Icons.edit,
                          label: 'Manual Edit',
                          onTap: _manualEdit,
                          isProcessing: false,
                          isDark: isDark,
                        ),
                        _buildImageActionButton(
                          icon: Icons.auto_awesome,
                          label: 'Enhance',
                          onTap: _autoEnhance,
                          isProcessing: _isEnhancing,
                          isDark: isDark,
                        ),
                        if (_originalImageFile != null && _imageFile?.path != _originalImageFile?.path)
                          _buildImageActionButton(
                            icon: Icons.compare,
                            label: 'Compare',
                            onTap: _viewOriginalImage,
                            isProcessing: false,
                            isDark: isDark,
                          ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 24),
                  
                  // Product Name
                  GlassContainer(
                    borderRadius: 24.0,
                    color: isDark ? Colors.white10 : Colors.white.withValues(alpha: 0.5),
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        filled: false,
                        labelText: l10n?.productName ?? 'Product Name',
                        prefixIcon: const Icon(Icons.shopping_bag_outlined),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Product Category Dropdown
                  GlassContainer(
                    borderRadius: 24.0,
                    color: isDark ? Colors.white10 : Colors.white.withValues(alpha: 0.5),
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        borderRadius: BorderRadius.circular(24.0),
                        value: _selectedCategory,
                        hint: Text(
                          'Select Product Type',
                          style: TextStyle(
                            color: isDark ? Colors.white70 : AppTheme.textDark.withValues(alpha: 0.6),
                          ),
                        ),
                        isExpanded: true,
                        dropdownColor: isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
                        icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.primaryTerracotta),
                        items: _productCategories.map((String category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(
                              category,
                              style: TextStyle(
                                color: isDark ? Colors.white : AppTheme.textDark,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedCategory = newValue;
                              _setupDynamicFields(newValue);
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Dynamic Specific Fields
                  if (_selectedCategory != null && _categoryFields.containsKey(_selectedCategory)) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                      child: Text(
                        '$_selectedCategory Details',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: isDark ? Colors.white : AppTheme.primaryTerracotta,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ..._categoryFields[_selectedCategory]!.map((field) {
                      if (field['type'] == 'switch') {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: GlassContainer(
                            borderRadius: 24.0,
                            color: isDark ? Colors.white10 : Colors.white.withValues(alpha: 0.5),
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    field['label'] as String,
                                    style: TextStyle(
                                      color: isDark ? Colors.white70 : AppTheme.textMutedLight,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Switch(
                                  value: _dynamicSwitches[field['key']] ?? false,
                                  activeColor: AppTheme.primaryTerracotta,
                                  onChanged: (val) {
                                    setState(() {
                                      _dynamicSwitches[field['key'] as String] = val;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      } else if (field['type'] == 'dropdown') {
                        final options = field['options'] as List<String>;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: GlassContainer(
                            borderRadius: 24.0,
                            color: isDark ? Colors.white10 : Colors.white.withValues(alpha: 0.5),
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                borderRadius: BorderRadius.circular(24.0),
                                value: _dynamicDropdowns[field['key']],
                                hint: Text(
                                  field['label'] as String,
                                  style: TextStyle(
                                    color: isDark ? Colors.white70 : AppTheme.textDark.withValues(alpha: 0.6),
                                  ),
                                ),
                                isExpanded: true,
                                dropdownColor: isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
                                icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.primaryTerracotta),
                                items: options.map((String option) {
                                  return DropdownMenuItem<String>(
                                    value: option,
                                    child: Text(
                                      option,
                                      style: TextStyle(
                                        color: isDark ? Colors.white : AppTheme.textDark,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _dynamicDropdowns[field['key'] as String] = newValue;
                                  });
                                },
                              ),
                            ),
                          ),
                        );
                      } else if (field['type'] == 'multiselect') {
                        final options = field['options'] as List<String>;
                        final selected = _dynamicMultiSelects[field['key']] ?? [];
                        
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: GlassContainer(
                            borderRadius: 24.0,
                            color: isDark ? Colors.white10 : Colors.white.withValues(alpha: 0.5),
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  field['label'] as String,
                                  style: TextStyle(
                                    color: isDark ? Colors.white70 : AppTheme.textMutedLight,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8.0,
                                  runSpacing: 8.0,
                                  children: options.map((option) {
                                    final isSelected = selected.contains(option);
                                    return FilterChip(
                                      label: Text(option),
                                      selected: isSelected,
                                      selectedColor: AppTheme.primaryTerracotta.withValues(alpha: 0.2),
                                      checkmarkColor: AppTheme.primaryTerracotta,
                                      labelStyle: TextStyle(
                                        color: isSelected ? AppTheme.primaryTerracotta : (isDark ? Colors.white70 : AppTheme.textDark),
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      ),
                                      onSelected: (bool value) {
                                        setState(() {
                                          if (value) {
                                            selected.add(option);
                                          } else {
                                            selected.remove(option);
                                          }
                                        });
                                      },
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: GlassContainer(
                            borderRadius: 24.0,
                            color: isDark ? Colors.white10 : Colors.white.withValues(alpha: 0.5),
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: TextField(
                              controller: _dynamicControllers[field['key']],
                              decoration: InputDecoration(
                                filled: false,
                                labelText: field['label'] as String,
                                prefixIcon: Icon(field['icon'] as IconData),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                            ),
                          ),
                        );
                      }
                    }),
                    const SizedBox(height: 8),
                  ],

                  // Spoken Description Box
                  GlassContainer(
                    borderRadius: 24.0,
                    color: isDark ? Colors.white10 : Colors.white.withValues(alpha: 0.5),
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: _spokenDescController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            filled: false,
                            labelText: l10n?.spokenDescription ?? 'Spoken Description (Local Language)',
                            alignLabelWithHint: true,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isListening ? Icons.mic : Icons.mic_none,
                                color: _isListening ? Colors.red : AppTheme.primaryTerracotta,
                              ),
                              onPressed: _listen,
                            ),
                          ),
                        ),
                        if (_isListening) ...[
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 35,
                            child: FakeWaveform(isDark: isDark),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Translate Button
                  Align(
                    alignment: Alignment.centerRight,
                    child: GlassContainer(
                      borderRadius: 30.0,
                      color: AppTheme.primaryTerracotta.withValues(alpha: 0.2),
                      border: Border.all(color: AppTheme.primaryTerracotta.withValues(alpha: 0.4), width: 1.5),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30.0),
                        onTap: _generateCatalog,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (_isTranslating)
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: isDark ? Colors.white : AppTheme.primaryTerracotta,
                                  ),
                                )
                              else
                                Icon(Icons.translate, color: isDark ? Colors.white : AppTheme.primaryTerracotta),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  _isTranslating ? (l10n?.generating ?? 'Generating...') : (l10n?.generateCatalog ?? 'Generate Catalog'),
                                  style: TextStyle(
                                    color: isDark ? Colors.white : AppTheme.primaryTerracotta,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // English Description Box
                  GlassContainer(
                    borderRadius: 24.0,
                    color: isDark ? Colors.white10 : Colors.white.withValues(alpha: 0.5),
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(
                      controller: _englishDescController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        filled: false,
                        labelText: l10n?.englishDescription ?? 'Product Description (English)',
                        alignLabelWithHint: true,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Hindi Description Box
                  GlassContainer(
                    borderRadius: 24.0,
                    color: isDark ? Colors.white10 : Colors.white.withValues(alpha: 0.5),
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(
                      controller: _hindiDescController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        filled: false,
                        labelText: l10n?.productDescriptionHindi ?? 'Product Description (Hindi)',
                        alignLabelWithHint: true,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: OutlinedButton.icon(
                      onPressed: () => _showAIPricingBottomSheet(context),
                      icon: const Icon(Icons.auto_awesome),
                      label: Text(l10n?.generateAiPrice ?? '✨ Generate AI Price'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.accentTeal,
                        side: const BorderSide(color: AppTheme.accentTeal),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                  ),

                  // AI Pricing UI
                  if (_recommendedPrice != null && _competitivePrice != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: GlassContainer(
                        borderRadius: 16.0,
                        color: AppTheme.accentTeal.withValues(alpha: 0.1),
                        border: Border.all(color: AppTheme.accentTeal),
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        l10n?.competitivePrice ?? 'Competitive Price',
                                        style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '₹${_competitivePrice!.toStringAsFixed(0)}',
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, decoration: TextDecoration.lineThrough),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        l10n?.recommendedPrice ?? 'Recommended Price',
                                        style: const TextStyle(color: AppTheme.accentTeal, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '₹${_recommendedPrice!.toStringAsFixed(0)}',
                                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppTheme.textDark),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  _priceController.text = _recommendedPrice!.toStringAsFixed(0);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.accentTeal,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: Text(l10n?.applyRecommendedPrice ?? 'Apply Recommended Price'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  
                  // Price Box
                  GlassContainer(
                    borderRadius: 24.0,
                    color: isDark ? Colors.white10 : Colors.white.withValues(alpha: 0.5),
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: false,
                        labelText: l10n?.productPrice ?? 'Product Price',
                        prefixIcon: const Icon(Icons.currency_rupee),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Submit Button
                  GlassContainer(
                    borderRadius: 30.0,
                    color: AppTheme.primaryTerracotta.withValues(alpha: 0.25),
                    border: Border.all(color: AppTheme.primaryTerracotta.withValues(alpha: 0.5), width: 1.5),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30.0),
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: Text(
                            l10n?.submitProduct ?? 'Submit Product',
                            style: TextStyle(
                              color: isDark ? Colors.white : AppTheme.primaryTerracotta,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
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

class FakeWaveform extends StatefulWidget {
  final bool isDark;
  const FakeWaveform({super.key, required this.isDark});

  @override
  State<FakeWaveform> createState() => _FakeWaveformState();
}

class _FakeWaveformState extends State<FakeWaveform> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<double> _randomOffsets;

  @override
  void initState() {
    super.initState();
    final rand = math.Random();
    _randomOffsets = List.generate(25, (index) => rand.nextDouble() * math.pi * 2);
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(25, (index) {
            final time = _controller.value * math.pi * 2;
            // Mix of sine and cosine at different speeds for organic chaos
            final wave1 = math.sin(time * 3 + index * 0.4);
            final wave2 = math.cos(time * 2 + _randomOffsets[index]);
            final combined = (wave1 + wave2) / 2;
            
            final height = 5 + 30 * combined.abs();
            
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 1.5),
              width: 3,
              height: height,
              decoration: BoxDecoration(
                color: widget.isDark ? Colors.white.withValues(alpha: 0.8) : AppTheme.primaryTerracotta.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        );
      },
    );
  }
}

// Top level function for isolate processing
Uint8List? _computeDecodeEncodePng(Uint8List bgBitmap) {
  final fgImage = img.decodePng(bgBitmap);
  if (fgImage == null) return null;
  return Uint8List.fromList(img.encodePng(fgImage));
}

// Top level function for isolate processing
Uint8List _computeEnhanceImage(Uint8List imageBytes) {
  final originalImage = img.decodeImage(imageBytes);
  if (originalImage == null) return imageBytes;
  
  var enhanced = img.adjustColor(originalImage, brightness: 1.1, contrast: 1.2);
  return Uint8List.fromList(img.encodePng(enhanced));
}

