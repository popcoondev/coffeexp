import 'package:flutter/material.dart';

import '../widgets/label.dart';

class TastingFeedbackScreen extends StatefulWidget {
  @override
  _TastingFeedbackScreenState createState() => _TastingFeedbackScreenState();
}

class _TastingFeedbackScreenState extends State<TastingFeedbackScreen> {
  double? _aroma;
  double? _flavor;
  double? _acidity;
  double? _body;
  double? _sweetness;
  double? _overall;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasting Feedback'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Label(mainText: 'Aroma', subText: '香り'),
                Slider(
                  value: _aroma ?? 0,
                  min: 0,
                  max: 10,
                  divisions: 10,
                  label: _aroma?.toString(),
                  onChanged: (value) {
                    setState(() {
                      _aroma = value;
                    });
                  },
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Label(mainText: 'Flavor', subText: 'フレーバー'),
                Slider(
                  value: _flavor ?? 0,
                  min: 0,
                  max: 10,
                  divisions: 10,
                  label: _flavor?.toString(),
                  onChanged: (value) {
                    setState(() {
                      _flavor = value;
                    });
                  },
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Label(mainText: 'Acidity', subText: '酸味'),
                Slider(
                  value: _acidity ?? 0,
                  min: 0,
                  max: 10,
                  divisions: 10,
                  label: _acidity?.toString(),
                  onChanged: (value) {
                    setState(() {
                      _acidity = value;
                    });
                  },
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Label(mainText: 'Body', subText: 'ボディ'),
                Slider(
                  value: _body ?? 0,
                  min: 0,
                  max: 10,
                  divisions: 10,
                  label: _body?.toString(),
                  onChanged: (value) {
                    setState(() {
                      _body = value;
                    });
                  },
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Label(mainText: 'Sweetness', subText: '甘味'),
                Slider(
                  value: _sweetness ?? 0,
                  min: 0,
                  max: 10,
                  divisions: 10,
                  label: _sweetness?.toString(),
                  onChanged: (value) {
                    setState(() {
                      _sweetness = value;
                    });
                  },
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Label(mainText: 'Overall', subText: '全体的な評価'),
                Slider(
                  value: _overall ?? 0,
                  min: 0,
                  max: 10,
                  divisions: 10,
                  label: _overall?.toString(),
                  onChanged: (value) {
                    setState(() {
                      _overall = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Tasting feedback saved successfully')),
                );
                Navigator.pop(context);
              },
              child: Text('Save Feedback'),
            ),
          ],
        ),
      ),
    );
  }
}