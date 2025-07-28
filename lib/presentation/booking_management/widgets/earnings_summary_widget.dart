import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EarningsSummaryWidget extends StatelessWidget {
  final Map<String, dynamic> earningsData;

  const EarningsSummaryWidget({
    Key? key,
    required this.earningsData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppTheme.darkTheme.cardColor
            : AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? AppTheme.shadowDark : AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Earnings Summary',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  color: isDarkMode
                      ? AppTheme.textPrimaryDark
                      : AppTheme.textPrimaryLight,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: (isDarkMode
                          ? AppTheme.primaryDark
                          : AppTheme.primaryLight)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'This Month',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: isDarkMode
                        ? AppTheme.primaryDark
                        : AppTheme.primaryLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Earnings Cards
          Row(
            children: [
              Expanded(
                child: _buildEarningsCard(
                  context,
                  'Total Earnings',
                  earningsData["totalEarnings"] as String,
                  CustomIconWidget(
                    iconName: 'account_balance_wallet',
                    color: AppTheme.successLight,
                    size: 24,
                  ),
                  AppTheme.successLight,
                  isDarkMode,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildEarningsCard(
                  context,
                  'Pending Payouts',
                  earningsData["pendingPayouts"] as String,
                  CustomIconWidget(
                    iconName: 'schedule',
                    color: AppTheme.warningLight,
                    size: 24,
                  ),
                  AppTheme.warningLight,
                  isDarkMode,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          Row(
            children: [
              Expanded(
                child: _buildEarningsCard(
                  context,
                  'Active Bookings',
                  '${earningsData["activeBookings"]}',
                  CustomIconWidget(
                    iconName: 'event_available',
                    color: isDarkMode
                        ? AppTheme.primaryDark
                        : AppTheme.primaryLight,
                    size: 24,
                  ),
                  isDarkMode ? AppTheme.primaryDark : AppTheme.primaryLight,
                  isDarkMode,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildEarningsCard(
                  context,
                  'Occupancy Rate',
                  '${earningsData["occupancyRate"]}%',
                  CustomIconWidget(
                    iconName: 'trending_up',
                    color: AppTheme.successLight,
                    size: 24,
                  ),
                  AppTheme.successLight,
                  isDarkMode,
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Earnings Chart
          Text(
            'Monthly Earnings Trend',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: isDarkMode
                  ? AppTheme.textPrimaryDark
                  : AppTheme.textPrimaryLight,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 2.h),

          Container(
            height: 25.h,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1000,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: (isDarkMode
                              ? AppTheme.dividerDark
                              : AppTheme.dividerLight)
                          .withValues(alpha: 0.5),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        const months = [
                          'Jan',
                          'Feb',
                          'Mar',
                          'Apr',
                          'May',
                          'Jun'
                        ];
                        if (value.toInt() >= 0 &&
                            value.toInt() < months.length) {
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(
                              months[value.toInt()],
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: isDarkMode
                                    ? AppTheme.textSecondaryDark
                                    : AppTheme.textSecondaryLight,
                              ),
                            ),
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 2000,
                      reservedSize: 42,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(
                            '${(value / 1000).toStringAsFixed(0)}K',
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: isDarkMode
                                  ? AppTheme.textSecondaryDark
                                  : AppTheme.textSecondaryLight,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: (isDarkMode
                            ? AppTheme.dividerDark
                            : AppTheme.dividerLight)
                        .withValues(alpha: 0.5),
                  ),
                ),
                minX: 0,
                maxX: 5,
                minY: 0,
                maxY: 8000,
                lineBarsData: [
                  LineChartBarData(
                    spots: (earningsData["monthlyData"] as List)
                        .asMap()
                        .entries
                        .map((entry) {
                      return FlSpot(entry.key.toDouble(),
                          (entry.value as num).toDouble());
                    }).toList(),
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: [
                        isDarkMode
                            ? AppTheme.primaryDark
                            : AppTheme.primaryLight,
                        (isDarkMode
                                ? AppTheme.primaryDark
                                : AppTheme.primaryLight)
                            .withValues(alpha: 0.3),
                      ],
                    ),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: isDarkMode
                              ? AppTheme.primaryDark
                              : AppTheme.primaryLight,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          (isDarkMode
                                  ? AppTheme.primaryDark
                                  : AppTheme.primaryLight)
                              .withValues(alpha: 0.3),
                          (isDarkMode
                                  ? AppTheme.primaryDark
                                  : AppTheme.primaryLight)
                              .withValues(alpha: 0.1),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
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

  Widget _buildEarningsCard(
    BuildContext context,
    String title,
    String value,
    Widget icon,
    Color accentColor,
    bool isDarkMode,
  ) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              icon,
              Container(
                padding: EdgeInsets.all(1.w),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: CustomIconWidget(
                  iconName: 'trending_up',
                  color: accentColor,
                  size: 12,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: accentColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: isDarkMode
                  ? AppTheme.textSecondaryDark
                  : AppTheme.textSecondaryLight,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
