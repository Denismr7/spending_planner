class BarChartInsightsData {
  const BarChartInsightsData({
    required this.label,
    required this.value,
    this.isCurrentDate = false,
  });

  final double value;
  final String label;
  final bool isCurrentDate;
}
