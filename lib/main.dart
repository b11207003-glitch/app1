import 'package:flutter/material.dart';
import 'package:flutter_picker_plus/flutter_picker_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '我的通訊錄',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: '我的通訊錄'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  DateTime? _birthday;
  String? _submittedName;
  String? _submittedPhone;
  String? _submittedBirthday;
  List<String> _submittedInterests = <String>[];
  final Map<String, bool> _interestSelections = <String, bool>{
    '球類運動': false,
    '游泳': false,
    '音樂': false,
    '看電影': false,
    '旅遊': false,
    '電腦遊戲': false,
  };

  void _showBirthdayPicker() {
    Picker(
      adapter: DateTimePickerAdapter(type: PickerDateTimeType.kYMD),
      title: const Text('選擇好友生日'),
      onConfirm: (Picker picker, List<int> value) {
        final DateTime? selectedDate =
            (picker.adapter as DateTimePickerAdapter).value;
        if (selectedDate == null) {
          return;
        }
        setState(() {
          _birthday = selectedDate;
        });
      },
    ).showModal(context);
  }

  String _birthdayText() {
    if (_birthday == null) {
      return '請選擇好友生日';
    }
    final String year = _birthday!.year.toString();
    final String month = _birthday!.month.toString().padLeft(2, '0');
    final String day = _birthday!.day.toString().padLeft(2, '0');
    return '$year/$month/$day';
  }

  List<String> _selectedInterests() {
    return _interestSelections.entries
        .where((MapEntry<String, bool> entry) => entry.value)
        .map((MapEntry<String, bool> entry) => entry.key)
        .toList();
  }

  void _submitFriendData() {
    setState(() {
      _submittedName = _itemNameController.text.trim();
      _submittedPhone = _phoneController.text.trim();
      _submittedBirthday = _birthdayText();
      _submittedInterests = _selectedInterests();
    });
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _itemNameController,
                decoration: const InputDecoration(
                  labelText: '好友姓名',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: '電話號碼',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: _showBirthdayPicker,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: '好友生日',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(_birthdayText()),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '好友興趣',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              ..._interestSelections.keys.map((String interest) {
                return CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(interest),
                  value: _interestSelections[interest],
                  onChanged: (bool? value) {
                    setState(() {
                      _interestSelections[interest] = value ?? false;
                    });
                  },
                );
              }),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitFriendData,
                  child: const Text('確定'),
                ),
              ),
              if (_submittedName != null) ...<Widget>[
                const SizedBox(height: 16),
                const Text(
                  '好友資料',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text('姓名：${_submittedName!.isEmpty ? '未填寫' : _submittedName!}'),
                Text('電話：${_submittedPhone!.isEmpty ? '未填寫' : _submittedPhone!}'),
                Text('生日：${_submittedBirthday == '請選擇好友生日' ? '未選擇' : _submittedBirthday!}'),
                Text(
                  '興趣：${_submittedInterests.isEmpty ? '未選擇' : _submittedInterests.join('、')}',
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
