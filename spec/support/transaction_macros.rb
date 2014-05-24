module TransactionMacros

  def generate_plans
    create(:free_product)
    create(:paid6_product)
    create(:paid12_product)
  end

end
