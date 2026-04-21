import 'package:checkin/app/app_sp.dart';
import 'package:checkin/app/app_sp_key.dart';
import 'package:checkin/base/base_page.dart';
import 'package:checkin/constants/app_color.dart';
import 'package:checkin/model/statistics.model.dart';
import 'package:checkin/viewmodel/statistics.vm.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:stacked/stacked.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  final StatisticsViewModel _viewModel = StatisticsViewModel();

  @override
  Widget build(BuildContext context) {
    const background = Color(0xFFF8F3F1);
    const deepRose = Color(0xFF7A1621);

    return ViewModelBuilder<StatisticsViewModel>.reactive(
      disposeViewModel: false,
      viewModelBuilder: () => _viewModel,
      onViewModelReady: (viewModel) async {
        await viewModel.loadStatistics();
      },
      builder: (context, viewModel, child) {
        final overview = viewModel.overview;
        final summary = overview?.thongKe;

        return BasePage(
          title: 'Báo Cáo Check-in',
          showLogo: true,
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  background,
                  Colors.white,
                ],
              ),
            ),
            child: RefreshIndicator(
              onRefresh: viewModel.loadStatistics,
              color: AppColor.primaryColor,
              child: viewModel.isBusy
                  ? Center(
                      child: LoadingAnimationWidget.threeRotatingDots(
                        color: AppColor.primaryColor,
                        size: 50,
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColor.primaryColor,
                                deepRose,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: AppColor.primaryColor
                                    .withValues(alpha: 0.16),
                                blurRadius: 18,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Tổng quan sự kiện',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Thống kê theo ${viewModel.isSingleCheckin ? 'check-in 1 lần' : 'nhiều lượt check-in'} cho sự kiện ${AppSP.get(AppSPKey.tenTK) ?? ''}.',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.88),
                                  height: 1.4,
                                ),
                              ),
                              if ((AppSP.get(AppSPKey.tenLineCheckin) ?? '')
                                  .isNotEmpty) ...[
                                const SizedBox(height: 14),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.alt_route_rounded,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Line hiện tại: ${AppSP.get(AppSPKey.tenLineCheckin) ?? ''}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
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
                        if (summary != null)
                          _StatisticMetricsCard(
                            summary: summary,
                            isSingleCheckin: viewModel.isSingleCheckin,
                          )
                        else
                          const _EmptyState(
                            message: 'Chưa có dữ liệu thống kê để hiển thị',
                          ),
                        const SizedBox(height: 16),
                        if (viewModel.groupedStatistics.isNotEmpty) ...[
                          ...viewModel.groupedStatistics.asMap().entries.map(
                                (entry) => _StatisticMetricsCard(
                                  title: entry.value.nhomThongKe,
                                  index: entry.key + 1,
                                  summary: entry.value.thongKe,
                                  isSingleCheckin: viewModel.isSingleCheckin,
                                ),
                              ),
                        ] else if (!viewModel.isBusy) ...[
                          const _EmptyState(
                            message: 'Chưa có nhóm thống kê chi tiết',
                          ),
                        ],
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}

class _StatisticMetricsCard extends StatelessWidget {
  const _StatisticMetricsCard({
    this.title,
    this.index,
    required this.summary,
    required this.isSingleCheckin,
  });

  final String? title;
  final int? index;
  final StatisticSummary summary;
  final bool isSingleCheckin;

  @override
  Widget build(BuildContext context) {
    final hasTitle = (title?.trim().isNotEmpty ?? false);
    final metrics = isSingleCheckin
        ? <_MetricTextData>[
            _MetricTextData(
              label: 'Tổng người tham dự',
              value: summary.tongNguoiThamDu,
              color: const Color(0xFFD8941A),
            ),
            _MetricTextData(
              label: 'Đã check-in xong',
              value: summary.daCheckinXong,
              color: const Color(0xFF17823B),
            ),
            _MetricTextData(
              label: 'Đang check-in',
              value: summary.dangCheckin,
              color: const Color(0xFFE58A2C),
            ),
            _MetricTextData(
              label: 'Chưa từng check-in',
              value: summary.chuaTungCheckin,
              color: const Color(0xFFD81B1B),
            ),
          ]
        : <_MetricTextData>[
            _MetricTextData(
              label: 'Tổng người tham dự',
              value: summary.tongNguoiThamDu,
              color: const Color(0xFFD8941A),
            ),
            _MetricTextData(
              label: 'Đã check in',
              value: summary.daCheckin,
              color: const Color(0xFF17823B),
            ),
            _MetricTextData(
              label: 'Chưa check in',
              value: summary.chuaCheckin,
              color: const Color(0xFFD81B1B),
            ),
          ];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasTitle) ...[
            Text(
              index == null ? title!.trim() : '$index. ${title!.trim()}',
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
          ],
          Wrap(
            spacing: 18,
            runSpacing: 10,
            alignment: hasTitle ? WrapAlignment.start : WrapAlignment.center,
            children: metrics
                .map<Widget>(
                  (metric) => RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: [
                        TextSpan(
                          text: '${metric.label}: ',
                          style: TextStyle(
                            color: metric.color,
                            fontWeight: FontWeight.w700,
                            fontSize: hasTitle ? 16 : 17,
                          ),
                        ),
                        TextSpan(
                          text: '${metric.value}',
                          style: TextStyle(
                            color: metric.color,
                            fontWeight: FontWeight.w800,
                            fontSize: hasTitle ? 16 : 17,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.insights_outlined, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricTextData {
  const _MetricTextData({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final int value;
  final Color color;
}
