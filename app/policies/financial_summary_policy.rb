# frozen_string_literal: true

FinancialSummaryPolicy = Struct.new(:user, :financial_summary) do
  def index?
    user.common?
  end

  def show?
    user.common?
  end

  def compile?
    user.common?
  end
end
