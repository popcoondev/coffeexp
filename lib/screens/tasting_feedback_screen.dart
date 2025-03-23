import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/coffee.dart';
import '../models/tasting.dart';
import '../services/firebase_service.dart';
import '../widgets/label.dart';
import '../widgets/tasting_radar_chart.dart';

class TastingFeedbackScreen extends StatefulWidget {
  final Coffee coffee;
  final String coffeeId;
  final List<Tasting>? previousTastings;

  const TastingFeedbackScreen({
    Key? key,
    required this.coffee,
    required this.coffeeId,
    this.previousTastings,
  }) : super(key: key);

  @override
  _TastingFeedbackScreenState createState() => _TastingFeedbackScreenState();
}

class _TastingFeedbackScreenState extends State<TastingFeedbackScreen> {
  double _aroma = 5;
  double _flavor = 5;
  double _acidity = 5;
  double _body = 5;
  double _sweetness = 5;
  double _overall = 5;
  final TextEditingController _notesController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();
  
  bool _isLoading = false;
  bool _showHistoryView = false;
  List<Tasting> _allTastings = [];
  
  @override
  void initState() {
    super.initState();
    _loadTastings();
  }
  
  Future<void> _loadTastings() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Load all tastings for this coffee
      final tastings = await _firebaseService.getTastings(widget.coffeeId);
      setState(() {
        _allTastings = tastings;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading tastings: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTasting = Tasting(
      aroma: _aroma,
      flavor: _flavor,
      acidity: _acidity,
      body: _body,
      sweetness: _sweetness,
      overall: _overall,
      notes: _notesController.text,
      date: DateTime.now(),
    );
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasting: ${widget.coffee.coffeeName}'),
        actions: [
          IconButton(
            icon: Icon(_showHistoryView ? Icons.edit : Icons.history),
            onPressed: () {
              setState(() {
                _showHistoryView = !_showHistoryView;
              });
            },
            tooltip: _showHistoryView ? 'Edit Mode' : 'History View',
          ),
        ],
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : _showHistoryView 
              ? _buildHistoryView() 
              : _buildTastingForm(currentTasting),
    );
  }
  
  Widget _buildTastingForm(Tasting currentTasting) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Radar chart preview at the top
          if (_allTastings.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Current Tasting Preview',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TastingRadarChart(
                        tasting: currentTasting,
                        previousTastings: _allTastings,
                        size: 250,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildLegendItem('Current Tasting', Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 16),
                          _buildLegendItem('Previous Average', Theme.of(context).colorScheme.secondary),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Sliders for tasting parameters
          _buildTastingSlider(
            label: 'Aroma',
            japaneseLabel: '香り',
            value: _aroma,
            onChanged: (value) {
              setState(() {
                _aroma = value;
              });
            },
          ),
          
          _buildTastingSlider(
            label: 'Flavor',
            japaneseLabel: 'フレーバー',
            value: _flavor,
            onChanged: (value) {
              setState(() {
                _flavor = value;
              });
            },
          ),
          
          _buildTastingSlider(
            label: 'Acidity',
            japaneseLabel: '酸味',
            value: _acidity,
            onChanged: (value) {
              setState(() {
                _acidity = value;
              });
            },
          ),
          
          _buildTastingSlider(
            label: 'Body',
            japaneseLabel: 'ボディ',
            value: _body,
            onChanged: (value) {
              setState(() {
                _body = value;
              });
            },
          ),
          
          _buildTastingSlider(
            label: 'Sweetness',
            japaneseLabel: '甘味',
            value: _sweetness,
            onChanged: (value) {
              setState(() {
                _sweetness = value;
              });
            },
          ),
          
          _buildTastingSlider(
            label: 'Overall',
            japaneseLabel: '全体的な評価',
            value: _overall,
            onChanged: (value) {
              setState(() {
                _overall = value;
              });
            },
          ),
          
          const SizedBox(height: 20),
          
          // Tasting notes text field
          TextField(
            controller: _notesController,
            decoration: const InputDecoration(
              labelText: 'Tasting Notes',
              hintText: 'Enter your tasting observations here...',
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
          ),
          
          const SizedBox(height: 20),
          
          // Save button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveTastingFeedback,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Save Feedback'),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHistoryView() {
    if (_allTastings.isEmpty) {
      return const Center(
        child: Text('No tasting history available yet'),
      );
    }
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tasting history visualization
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TastingHistoryChart(
                tastings: _allTastings,
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // List of all tastings
          const Text(
            'Tasting History',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          
          ..._allTastings.map((tasting) => _buildTastingHistoryItem(tasting)).toList(),
        ],
      ),
    );
  }
  
  Widget _buildTastingHistoryItem(Tasting tasting) {
    final dateFormatter = DateFormat('yyyy/MM/dd HH:mm');
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ExpansionTile(
        title: Text(
          dateFormatter.format(tasting.date),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Overall: ${tasting.overall.toStringAsFixed(1)}'),
        childrenPadding: const EdgeInsets.all(16),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Radar chart
              Expanded(
                flex: 3,
                child: TastingRadarChart(
                  tasting: tasting,
                  size: 180,
                ),
              ),
              
              // Scores
              Expanded(
                flex: 2,
                child: TastingScoreLegend(
                  scores: {
                    'Aroma': tasting.aroma,
                    'Flavor': tasting.flavor,
                    'Acidity': tasting.acidity,
                    'Body': tasting.body,
                    'Sweetness': tasting.sweetness,
                    'Overall': tasting.overall,
                  },
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          
          // Notes
          if (tasting.notes != null && tasting.notes!.isNotEmpty) ...[
            const Divider(),
            Text(
              'Notes:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(tasting.notes!),
          ],
          
          // Delete button
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.delete_outline),
                label: const Text('Delete'),
                onPressed: () => _confirmDeleteTasting(tasting),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildTastingSlider({
    required String label,
    required String japaneseLabel,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(mainText: label, subText: japaneseLabel),
        Row(
          children: [
            const SizedBox(width: 16),
            Expanded(
              child: Slider(
                value: value,
                min: 0,
                max: 10,
                divisions: 20,
                label: value.toStringAsFixed(1),
                onChanged: onChanged,
              ),
            ),
            SizedBox(
              width: 40,
              child: Text(
                value.toStringAsFixed(1),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(label),
      ],
    );
  }
  
  Future<void> _saveTastingFeedback() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final tasting = Tasting(
        aroma: _aroma,
        flavor: _flavor,
        acidity: _acidity,
        body: _body,
        sweetness: _sweetness,
        overall: _overall,
        notes: _notesController.text,
        date: DateTime.now(),
      );
      
      await _firebaseService.addTasting(widget.coffeeId, tasting);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tasting feedback saved successfully')),
        );
        Navigator.pop(context, true); // Return true to indicate refresh needed
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving tasting: $e')),
        );
      }
    }
  }
  
  Future<void> _confirmDeleteTasting(Tasting tasting) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Tasting'),
        content: const Text('Are you sure you want to delete this tasting? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    
    if (confirmed == true && tasting.id != null) {
      setState(() {
        _isLoading = true;
      });
      
      try {
        await _firebaseService.deleteTasting(widget.coffeeId, tasting.id!);
        await _loadTastings(); // Refresh the list
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tasting deleted successfully')),
          );
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting tasting: $e')),
          );
        }
      }
    }
  }
}