class Payment < ActiveRecord::Base
	belongs_to :sale

	def amount_after_change
		value = self.sale.total_amount - self.amount

		if value >= 0
			return self.amount
		else
			return self.sale.total_amount
		end
				
	end
end
