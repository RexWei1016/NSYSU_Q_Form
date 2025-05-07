// 📁 lib/views/profile_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/user_profile.dart';
import '../viewmodels/profile_view_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController userIdController = TextEditingController();

  String? selectedDepartment;
  String? selectedGrade;
  String? selectedBirthYear;
  String? selectedGender;

  final List<String> allDepartments = [
    '中國文學系',
    '外國語文學系',
    '音樂學系',
    '劇場藝術學系',
    '哲學研究所',
    '藝術管理與創業研究所',
    '化學系',
    '物理學系',
    '生物科學系',
    '應用數學系',
    '理學國際博士學位學程',
    '電機工程學系',
    '機械與機電工程學系',
    '資訊工程學系',
    '材料與光電科學學系',
    '光電工程學系',
    '環境工程研究所',
    '通訊工程研究所',
    '積體電路設計研究所',
    '電機電力工程國際碩士學程',
    '電信工程國際碩士學位學程',
    '企業管理學系',
    '資訊管理學系',
    '財務管理學系',
    '公共事務管理研究所',
    '人力資源管理研究所',
    '行銷傳播管理研究所',
    '國際經營管理全英語學士學位學程 (IBBA)',
    '高階經營碩士學程(EMBA)',
    '國際經營管理碩士學程(IBMBA)',
    '人力資源管理全英語碩士學位學程(Global HRM English MBA)',
    '海洋生物科技暨資源學系',
    '海洋環境及工程學系',
    '海洋科學系',
    '海下科技研究所',
    '海洋事務研究所',
    '海洋生態與保育研究所',
    '海洋生物科技博士學位學程',
    '海洋科學與科技全英語博士學位學程',
    '政治經濟學系',
    '社會學系',
    '經濟學研究所',
    '政治學研究所',
    '教育研究所',
    '中國與亞太區域研究所',
    '師資培育中心',
    '高階公共政策碩士學程在職專班(EMPP)',
    '亞太事務英語碩士學位學程',
    '教育與人類發展研究全英語學位學程',
    '基礎教育中心',
    '博雅教育中心',
    '運動與健康教育中心',
    '服務學習教育中心',
    '運動健康產業研究中心',
    '人文暨科技跨領域學士學位學程',
    '社會創新研究所',
    '全英語卓越教學中心',
    '國際跨域學士學位學程原住民族專班',
    '學士後醫學系',
    '生物醫學科技學系',
    '生物醫學研究所',
    '醫學科技研究所',
    '生技醫藥研究所',
    '精準醫學研究所',
    '臨床醫學科學博士學位學程',
    '護理學系',
    '先進半導體封測研究所',
    '精密電子零組件研究所',
    '創新半導體製造研究所',
    '國際資產管理研究所',
    '數位與永續金融研究所',
    '其他' // 您要求的 "其他" 選項
  ];
  final List<String> grades = ['大一', '大二', '大三', '大四', '碩一', '碩二', '博班'];
  final List<String> birthYears = [
    for (int y = 1980; y <= DateTime
        .now()
        .year; y++) y.toString()
  ].reversed.toList();

  @override
  late Future<UserProfile> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = context.read<ProfileViewModel>().loadProfileWithReturn();
  }

  void saveProfile() async {
    final profileVM = context.read<ProfileViewModel>();
    final newProfile = profileVM.profile.copyWith(
      email: emailController.text,
      department: selectedDepartment ?? '',
      grade: selectedGrade ?? '',
      birthYear: selectedBirthYear ?? '',
      gender: selectedGender ?? '',
      userId: userIdController.text,
    );

    // 顯示等待 Dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await profileVM.updateProfile(newProfile);
      Navigator.of(context).pop(); // 關閉等待 Dialog

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('已儲存個人資料')),
      );
    } catch (e) {
      Navigator.of(context).pop(); // ✅ 確保錯誤時也關閉
      debugPrint('儲存個人資料錯誤: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('儲存失敗，請稍後再試')),
      );
    }
  }

  Widget buildTextField(String label, TextEditingController controller,
      {bool readOnly = false}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: controller,
              readOnly: readOnly,
              decoration: const InputDecoration(border: InputBorder.none),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDropdown(String label, String? value, List<String> items,
      void Function(String?) onChanged) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              isExpanded: true,
              value: value,
              underline: const SizedBox(),
              hint: const Text('請選擇'),
              items: items
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: onChanged,
            )
          ],
        ),
      ),
    );
  }

  Widget buildGenderSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('性別', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: ['男', '女', '其他'].map((gender) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio<String>(
                      value: gender,
                      groupValue: selectedGender,
                      onChanged: (val) => setState(() => selectedGender = val),
                    ),
                    Text(gender),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
  bool hasInitialized = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('編輯個人資料'),
        backgroundColor: Colors.green.shade700,
      ),
      body: FutureBuilder(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          if (!hasInitialized) {
            final profile = snapshot.data!;

            // 1. 初始化輸入欄位
            emailController.text = profile.email;
            selectedDepartment = profile.department;
            selectedGrade = profile.grade;
            selectedBirthYear = profile.birthYear;
            selectedGender = profile.gender;

            // 2. 處理 userId 若為空
            if (profile.userId.isEmpty) {
              final newId = const Uuid().v4();
              userIdController.text = newId;

              final updatedProfile = profile.copyWith(userId: newId);
              context.read<ProfileViewModel>().updateProfile(updatedProfile);
            } else {
              userIdController.text = profile.userId;
            }

            hasInitialized = true;
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                buildTextField('信箱', emailController),
                buildDropdown('系所', selectedDepartment, allDepartments,
                        (val) => setState(() => selectedDepartment = val)),
                buildDropdown('年級', selectedGrade, grades,
                        (val) => setState(() => selectedGrade = val)),
                buildDropdown('出生年', selectedBirthYear, birthYears,
                        (val) => setState(() => selectedBirthYear = val)),
                buildGenderSelector(),
                buildTextField('代號', userIdController, readOnly: true),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: saveProfile,
        child: const Icon(Icons.save),
      ),
    );
  }
}