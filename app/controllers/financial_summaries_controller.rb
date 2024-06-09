# frozen_string_literal: true

class FinancialSummariesController < ApplicationController
  before_action :authorize_financial

  def index
    @month = parse_month(params[:month]) || Date.today.beginning_of_month
    @summaries = FinancialSummaryService.summarize(@month)
    @monthly_summary = FinancialSummaryService.monthly_summary(@month)
  end

  def show
    date = Date.parse(params[:date])
    @daily_summary = FinancialSummaryService.daily_summary(date)
  end

  def compile
    begin
      date = Date.parse(params[:compile][:date])
      if FinancialSummaryService.compile_for_date(date)
        flash[:success] = t('.success', summary_date: date.strftime('%Y年%m月%d日'))
      else
        flash[:danger] = t('.records_not_found', summary_date: date.strftime('%Y年%m月%d日'))
      end
    rescue ArgumentError
      flash[:danger] = t('.invalid_date')
    end
    redirect_to financial_summaries_path
  end

  private

  def authorize_financial
    authorize :financial_summary
  end

  def parse_month(month)
    Date.strptime(month, '%Y-%m')
  rescue StandardError
    nil
  end
end
