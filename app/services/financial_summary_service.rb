# frozen_string_literal: true

class FinancialSummaryService
  attr_reader :date, :total_revenue, :total_expense, :profit

  def initialize(date:)
    @date = date
  end

  # simple_calendarのeventオブジェクトに持たせる
  def start_time
    date
  end

  def self.summarize(month, user)
    # 既に計上された月の伝票と経費を取得
    receipts = Receipt.for_month(month).for_user(user)
    expenditures = Expenditure.for_month(month).for_user(user)

    # 一意の日付リスト（配列）を作成
    summary_dates = (receipts.pluck(:recorded_at) + expenditures.pluck(:recorded_at)).uniq

    # FinancialSummaryServiceオブジェクトとして一意の日付を返す
    summary_dates.map do |date|
      FinancialSummaryService.new(date: date)
    end
  end

  # 日次集計
  def self.daily_summary(date, user)
    summarize_by_period(date, :daily, user)
  end

  # 月次集計
  def self.monthly_summary(month, user)
    summarize_by_period(month, :monthly, user)
  end

  # 受け取るタイプによって、日次または月次の集計を行う
  def self.summarize_by_period(period, type, user)
    receipts = type == :daily ? Receipt.where(recorded_at: period, user: user) : Receipt.for_month(period).for_user(user)
    expenditures = type == :daily ? Expenditure.where(recorded_at: period, user: user) : Expenditure.for_month(period).for_user(user)

    total_revenue = receipts.sum { |receipt| (receipt.food_value || 0) + (receipt.drink_value || 0) }
    total_expense = expenditures.sum(&:expense_value)
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
  def self.compile_for_date(date, user)
    receipts = Receipt.where(recorded_at: date, compiled_at: nil, user: user)
    expenditures = Expenditure.where(recorded_at: date, compiled_at: nil, user: user)

    return false if receipts.empty? || expenditures.empty?

    ActiveRecord::Base.transaction do
      receipts.update_all(compiled_at: Time.zone.now, status: 2)
      expenditures.update_all(compiled_at: Time.zone.now, status: 1)
    end

    true
  end
end
