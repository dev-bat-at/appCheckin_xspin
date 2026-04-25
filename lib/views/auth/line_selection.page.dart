import 'package:checkin/app/app_sp.dart';
import 'package:checkin/app/app_sp_key.dart';
import 'package:checkin/constants/app_color.dart';
import 'package:checkin/constants/app_fontsize.dart';
import 'package:checkin/model/line_checkin.model.dart';
import 'package:checkin/requests/login.request.dart';
import 'package:checkin/views/auth/sign_in.dart';
import 'package:checkin/views/index/index.page.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LineSelectionPage extends StatefulWidget {
  const LineSelectionPage({
    super.key,
    this.allowBack = false,
  });

  final bool allowBack;

  @override
  State<LineSelectionPage> createState() => _LineSelectionPageState();
}

class _LineSelectionPageState extends State<LineSelectionPage> {
  final LoginRequest _loginRequest = LoginRequest();
  List<LineCheckin> _lines = [];
  bool _isLoading = true;
  bool _isSubmitting = false;
  String? _selectedLineId;

  @override
  void initState() {
    super.initState();
    _loadLines();
  }

  Future<void> _loadLines() async {
    setState(() {
      _isLoading = true;
    });

    final lines = await _loginRequest.getLineCheckins(
      idSuKien: AppSP.get(AppSPKey.idSuKien) ?? '',
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _lines = lines;
      final savedLineId = AppSP.get(AppSPKey.idLineCheckin);
      _selectedLineId = savedLineId ?? _selectedLineId;
      if ((_selectedLineId == null || _selectedLineId!.isEmpty) &&
          lines.length == 1) {
        _selectedLineId = lines.first.idLineCheckin;
      }
      _isLoading = false;
    });
  }

  Future<void> _confirmSelection() async {
    if (_selectedLineId == null || _selectedLineId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn line check-in')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final selectedLine = _lines.firstWhere(
      (line) => line.idLineCheckin == _selectedLineId,
      orElse: () => LineCheckin(idLineCheckin: _selectedLineId!, tenLine: ''),
    );

    await AppSP.set(AppSPKey.idLineCheckin, selectedLine.idLineCheckin);
    await AppSP.set(AppSPKey.tenLineCheckin, selectedLine.tenLine);

    if (!mounted) {
      return;
    }

    if (widget.allowBack) {
      Navigator.pop(context, true);
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const IndexPage()),
    );
  }

  Future<void> _logout() async {
    await AppSP.set(AppSPKey.tenTK, '');
    await AppSP.set(AppSPKey.password, '');
    await AppSP.set(AppSPKey.idSuKien, '');
    await AppSP.set(AppSPKey.loaiCheckin, '');
    await AppSP.set(AppSPKey.isNhieuLine, '');
    await AppSP.set(AppSPKey.idLineCheckin, '');
    await AppSP.set(AppSPKey.tenLineCheckin, '');

    if (!mounted) {
      return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const SignInView()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final accentBackground = const Color(0xFFF7E4E7);
    final accentDark = const Color(0xFF7A1621);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F3F1),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColor.primaryColor,
        centerTitle: true,
        leading: widget.allowBack
            ? IconButton(
                onPressed: () => Navigator.maybePop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              )
            : null,
        title: Text(
          widget.allowBack ? 'Đổi Line Check-in' : 'Chọn Line Check-in',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFF8F3F1),
                Color(0xFFFFFFFF),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _isLoading
                ? Center(
                    child: LoadingAnimationWidget.threeRotatingDots(
                      color: AppColor.primaryColor,
                      size: 50,
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColor.primaryColor,
                              accentDark,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  AppColor.primaryColor.withValues(alpha: 0.18),
                              blurRadius: 18,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.14),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.alt_route_rounded,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              widget.allowBack
                                  ? 'Đổi quầy check-in'
                                  : 'Chọn quầy check-in',
                              style: TextStyle(
                                fontSize: AppFontSize.sizeLarge,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Bạn vui lòng chọn line check-in phù hợp',
                              style: TextStyle(
                                fontSize: AppFontSize.sizeSmall,
                                color: Colors.white.withValues(alpha: 0.88),
                                height: 1.45,
                              ),
                            ),
                            if ((AppSP.get(AppSPKey.tenTK) ?? '')
                                .isNotEmpty) ...[
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.confirmation_num_outlined,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Sự kiện: ${AppSP.get(AppSPKey.tenTK) ?? ''}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          children: [
                            Text(
                              'Danh sách line',
                              style: TextStyle(
                                fontSize: AppFontSize.sizeMedium,
                                fontWeight: FontWeight.w800,
                                color: accentDark,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: accentBackground,
                                borderRadius: BorderRadius.circular(99),
                              ),
                              child: Text(
                                '${_lines.length} line',
                                style: TextStyle(
                                  color: accentDark,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: _lines.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text('Chưa có line check-in để chọn'),
                                    const SizedBox(height: 12),
                                    ElevatedButton(
                                      onPressed: _loadLines,
                                      child: const Text('Tải lại'),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.separated(
                                itemCount: _lines.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final line = _lines[index];
                                  final isSelected =
                                      _selectedLineId == line.idLineCheckin;
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 180),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(22),
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColor.primaryColor
                                            : const Color(0xFFE6D9D6),
                                        width: isSelected ? 1.6 : 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: isSelected
                                              ? AppColor.primaryColor
                                                  .withValues(alpha: 0.12)
                                              : Colors.black.withValues(
                                                  alpha: 0.035,
                                                ),
                                          blurRadius: isSelected ? 18 : 10,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(22),
                                        onTap: () {
                                          setState(() {
                                            _selectedLineId =
                                                line.idLineCheckin;
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 48,
                                                height: 48,
                                                decoration: BoxDecoration(
                                                  color: isSelected
                                                      ? AppColor.primaryColor
                                                      : accentBackground,
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                                child: Icon(
                                                  Icons.qr_code_rounded,
                                                  color: isSelected
                                                      ? Colors.white
                                                      : accentDark,
                                                ),
                                              ),
                                              const SizedBox(width: 14),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      line.tenLine,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontSize: (AppFontSize
                                                                    .sizeMedium ??
                                                                20) -
                                                            1,
                                                        color: const Color(
                                                          0xFF211A19,
                                                        ),
                                                      ),
                                                    ),
                                                    // const SizedBox(height: 6),
                                                    // Text(
                                                    //   'Mã line: ${line.idLineCheckin}',
                                                    //   style: TextStyle(
                                                    //     color: Colors.grey[700],
                                                    //     fontWeight:
                                                    //         FontWeight.w500,
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              AnimatedContainer(
                                                duration: const Duration(
                                                  milliseconds: 180,
                                                ),
                                                width: 28,
                                                height: 28,
                                                decoration: BoxDecoration(
                                                  color: isSelected
                                                      ? AppColor.primaryColor
                                                      : Colors.transparent,
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: isSelected
                                                        ? AppColor.primaryColor
                                                        : Colors.grey.shade400,
                                                  ),
                                                ),
                                                child: Icon(
                                                  Icons.check,
                                                  size: 16,
                                                  color: isSelected
                                                      ? Colors.white
                                                      : Colors.transparent,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColor.primaryColor,
                                accentDark,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: AppColor.primaryColor
                                    .withValues(alpha: 0.18),
                                blurRadius: 16,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: _isSubmitting ? null : _confirmSelection,
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              shadowColor: Colors.transparent,
                              backgroundColor: Colors.transparent,
                              disabledBackgroundColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: _isSubmitting
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    widget.allowBack
                                        ? 'Lưu thay đổi line'
                                        : 'Xác nhận line check-in',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: widget.allowBack
                              ? () => Navigator.maybePop(context)
                              : _logout,
                          child: Text(
                            widget.allowBack ? 'Hủy' : 'Đăng xuất',
                            style: TextStyle(
                              color: accentDark,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
