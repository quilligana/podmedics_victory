module TransactionMacros

  def generate_plans
    create(:free_product)
    create(:paid_product)
  end

end
