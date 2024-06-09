class FinancialSummaryService
  attr_reader :date, :total_revenue, :total_expense, :profit

  def initialize(date:)
    @date = date
  end

  #simple_calendarのeventオブジェクトに持たせる
  def start_time
    date
  end

  def self.summarize(month)
    # 既に計上された月の伝票と経費を取得
    receipts = Receipt.for_month(month)
    expenditures = Expenditure.for_month(month)

    # 一意の日付リスト（配列）を作成
    summary_dates = (receipts.pluck(:recorded_at) + expenditures.pluck(:recorded_at)).uniq

    # FinancialSummaryServiceオブジェクトとして一意の日付を返す
    summary_dates.map do |date|
      FinancialSummaryService.new(date: date)
    end
  end

  # 日次集計
  def self.daily_summary(date)
    summarize_by_period(date, :daily)
  end

  # 月次集計
  def self.monthly_summary(month)
    summarize_by_period(month, :monthly)
  end

  #受け取るタイプによって、日次または月次の集計を行う
  def self.summarize_by_period(period, type)
    receipts = type == :daily ? Receipt.where(recorded_at: period) : Receipt.for_month(period)
    expenditures = type == :daily ? Expenditure.where(recorded_at: period) : Expenditure.for_month(period)

    total_revenue = receipts.sum { |receipt| (receipt.food_value || 0) + (receipt.drink_value || 0) }
    total_expense = expenditures.sum { |expenditure| expenditure.expense_value }
    profit = total_revenue - total_expense

    if type == :daily
      {
        date: period,
        total_revenue: total_revenue,
        total_expense: total_expense,
        profit: profit
      }
    else
      {
        total_revenue: total_revenue,
        total_expense: total_expense,
        profit: profit
      }
    end
  end

  # 日次集計の計上
  def self.compile_for_date(date)
    receipts = Receipt.where(recorded_at: date, compiled_at: nil)
    expenditures = Expenditure.where(recorded_at: date, compiled_at: nil)

    return false if receipts.empty? || expenditures.empty?

    ActiveRecord::Base.transaction do
      receipts.update_all(compiled_at: Time.zone.now, status: 1)
      expenditures.update_all(compiled_at: Time.zone.now, status: 1)
    end

    true
  end
end
